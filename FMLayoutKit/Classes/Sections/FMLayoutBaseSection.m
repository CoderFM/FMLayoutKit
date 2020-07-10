//
//  FMLayoutBaseSection.m
//  FMLayoutKit
//
//  Created by 周发明 on 2020/3/20.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutBaseSection.h"
#import "FMLayoutFooter.h"
#import "FMLayoutHeader.h"
#import "FMLayoutBackground.h"
#import "FMCollectionLayoutAttributes.h"
#import "FMKVOArrayObject.h"

@interface FMLayoutBaseSection ()

@property(nonatomic, strong)FMKVOArrayObject *kvoArray;

@end

@implementation FMLayoutBaseSection

- (id)copyWithZone:(NSZone *)zone{
    FMLayoutBaseSection *section = [[[self class] allocWithZone:zone] init];
    
    section.hasHandle = NO;
    section.handleItemStart = 0;
    section.handleType = FMLayoutHandleTypeReLayout;
    section.changeOffset = 0;
    
    section.sectionInset = self.sectionInset;
    section.header = [self.header copy];
    section.footer = [self.footer copy];
    section.background = [self.background copy];
    
    section.column = self.column;
    section.lineSpace = self.lineSpace;
    section.itemSpace = self.itemSpace;
    section.configureCellLayoutAttributes = [self.configureCellLayoutAttributes copy];
    
    section.itemDatas = [self.itemDatas copy];
    
    return section;
}

- (void)dealloc{
    FMLayoutLog([NSString stringWithFormat:@"%@ dealloc", NSStringFromClass([self class])]);
    [self.kvoArray removeObserver:self forKeyPath:@"targetArray" context:nil];
}

- (NSInteger)itemCount{
    return self.itemDatas.count;
}

- (void)setHeader:(FMLayoutHeader *)header{
    _header = header;
    self.hasHandle = NO;
}

- (void)setFooter:(FMLayoutFooter *)footer{
    _footer = footer;
    self.hasHandle = NO;
}

- (void)setBackground:(FMLayoutBackground *)background{
    _background = background;
    self.hasHandle = NO;
}

- (void)setLineSpace:(CGFloat)lineSpace{
    _lineSpace = lineSpace;
    self.hasHandle = NO;
}

- (void)setItemSpace:(CGFloat)itemSpace{
    _itemSpace = itemSpace;
    self.hasHandle = NO;
}

- (void)setColumn:(NSInteger)column{
    _column = column;
    self.hasHandle = NO;
}

- (void)setDirection:(FMLayoutDirection)direction{
    if (_direction == direction) {
        return;
    }
    _direction = direction;
    self.hasHandle = NO;
}

+ (instancetype)sectionWithSectionInset:(UIEdgeInsets)inset itemSpace:(CGFloat)itemSpace lineSpace:(CGFloat)lineSpace column:(NSInteger)column{
    FMLayoutBaseSection *section = [[self alloc] init];
    section.sectionInset = inset;
    section.itemSpace = itemSpace;
    section.lineSpace = lineSpace;
    section.column = column;
    [section resetcolumnSizes];
    return section;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.kvoArray = [[FMKVOArrayObject alloc] init];
        [self.kvoArray addObserver:self forKeyPath:@"targetArray" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)setHandleItemStart:(NSInteger)handleItemStart{
    if (handleItemStart < _handleItemStart) {
        _handleItemStart = handleItemStart;
        self.handleType = FMLayoutHandleTypeReLayout;
    }
    if (self.handleType == FMLayoutHandleTypeReLayout && _handleItemStart == self.itemsAttribute.count) {
        self.handleType = FMLayoutHandleTypeAppend;
    }
}

- (NSMutableArray *)itemDatas{
    return [self.kvoArray mutableArrayValueForKey:@"targetArray"];
}

- (void)setItemDatas:(NSMutableArray *)itemDatas{

    if (self.kvoArray.targetArray == itemDatas) {
        return;
    }
    self.hasHandle = NO;
    self.handleType = FMLayoutHandleTypeReLayout;
    
    if (self.kvoArray.targetArray) {
        [self.kvoArray removeObserver:self forKeyPath:@"targetArray" context:nil];
    }

    if (![itemDatas isKindOfClass:[NSMutableArray class]]) {
        self.kvoArray.targetArray = [itemDatas mutableCopy];
        [self.kvoArray addObserver:self forKeyPath:@"targetArray" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    } else {
        self.kvoArray.targetArray = itemDatas;
        [self.kvoArray addObserver:self forKeyPath:@"targetArray" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"targetArray"]) {
        self.hasHandle = NO;
//        NSInteger kind = [change[@"kind"] integerValue];
        NSIndexSet *set = change[@"indexes"];
        self.handleItemStart = set.firstIndex;
//        if (kind == 2) { //增加 需判断是插入 还是
//
//        }
//        /*
//         NSKeyValueChangeSetting = 1,
//         NSKeyValueChangeInsertion = 2,  //插入
//         NSKeyValueChangeRemoval = 3, // 移除
//         NSKeyValueChangeReplacement = 4, // 替换
//         */
//
    }
    FMLayoutLog([NSString stringWithFormat:@"base section itemDatas changeed %@", change]);
}

- (CGFloat)firstItemStartY{
    if (self.direction == FMLayoutDirectionVertical) {
        return self.sectionOffset + self.sectionInset.top + self.header.inset.top + self.header.size + self.header.inset.bottom + self.header.lastMargin;
    } else {
        return self.sectionInset.top;
    }
}

- (CGFloat)firstItemStartX{
    if (self.direction == FMLayoutDirectionVertical) {
        return self.sectionInset.left;
    } else {
        return self.sectionOffset + self.sectionInset.left + self.header.inset.left + self.header.size + self.header.inset.right + self.header.lastMargin;
    }
}

- (void)markChangeAt:(NSInteger)index{
    self.hasHandle = NO;
    self.handleItemStart = index;
}

- (void)handleLayout{
    if (self.header) {
        [self prepareHeader];
    }
    [self prepareItems];
    if (self.footer) {
        [self prepareFooter];
    }
    if (self.direction == FMLayoutDirectionVertical) {
        self.sectionSize = self.sectionInset.top + self.header.inset.top +self.header.size + self.header.inset.bottom + self.header.lastMargin + [self getColumnMaxHeight] + self.footer.inset.top + self.footer.size +  self.footer.topMargin + self.footer.inset.bottom + self.sectionInset.bottom;
    } else {
        self.sectionSize = self.sectionInset.left + self.header.inset.left +self.header.size + self.header.inset.right + self.header.lastMargin + [self getColumnMaxHeight] + self.footer.inset.left + self.footer.size +  self.footer.topMargin + self.footer.inset.right + self.sectionInset.right;
    }
    [self prepareBackground];
}


- (BOOL)intersectsRect:(CGRect)rect{
    if (self.direction == FMLayoutDirectionVertical) {
        return CGRectIntersectsRect(CGRectMake(0, self.sectionOffset, self.collectionView.frame.size.width, self.sectionSize), rect);
    } else {
        return CGRectIntersectsRect(CGRectMake(self.sectionOffset, 0, self.sectionSize, self.collectionView.frame.size.height), rect);
    }
}

- (void)prepareHeader{
    if (self.handleType == FMLayoutHandleTypeOlnyChangeOffset && self.headerAttribute) {
        [self.headerAttribute updateHeaderAttributesWithSection:self];
        return;
    }
    self.headerAttribute = [FMCollectionLayoutAttributes headerAttributesWithSection:self];
}

- (void)prepareFooter{
    if (self.handleType == FMLayoutHandleTypeOlnyChangeOffset && self.footerAttribute) {
        [self.footerAttribute updateFooterAttributesWithSection:self];
        return;
    }
    self.footerAttribute = [FMCollectionLayoutAttributes footerAttributesWithSection:self];
}

- (void)prepareItems{
    if ([self prepareLayoutItemsIsOlnyChangeOffset]) return;
    [self resetcolumnSizes];
    NSInteger items = [self.collectionView numberOfItemsInSection:self.indexPath.section];
    NSMutableArray *attrs = [NSMutableArray array];
    int first = 0;
    if (self.handleType == FMLayoutHandleTypeAppend) {
        attrs = [self.itemsAttribute mutableCopy];
        first = (int)self.handleItemStart;
    }
    for (int j = first; j < items; j++) {
        [attrs addObject:[self getItemAttributesWithIndex:j]];
    }
    self.itemsAttribute = [attrs copy];
}

- (void)prepareBackground{
    if (self.handleType == FMLayoutHandleTypeOlnyChangeOffset && self.bgAttribute) {
        [self.bgAttribute updateBgAttributesWithSection:self];
        return;
    }
    if (self.background) {
        self.bgAttribute = [FMCollectionLayoutAttributes bgAttributesWithSection:self];
    }
}

///头部悬停布局计算
- (UICollectionViewLayoutAttributes *)showHeaderLayout{
    if (self.header.type == FMLayoutHeaderTypeFixed) {
        return self.headerAttribute;
    }
    UICollectionViewLayoutAttributes *show = [FMCollectionLayoutAttributes suspensionShowHeaderAttributes:self];
    if (show) {
        return show;
    }
    return self.headerAttribute;
}
/// 判断是否只改变偏移量
- (BOOL)prepareLayoutItemsIsOlnyChangeOffset{
    if (self.handleType == FMLayoutHandleTypeOlnyChangeOffset) {
        [self.itemsAttribute enumerateObjectsUsingBlock:^(FMCollectionLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.indexPath = [NSIndexPath indexPathForItem:idx inSection:self.indexPath.section];
            obj.direction = self.direction;
            [obj _onlyUpdateOffsetWith:self];
        }];
        return YES;
    } else {
        return NO;
    }
}

///获取最小高度的列
- (NSInteger)getMinHeightColumn{
    if (self.columnSizes.allKeys.count == 0) {
        return 0;
    }
    NSInteger column = 0;
    CGFloat minHeight = [self.columnSizes[@0] floatValue];
    for (int i = 1; i<self.column; i++) {
        CGFloat height = [self.columnSizes[@(i)] floatValue];
        if (height < minHeight) {
            column = i;
            minHeight = height;
        }
    }
    return column;
}
///获取最所有列的最大高度
- (CGFloat)getColumnMaxHeight{
    if (self.columnSizes.allKeys.count == 0) {
        return 0;
    }
    CGFloat maxHeight = [self.columnSizes[@0] floatValue];
    for (int i = 1; i<self.column; i++) {
        CGFloat height = [self.columnSizes[@(i)] integerValue];
        if (height > maxHeight) {
            maxHeight = height;
        }
    }
    return maxHeight;
}
///重置所有列的高度缓存
- (void)resetcolumnSizes{
    self.columnSizes = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.column; i++) {
        self.columnSizes[@(i)] = @0;
    }
}

- (CGFloat)crossSingleSectionSize{
    return 0;
}

- (UICollectionViewCell *)dequeueReusableCellForIndexPath:(NSIndexPath *)indexPath{
    return [self dequeueReusableCellForIndexPath:indexPath collectionView:self.collectionView];
}

- (UICollectionViewCell *)dequeueReusableCellForIndexPath:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView{
    @throw [NSException exceptionWithName:@"child class must implementation this method" reason:@"FMLayoutBaseSection" userInfo:nil];
}

- (void)registerCells{
    [self registerCellsWithCollectionView:self.collectionView];
}

- (void)registerCellsWithCollectionView:(UICollectionView *)collectionView{
    
}

- (FMCollectionLayoutAttributes *)getItemAttributesWithIndex:(NSInteger)j{
    @throw [NSException exceptionWithName:@"child class must implementation this method" reason:@"FMLayoutBaseSection" userInfo:nil];
}

@end
