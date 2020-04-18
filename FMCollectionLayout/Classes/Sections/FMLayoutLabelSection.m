//
//  FMLayoutLabelSection.m
//  FMCollectionLayout
//
//  Created by 郑桂华 on 2020/4/8.
//

#import "FMLayoutLabelSection.h"
#import "FMCollectionLayoutAttributes.h"
#import "FMSupplementaryHeader.h"
#import "FMSupplementaryFooter.h"
#import "FMHorizontalScrollCollCell.h"

@implementation FMLayoutLabelSection

- (void)prepareItems{
    if (self.isSingleLineCanScroll) {
        FMCollectionLayoutAttributes *itemAttr = [FMCollectionLayoutAttributes layoutAttributesForCellWithIndexPath:self.indexPath];
        CGSize itemSize = CGSizeMake(self.collectionView.bounds.size.width, self.header.bottomMargin + self.cellFixedHeight + self.footer.topMargin);
        CGFloat x = 0;
        CGFloat y = self.firstItemStartY - self.header.bottomMargin;
        itemAttr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
        self.itemsAttribute = @[itemAttr];
        self.columnHeights[@(0)] = @(itemSize.height - self.header.bottomMargin);
    } else {
        [self resetColumnHeights];
        NSInteger items = [self.collectionView numberOfItemsInSection:self.indexPath.section];
        NSMutableArray *attrs = [NSMutableArray array];
        if (self.cellMaxWidth == 0) {
            self.cellMaxWidth = self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right;
        }
        NSInteger lines = 0;
        CGFloat startX = self.sectionInset.left;
        CGFloat startY = self.firstItemStartY;
        CGFloat maxCellHeight = 0;
        CGFloat leftWidth = self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right;
        for (int j = 0; j < items; j++) {
            FMCollectionLayoutAttributes *itemAttr = [FMCollectionLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:j inSection:self.indexPath.section]];
           
            CGFloat x;
            CGFloat y;
            
            CGFloat width = !self.widthBlock?0:self.widthBlock(self, j);
            width = MIN(width, self.cellMaxWidth);
            if (width <= leftWidth) { //够放一行
                x = startX;
                y = startY;
                startX += width + self.itemSpace;
                leftWidth = leftWidth - width - self.itemSpace;
            } else { //需换行
                if (self.maxLine > 0) {
                    if (lines < self.maxLine - 1) { //还可以继续算
                        lines += 1;
                        startX = self.sectionInset.left;
                        x = startX;
                        startY += self.cellFixedHeight + self.lineSpace;
                        y = startY;
                        leftWidth = self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right - width - self.itemSpace;
                        startX += width + self.itemSpace;
                    } else { //到最大行数了
                        if (self.overItemBlock) {
                            self.overItemBlock(self, j);
                        }
                        break;
                    }
                } else {
                    lines += 1;
                    startX = self.sectionInset.left;
                    x = startX;
                    startY += self.cellFixedHeight + self.lineSpace;
                    y = startY;
                    leftWidth = self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right - width - self.itemSpace;
                    startX += width + self.itemSpace;
                }
            }
            maxCellHeight = lines * (self.cellFixedHeight + self.lineSpace) + self.cellFixedHeight;
            CGSize itemSize = CGSizeMake(width, self.cellFixedHeight);
            itemAttr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
            [attrs addObject:itemAttr];
        }
        self.columnHeights[@(0)] = @(maxCellHeight);
        self.itemsAttribute = [attrs copy];
    }
}

- (UICollectionViewCell *)dequeueReusableCellForIndexPath:(NSIndexPath *)indexPath{
    if (self.isSingleLineCanScroll) {
        FMHorizontalScrollCollCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FMHorizontalScrollCollCell class]) forIndexPath:indexPath];
        return cell;
    } else {
        return [self.collectionView dequeueReusableCellWithReuseIdentifier:self.cellElement.reuseIdentifier forIndexPath:indexPath];
    }
}
- (void)registerCells{
    if (self.isSingleLineCanScroll) {
        [self.collectionView registerClass:[FMHorizontalScrollCollCell class] forCellWithReuseIdentifier:NSStringFromClass([FMHorizontalScrollCollCell class])];
    } else {
        [self.cellElement registerCellWithCollection:self.collectionView];
    }
}
@end
