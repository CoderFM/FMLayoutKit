//
//  FMLayoutDynamicSection.m
//  FMLayoutKit
//
//  Created by 郑桂华 on 2020/4/1.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutDynamicSection.h"
#import "FMCollectionLayoutAttributes.h"
#import "FMSupplementaryHeader.h"
#import "FMSupplementaryFooter.h"

@interface FMLayoutDynamicSection ()

@end

@implementation FMLayoutDynamicSection

- (void)prepareItems{
    [self resetColumnHeights];
    NSInteger items = [self.collectionView numberOfItemsInSection:self.indexPath.section];
    NSMutableArray *attrs = [NSMutableArray array];
    for (int j = 0; j < items; j++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:self.indexPath.section];
        FMCollectionLayoutAttributes *itemAttr = [FMCollectionLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGFloat itemWidth =  self.cellFixedWidth;
        CGFloat itemHeight = 0;
        if (self.autoHeightFixedWidth) {
            if (self.deqCellReturnReuseId && self.configurationCell) {
                UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:self.deqCellReturnReuseId(self, j) forIndexPath:indexPath];
                self.configurationCell(self ,cell, j);
                itemHeight = [cell systemLayoutSizeFittingSize:CGSizeMake(itemWidth, MAXFLOAT)].height;
            }
        } else {
            itemHeight = !self.heightBlock?0:self.heightBlock(self, j);
        }
        CGSize itemSize = CGSizeMake(itemWidth, itemHeight);
        NSInteger column = [self getMinHeightColumn];
        CGFloat x = self.sectionInset.left + column * (self.itemSpace + itemSize.width);
        CGFloat height = [self.columnHeights[@(column)] floatValue];
        CGFloat y = self.sectionOffset + self.sectionInset.top + self.header.height + self.header.bottomMargin + (height > 0 ? (height + self.lineSpace) : height);
        itemAttr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
        [attrs addObject:itemAttr];
        self.columnHeights[@(column)] = @(height + itemSize.height + (height > 0 ? self.lineSpace : 0));
    }
    self.itemsAttribute = [attrs copy];
}

- (UICollectionViewCell *)dequeueReusableCellForIndexPath:(NSIndexPath *)indexPath{
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:self.deqCellReturnReuseId(self, indexPath.item) forIndexPath:indexPath];
}

- (void)registerCells{
    for (FMCollectionViewElement *element in self.cellElements) {
        [element registerCellWithCollection:self.collectionView];
    }
}

@end
