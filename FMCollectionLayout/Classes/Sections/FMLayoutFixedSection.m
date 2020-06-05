//
//  FMLayoutFixedSection.m
//  FMLayoutKit
//
//  Created by 郑桂华 on 2020/4/1.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutFixedSection.h"
#import "FMCollectionLayoutAttributes.h"
#import "FMSupplementaryHeader.h"
#import "FMSupplementaryFooter.h"
#import "FMHorizontalScrollCollCell.h"

@implementation FMLayoutFixedSection

- (void)setItemSize:(CGSize)itemSize{
    _itemSize = itemSize;
    self.hasHandle = NO;
}

- (void)prepareItems{
    if (self.isHorizontalCanScroll) {
        FMCollectionLayoutAttributes *itemAttr = [FMCollectionLayoutAttributes layoutAttributesForCellWithIndexPath:self.indexPath];
        NSInteger itemCount = self.itemDatas.count;
        NSInteger singleCount = self.collectionView.bounds.size.width / (self.itemSize.width + self.itemSpace);///单行可显示的最大个数
        if (itemCount > singleCount * self.column) { //可滚动
            singleCount = itemCount % self.column == 0 ? itemCount / self.column : (itemCount / self.column + 1);
        }
        NSInteger realLines = itemCount % singleCount == 0 ? itemCount / singleCount : (itemCount / singleCount + 1);
        CGSize itemSize = CGSizeMake(self.collectionView.bounds.size.width, self.header.bottomMargin + self.itemSize.height * realLines + (realLines - 1) * self.lineSpace + self.footer.topMargin);
        CGFloat x = 0;
        CGFloat y = self.firstItemStartY - self.header.bottomMargin;
        itemAttr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
        self.itemsAttribute = @[itemAttr];
        self.columnHeights[@(0)] = @(itemSize.height - self.header.bottomMargin);
    } else {
        [self resetColumnHeights];
        NSInteger items = [self.collectionView numberOfItemsInSection:self.indexPath.section];
        NSMutableArray *attrs = [NSMutableArray array];
        for (int j = 0; j < items; j++) {
            FMCollectionLayoutAttributes *itemAttr = [FMCollectionLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:j inSection:self.indexPath.section]];
            CGSize itemSize = self.itemSize;
            NSInteger column = [self getMinHeightColumn];
            CGFloat x = self.sectionInset.left + column * (self.itemSpace + itemSize.width);
            CGFloat height = [self.columnHeights[@(column)] floatValue];
            CGFloat y = self.sectionOffset + self.sectionInset.top + self.header.inset.top + self.header.height + self.header.inset.bottom + self.header.bottomMargin + (height > 0 ? (height + self.lineSpace) : height);
            itemAttr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
            [attrs addObject:itemAttr];
            self.columnHeights[@(column)] = @(height + itemSize.height + (height > 0 ? self.lineSpace : 0));
        }
        self.itemsAttribute = [attrs copy];
    }
}

- (UICollectionViewCell *)dequeueReusableCellForIndexPath:(NSIndexPath *)indexPath{
    if (self.isHorizontalCanScroll) {
        FMHorizontalScrollCollCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FMHorizontalScrollCollCell class]) forIndexPath:indexPath];
        return cell;
    } else {
        return [self.collectionView dequeueReusableCellWithReuseIdentifier:self.cellElement.reuseIdentifier forIndexPath:indexPath];
    }
}
- (void)registerCells{
    if (self.isHorizontalCanScroll) {
        [self.collectionView registerClass:[FMHorizontalScrollCollCell class] forCellWithReuseIdentifier:NSStringFromClass([FMHorizontalScrollCollCell class])];
    } else {
        [self.cellElement registerCellWithCollection:self.collectionView];
    }
}

@end
