//
//  FMCollectionHorizontalLayout.m
//  FMCollectionLayout
//
//  Created by 郑桂华 on 2020/4/2.
//

#import "FMCollectionHorizontalLayout.h"
#import "FMLayoutHorizontalSection.h"
#import "FMSupplementaryHeader.h"
#import "FMSupplementaryFooter.h"

@interface FMCollectionHorizontalLayout ()

@property(nonatomic, strong)FMLayoutHorizontalSection *horizontalSection;

@end

@implementation FMCollectionHorizontalLayout

- (void)prepareLayout{
    [self handleSection];
}

- (void)setSection:(FMLayoutSingleFixedSizeSection *)section{
    _section = section;
    [self invalidateLayout];
}

- (void)handleSection{
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    NSMutableArray *itemAttrs = [NSMutableArray array];
    NSInteger singleCount = self.collectionView.bounds.size.width / (self.section.itemSize.width + self.section.itemSpace);///单行可显示的最大个数
    if (items > singleCount * self.section.column) { //可滚动
        singleCount = items % self.section.column == 0 ? items / self.section.column : (items / self.section.column + 1);
    }
    NSInteger realLines = items % singleCount == 0 ? items / singleCount : (items / singleCount + 1);
    
    for (int i = 0; i<items; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        FMCollectionLayoutAttributes *attr = [FMCollectionLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        NSInteger index = i % singleCount;
        NSInteger lines = i / singleCount;
        CGFloat x = self.section.sectionInset.left + index * (self.section.itemSize.width + self.section.itemSpace);
        CGFloat y = self.section.header.bottomMargin + lines * (self.section.itemSize.height + self.section.lineSpace);
        attr.frame = CGRectMake(x, y, self.section.itemSize.width, self.section.itemSize.height);
        [itemAttrs addObject:attr];
    }
    FMLayoutHorizontalSection *section = [[FMLayoutHorizontalSection alloc] init];
    section.itemsAttribute = [itemAttrs copy];
    section.singleCount = singleCount;
    section.realLines = realLines;
    self.horizontalSection = section;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray<UICollectionViewLayoutAttributes *> *attrs = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *item in self.horizontalSection.itemsAttribute) {
        if (CGRectIntersectsRect(rect, item.frame)) {
            [attrs addObject:item];
        }
    }
    return attrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.horizontalSection.itemsAttribute[indexPath.item];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    if (!self.collectionView) {
        return NO;
    }
    return NO;
}

- (CGSize)collectionViewContentSize{
    return CGSizeMake(self.horizontalSection.singleCount * (self.section.itemSize.width) + (self.horizontalSection.singleCount - 1) * self.section.itemSpace + self.section.sectionInset.left + self.section.sectionInset.right, self.collectionView.bounds.size.height);
}

@end
