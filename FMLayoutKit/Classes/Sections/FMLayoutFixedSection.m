//
//  FMLayoutFixedSection.m
//  FMLayoutKit
//
//  Created by 周发明 on 2020/4/1.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutFixedSection.h"
#import "FMCollectionLayoutAttributes.h"
#import "FMLayoutHeader.h"
#import "FMLayoutFooter.h"

@implementation FMLayoutFixedSection

- (id)copyWithZone:(NSZone *)zone{
    FMLayoutFixedSection *section = [super copyWithZone:zone];
    section.itemSize = self.itemSize;
    section.cellElement = [self.cellElement copy];
    return section;
}

- (void)setItemSize:(CGSize)itemSize{
    _itemSize = itemSize;
    self.hasHandle = NO;
}

- (void)setCellElement:(FMLayoutElement *)cellElement{
    _cellElement = cellElement;
    self.hasHandle = NO;
}

- (FMCollectionLayoutAttributes *)getItemAttributesWithIndex:(NSInteger)j{
    FMCollectionLayoutAttributes *itemAttr = [FMCollectionLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:j inSection:self.indexPath.section]];
    CGSize itemSize = self.itemSize;
    NSInteger column = [self getMinHeightColumn];
    
    if (self.direction == FMLayoutDirectionVertical) {
        CGFloat x = self.firstItemStartX + column * (self.itemSpace + itemSize.width);
        CGFloat height = [self.columnSizes[@(column)] floatValue];
        CGFloat y = self.firstItemStartY + (height > 0 ? (height + self.lineSpace) : height);
        itemAttr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
        self.columnSizes[@(column)] = @(height + itemSize.height + (height > 0 ? self.lineSpace : 0));
    } else {
        CGFloat height = [self.columnSizes[@(column)] floatValue];
        CGFloat x = self.firstItemStartX + (height > 0 ? (height + self.itemSpace) : height);
        CGFloat y = self.firstItemStartY + column * (self.lineSpace + itemSize.height);
        itemAttr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
        self.columnSizes[@(column)] = @(height + itemSize.width + (height > 0 ? self.itemSpace : 0));
    }
    
    if (self.configureCellLayoutAttributes) {
        self.configureCellLayoutAttributes(self, itemAttr, j);
    }
    
    return itemAttr;
}

- (UICollectionViewCell *)dequeueReusableCellForIndexPath:(NSIndexPath *)indexPath collectionView:(nonnull UICollectionView *)collectionView{
    return [collectionView dequeueReusableCellWithReuseIdentifier:self.cellElement.reuseIdentifier forIndexPath:indexPath];
}

- (void)registerCellsWithCollectionView:(UICollectionView *)collectionView{
    [self.cellElement registerElementWithCollection:collectionView];
}

- (CGFloat)crossSingleSectionSize{
    if (self.direction == FMLayoutDirectionHorizontal) {
        NSInteger itemCount = self.itemCount;
        if (itemCount == 0) {
            return self.sectionInset.top + self.sectionInset.bottom;
        }
        NSInteger singleCount = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right) / (self.itemSize.width + self.itemSpace);///单行可显示的最大个数
        if (itemCount > singleCount * self.column) { //可滚动
            singleCount = itemCount % self.column == 0 ? itemCount / self.column : (itemCount / self.column + 1);
        }
        NSInteger realLines = itemCount % singleCount == 0 ? itemCount / singleCount : (itemCount / singleCount + 1);
        return self.itemSize.height * realLines + (realLines - 1) * self.lineSpace + self.sectionInset.top + self.sectionInset.bottom;
    } else {
        NSInteger realLines = self.column;
        return self.itemSize.width * realLines + (realLines - 1) * self.itemSpace + self.sectionInset.left + self.sectionInset.right;
    }
}

@end
