//
//  FMLayoutLabelSection.m
//  FMCollectionLayout
//
//  Created by 周发明 on 2020/4/8.
//

#import "FMLayoutLabelSection.h"
#import "FMCollectionLayoutAttributes.h"
#import "FMLayoutHeader.h"
#import "FMLayoutFooter.h"

@interface FMLayoutLabelSection ()

@property(nonatomic, assign)NSInteger vLastLines;

@end

@implementation FMLayoutLabelSection

- (id)copyWithZone:(NSZone *)zone{
    FMLayoutLabelSection *label = [super copyWithZone:zone];
    label.maxLine = self.maxLine;
    label.cellFixedHeight =  self.cellFixedHeight;
    label.cellMaxWidth = self.cellMaxWidth;
    label.widthBlock = [self.widthBlock copy];
    label.overItemBlock = [self.overItemBlock copy];
    return label;
}

- (void)prepareItems{
    if ([self prepareLayoutItemsIsOlnyChangeOffset]) return;
    if (self.direction == FMLayoutDirectionVertical) {
        self.column = 1;
        [self resetcolumnSizes];
        NSInteger items = MIN([self.collectionView numberOfItemsInSection:self.indexPath.section], self.itemCount);
        NSMutableArray<FMCollectionLayoutAttributes *> *attrs = [NSMutableArray array];
        int first = 0;
        NSInteger lines = 0;
        if (self.handleType == FMLayoutHandleTypeAppend) {
            attrs = [self.itemsAttribute mutableCopy];
            first = (int)self.handleItemStart;
            lines = self.vLastLines;
        }
        if (self.cellMaxWidth == 0) {
            self.cellMaxWidth = self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right;
        }
        CGFloat startX = attrs.count > 0 ? CGRectGetMaxX([attrs firstObject].frame) : self.firstItemStartX;
        CGFloat startY = self.firstItemStartY;
        CGFloat maxCellHeight = 0;
        CGFloat leftWidth = self.collectionView.frame.size.width - startX - self.sectionInset.right;
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
                        startX = self.firstItemStartX;
                        x = startX;
                        startY += self.cellFixedHeight + self.lineSpace;
                        y = startY;
                        leftWidth = self.collectionView.frame.size.width - self.firstItemStartX - self.sectionInset.right - width - self.itemSpace;
                        startX += width + self.itemSpace;
                    } else { //到最大行数了
                        if (self.overItemBlock) {
                            self.overItemBlock(self, j);
                        }
                        break;
                    }
                } else {
                    lines += 1;
                    startX = self.firstItemStartX;
                    x = startX;
                    startY += self.cellFixedHeight + self.lineSpace;
                    y = startY;
                    leftWidth = self.collectionView.frame.size.width - self.firstItemStartX - self.sectionInset.right - width - self.itemSpace;
                    startX += width + self.itemSpace;
                }
            }
            maxCellHeight = lines * (self.cellFixedHeight + self.lineSpace) + self.cellFixedHeight;
            self.vLastLines = lines;
            CGSize itemSize = CGSizeMake(width, self.cellFixedHeight);
            itemAttr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
            [attrs addObject:itemAttr];
            if (self.configureCellLayoutAttributes) {
                self.configureCellLayoutAttributes(self, itemAttr, j);
            }
        }
        self.columnSizes[@(0)] = @(maxCellHeight);
        self.itemsAttribute = [attrs copy];
    } else {
        self.column = self.maxLine;
        [self resetcolumnSizes];
        NSInteger items = MIN([self.collectionView numberOfItemsInSection:self.indexPath.section], self.itemCount);
        NSMutableArray *attrs = [NSMutableArray array];
        int first = 0;
        if (self.handleType == FMLayoutHandleTypeAppend) {
            attrs = [self.itemsAttribute mutableCopy];
            first = (int)self.handleItemStart;
        }
        for (int j = first; j < items; j++) {
            FMCollectionLayoutAttributes *itemAttr = [FMCollectionLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:j inSection:self.indexPath.section]];
            CGFloat width = !self.widthBlock?0:self.widthBlock(self, j);
            CGSize itemSize = CGSizeMake(width, self.cellFixedHeight);
            NSInteger column = [self getMinHeightColumn];
            CGFloat minWidth = [self.columnSizes[@(column)] floatValue];
            
            CGFloat x = self.firstItemStartX + (minWidth > 0 ? (minWidth + self.itemSpace) : minWidth);
            CGFloat y = self.firstItemStartY + column * (self.lineSpace + itemSize.height);
            itemAttr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
            [attrs addObject:itemAttr];
            self.columnSizes[@(column)] = @(minWidth + itemSize.width + (minWidth > 0 ? self.itemSpace : 0));
            if (self.configureCellLayoutAttributes) {
                self.configureCellLayoutAttributes(self, itemAttr, j);
            }
        }
        self.itemsAttribute = [attrs copy];
    }
}

- (CGFloat)crossSingleSectionSize{
    if (self.direction == FMLayoutDirectionHorizontal) {
        if (self.itemCount > self.maxLine) {
            return self.maxLine * self.cellFixedHeight + (self.maxLine - 1) * self.lineSpace;
        } else {
            return self.itemCount * self.cellFixedHeight + (self.itemCount - 1) * self.lineSpace;
        }
    } else {
        if (self.itemCount > self.maxLine) {
            return self.maxLine * self.cellFixedHeight + (self.maxLine - 1) * self.itemSpace;
        } else {
            return self.itemCount * self.cellFixedHeight + (self.itemCount - 1) * self.itemSpace;
        }
    }
}

@end
