//
//  FMLayoutCombineSection.m
//  FMLayoutKit
//
//  Created by 郑桂华 on 2020/7/12.
//

#import "FMLayoutCombineSection.h"
#import "FMCollectionLayoutAttributes.h"

#import "FMLayoutHeader.h"

@interface __FMCombineModel : NSObject

@property(nonatomic, assign)NSInteger start;
@property(nonatomic, strong)FMLayoutBaseSection *section;

@end

@implementation __FMCombineModel

@end

@interface FMLayoutCombineSection ()

@property(nonatomic, strong)NSArray<__FMCombineModel *> *sections;

@end

@implementation FMLayoutCombineSection

- (BOOL)canLongPressExchange{
    return NO;
}

- (NSArray<FMLayoutBaseSection *> *)subSections{
    return [self.sections valueForKey:@"section"];
}

- (id)copyWithZone:(NSZone *)zone{
    FMLayoutCombineSection *section = [super copyWithZone:zone];
    section.sections = [self.sections copy];
    return section;
}

- (NSInteger)itemCount{
    NSInteger count = 0;
    for (__FMCombineModel *combine in self.sections) {
        count += combine.section.itemCount;
    }
    return count;
}

+ (instancetype)combineSections:(NSArray<FMLayoutBaseSection *> *)sections{
    FMLayoutCombineSection *section = [[self alloc] init];
    [section resetSecionsWithSections:sections];
    return section;
}

- (void)appendSection:(FMLayoutBaseSection *)section{
    NSMutableArray *sections = [NSMutableArray arrayWithArray:self.subSections];
    [sections addObject:section];
    [self resetSecionsWithSections:sections];
}

- (void)insetSection:(FMLayoutBaseSection *)section atIndex:(NSInteger)index{
    NSMutableArray *sections = [NSMutableArray arrayWithArray:self.subSections];
    [sections insertObject:section atIndex:index];
    [self resetSecionsWithSections:sections];
}

- (void)resetSecionsWithSections:(NSArray<FMLayoutBaseSection *> *)sections{
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < sections.count; i++) {
        __FMCombineModel *com = [[__FMCombineModel alloc] init];
        com.section = sections[i];
        [arrM addObject:com];
    }
    self.sections = [arrM copy];
    self.hasHandle = NO;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.column = 1;
        __weak typeof(self) weakSelf = self;
        [self setClickCellBlock:^(FMLayoutBaseSection * _Nonnull section, NSInteger item) {
            for (__FMCombineModel *com in weakSelf.sections) {
                if (item < com.start + com.section.itemCount) {
                    if (com.section.clickCellBlock) {
                        com.section.clickCellBlock(com.section, item - com.start);
                    }
                    return;
                }
            }
        }];
        [self setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
            for (__FMCombineModel *com in weakSelf.sections) {
                if (item < com.start + com.section.itemCount) {
                    if (com.section.configureCellData) {
                        com.section.configureCellData(com.section, cell,item - com.start);
                    }
                    return;
                }
            }
        }];
    }
    return self;
}

- (void)handleLayout{
    NSInteger start = 0;
    for (__FMCombineModel *com in self.sections) {
        com.start = start;
        start += com.section.itemCount;
    }
    [super handleLayout];
}

- (void)prepareItems{
    [self resetcolumnSizes];
    CGFloat startOffset = self.direction == FMLayoutDirectionVertical ? self.firstItemStartY : self.firstItemStartX;
    CGFloat offset = startOffset;
    NSInteger start = 0;
    NSArray *sections = self.subSections;
    for (int i = 0; i < sections.count; i++) {
        FMLayoutBaseSection *section = sections[i];
        section.header = nil;
        section.footer = nil;
        section.background = nil;
        section.direction = self.direction;
        section.collectionView = self.collectionView;
        section.sectionOffset = offset;
        section.handleType = self.handleType;
        section.changeOffset = self.changeOffset;
        section.indexPath = self.indexPath;
        [section handleLayout];
        offset += section.sectionSize;
        [section.itemsAttribute enumerateObjectsUsingBlock:^(FMCollectionLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.indexPath = [NSIndexPath indexPathForItem:idx + start inSection:self.indexPath.section];
        }];
        section.changeOffset = 0;
        section.handleType = FMLayoutHandleTypeReLayout;
        section.hasHandle = YES;
        start += section.itemCount;
    }
    self.columnSizes[@0] = @(offset - startOffset);
}

- (NSArray *)showLayoutAttributesInRect:(CGRect)rect{
    NSMutableArray *attrs = [NSMutableArray array];
    if ([self intersectsRect:rect]) {
        if (self.headerAttribute) {
            UICollectionViewLayoutAttributes *showHeaderAttr = [self showHeaderLayout];
            if (CGRectIntersectsRect(rect, showHeaderAttr.frame)) {
                [attrs addObject:showHeaderAttr];
            }
        }
        if (self.footerAttribute) {
            if (CGRectIntersectsRect(rect, self.footerAttribute.frame)) {
                [attrs addObject:self.footerAttribute];
            }
        }
        if (self.bgAttribute) {
            if (CGRectIntersectsRect(rect, self.bgAttribute.frame)) {
                [attrs addObject:self.bgAttribute];
            }
        }
        NSArray *sections = self.subSections;
        for (FMLayoutBaseSection *section in sections) {
            NSArray *subAttrs = [section showLayoutAttributesInRect:rect];
            [attrs addObjectsFromArray:subAttrs];
        }
    } else {
        if (self.header.type == FMLayoutHeaderTypeSuspensionAlways) {
            if (self.headerAttribute) {
                UICollectionViewLayoutAttributes *showHeaderAttr = [self showHeaderLayout];
                if (CGRectIntersectsRect(rect, showHeaderAttr.frame)) {
                    [attrs addObject:showHeaderAttr];
                }
            }
        }
    }
    return attrs;
}

- (UICollectionViewCell *)dequeueReusableCellForIndexPath:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView{
    for (__FMCombineModel *com in self.sections) {
        if (indexPath.item < com.start + com.section.itemCount) {
            return [com.section dequeueReusableCellForIndexPath:indexPath collectionView:collectionView];
        }
    }
    @throw [NSException exceptionWithName:@"FMLayoutCombineSection instance dequeueReusableCellForIndexPath" reason:@"FMLayoutCombineSection" userInfo:nil];
}

- (void)registerCellsWithCollectionView:(UICollectionView *)collectionView{
    NSArray *sections = self.subSections;
    for (FMLayoutBaseSection *section in sections) {
        [section registerCellsWithCollectionView:collectionView];
    }
}

- (CGFloat)crossSingleSectionSize{
    CGFloat maxSize = self.direction == FMLayoutDirectionVertical ? self.firstItemStartY : self.firstItemStartX;
    NSArray *sections = self.subSections;
    for (FMLayoutBaseSection *section in sections) {
        CGFloat sectionSize = [section crossSingleSectionSize];
        if (maxSize < sectionSize) {
            maxSize = sectionSize;
        }
    }
    return maxSize;
}

@end
