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
    if ([self prepareLayoutItemsIsOlnyChangeY]) return;
    [self resetColumnHeights];
    NSInteger items = [self.collectionView numberOfItemsInSection:self.indexPath.section];
    NSMutableArray *attrs = [NSMutableArray array];
    for (int j = 0; j < items; j++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:self.indexPath.section];
        FMCollectionLayoutAttributes *itemAttr = [FMCollectionLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGFloat itemWidth =  self.cellFixedWidth;
        CGFloat itemHeight = 0;
        if (self.autoHeightFixedWidth) {
            if (self.deqCellReturnReuseId) {
                CFAbsoluteTime oneTime = CFAbsoluteTimeGetCurrent();
                UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:self.deqCellReturnReuseId(self, j) forIndexPath:indexPath];
                if (self.configurationCell) {
                    self.configurationCell(self ,cell, j);
                }
                CFAbsoluteTime oneEnd = (CFAbsoluteTimeGetCurrent() - oneTime);
                NSLog(@"动态布局获取cell耗时 %f ms",oneEnd *1000.0);
                CFAbsoluteTime sysStart = CFAbsoluteTimeGetCurrent();
                itemHeight = [cell systemLayoutSizeFittingSize:CGSizeMake(itemWidth, MAXFLOAT)].height;
                CFAbsoluteTime sysEnd = (CFAbsoluteTimeGetCurrent() - sysStart);
                NSLog(@"动态布局获取systemLayoutSizeFittingSize耗时 %f ms",sysEnd *1000.0);
            }
        } else {
            itemHeight = !self.heightBlock?0:self.heightBlock(self, j);
        }
        CGSize itemSize = CGSizeMake(itemWidth, itemHeight);
        NSInteger column = [self getMinHeightColumn];
        CGFloat x = self.sectionInset.left + column * (self.itemSpace + itemSize.width);
        CGFloat height = [self.columnHeights[@(column)] floatValue];
        CGFloat y = self.firstItemStartY + (height > 0 ? (height + self.lineSpace) : height);
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
