//
//  FMLayoutDynamicSection.m
//  FMLayoutKit
//
//  Created by 周发明 on 2020/4/1.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutDynamicSection.h"
#import "FMCollectionLayoutAttributes.h"
#import "FMLayoutHeader.h"
#import "FMLayoutFooter.h"

@interface FMLayoutDynamicSection ()

@property(nonatomic, strong)NSMapTable *autoHeightCells;

@end

@implementation FMLayoutDynamicSection

- (NSMapTable *)autoHeightCells{
    if (_autoHeightCells == nil) {
        _autoHeightCells = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory];
    }
    return _autoHeightCells;
}

- (CGFloat)autoHeightVerticalWithWidth:(CGFloat)fixedWidth index:(NSInteger)index{
    CGFloat itemOther = 0;
    if (self.direction == FMLayoutDirectionHorizontal) {
        @throw [NSException exceptionWithName:@"autoHeightFixedWidth must for FMLayoutDirectionVertical" reason:@"FMLayoutDynamicSection" userInfo:nil];
    }
    if (self.deqCellReturnElement) {
        FMLayoutElement *element = self.deqCellReturnElement(self, index);
        UICollectionViewCell *cell = [self.autoHeightCells objectForKey:element.viewClass];
        if (cell == nil) {
            if (element.isNib) {
                cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(element.viewClass) owner:nil options:nil] lastObject];
            } else {
                cell = [[element.viewClass alloc] init];
            }
            [self.autoHeightCells setObject:cell forKey:element.viewClass];
        }
        if (self.configurationCell) {
            self.configurationCell(self ,cell, index);
        }
        itemOther = [cell systemLayoutSizeFittingSize:CGSizeMake(fixedWidth, MAXFLOAT)].height;
    }
    if (self.autoHeightLaterHander) {
        itemOther = self.autoHeightLaterHander(self, index, itemOther);
    }
    return itemOther;
}

- (id)copyWithZone:(NSZone *)zone{
    FMLayoutDynamicSection *section = [super copyWithZone:zone];
    section.autoHeightFixedWidth = self.autoHeightFixedWidth;
    section.cellFixedSize = self.cellFixedSize;
    NSMutableArray *arrM = [NSMutableArray array];
    for (FMLayoutElement *element in self.cellElements) {
        [arrM addObject:[element copy]];
    }
    section.cellElements = arrM;
    section.deqCellReturnElement = [self.deqCellReturnElement copy];
    section.autoHeightLaterHander = [self.autoHeightLaterHander copy];
    section.configurationCell = [self.configurationCell copy];
    section.otherBlock = [self.otherBlock copy];
    return section;
}

- (void)setCellFixedSize:(CGFloat)cellFixedSize{
    _cellFixedSize = cellFixedSize;
    self.hasHandle = NO;
}

- (void)setCellElements:(NSArray<FMLayoutElement *> *)cellElements{
    _cellElements = cellElements;
    self.hasHandle = NO;
}

- (void)setCellElement:(FMLayoutElement *)cellElement{
    _cellElement = cellElement;
    self.cellElements = @[cellElement];
    __weak typeof(self) weakSelf = self;
    [self setDeqCellReturnElement:^FMLayoutElement * _Nonnull(FMLayoutDynamicSection * _Nonnull section, NSInteger index) {
        return weakSelf.cellElement;
    }];
}

- (void)setConfigureCellData:(void (^)(FMLayoutBaseSection * _Nonnull, UICollectionViewCell * _Nonnull, NSInteger))configureCellData{
    [super setConfigureCellData:configureCellData];
    if (!self.configurationCell && self.autoHeightFixedWidth) {
        self.configurationCell = configureCellData;
    }
}

- (FMCollectionLayoutAttributes *)getItemAttributesWithIndex:(NSInteger)j{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:self.indexPath.section];
    FMCollectionLayoutAttributes *itemAttr = [FMCollectionLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat itemFixed = self.cellFixedSize;
    CGFloat itemOther = 0;
    if (self.autoHeightFixedWidth) {
        itemOther = [self autoHeightVerticalWithWidth:itemFixed index:j];
    } else {
        itemOther = !self.otherBlock?0:self.otherBlock(self, j);
    }
    if (self.direction == FMLayoutDirectionVertical) {
        CGSize itemSize = CGSizeMake(itemFixed, itemOther);
        NSInteger column = [self getMinHeightColumn];
        CGFloat x = self.sectionInset.left + column * (self.itemSpace + itemSize.width);
        CGFloat height = [self.columnSizes[@(column)] floatValue];
        CGFloat y = self.firstItemStartY + (height > 0 ? (height + self.lineSpace) : height);
        itemAttr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
        self.columnSizes[@(column)] = @(height + itemSize.height + (height > 0 ? self.lineSpace : 0));
    } else {
        CGSize itemSize = CGSizeMake(itemOther, itemFixed);
        NSInteger column = [self getMinHeightColumn];
        CGFloat minWidth = [self.columnSizes[@(column)] floatValue];
        CGFloat x = self.firstItemStartX + (minWidth > 0 ? (minWidth + self.itemSpace) : minWidth);
        CGFloat y = self.firstItemStartY + column * (self.lineSpace + itemSize.height);
        itemAttr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
        self.columnSizes[@(column)] = @(minWidth + itemSize.width + (minWidth > 0 ? self.itemSpace : 0));
    }
    if (self.configureCellLayoutAttributes) {
        self.configureCellLayoutAttributes(self, itemAttr, j);
    }
    return itemAttr;
}

- (UICollectionViewCell *)dequeueReusableCellForIndexPath:(NSIndexPath *)indexPath collectionView:(nonnull UICollectionView *)collectionView{
    if (!self.deqCellReturnElement) {
        @throw [NSException exceptionWithName:@"dynamic section must have to set deqCellReturnElement value" reason:@"FMLayoutDynamicSection" userInfo:nil];
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:self.deqCellReturnElement(self, indexPath.item).reuseIdentifier forIndexPath:indexPath];
}

- (void)registerCellsWithCollectionView:(UICollectionView *)collectionView{
    for (FMLayoutElement *element in self.cellElements) {
        [element registerElementWithCollection:collectionView];
    }
}

- (CGFloat)crossSingleSectionSize{
    if (self.itemCount == 0 || self.column == 0) {
        return 0;
    }
    CGFloat maxSize = 0;
    if (self.itemCount > self.column) {
        maxSize = self.column * self.cellFixedSize + (self.column - 1) * self.lineSpace;
    } else {
        maxSize = self.itemCount * self.cellFixedSize + (self.itemCount - 1) * self.lineSpace;
    }
    if (self.direction == FMLayoutDirectionHorizontal) {
        maxSize += self.sectionInset.top + self.sectionInset.bottom;
    } else {
        maxSize += self.sectionInset.left + self.sectionInset.right;
    }
    return maxSize;
}

@end
