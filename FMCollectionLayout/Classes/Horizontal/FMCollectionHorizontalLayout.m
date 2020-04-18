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

@property(nonatomic, assign)BOOL isSingleLineLabel;
@property(nonatomic, strong)FMLayoutHorizontalSection *horizontalSection;

@end

@implementation FMCollectionHorizontalLayout

- (void)prepareLayout{
    [self handleSection];
}

- (void)setSection:(FMLayoutFixedSection *)section{
    _section = section;
    [self invalidateLayout];
}

- (void)handleSection{
    if ([self.section isKindOfClass:[FMLayoutFixedSection class]]) {
        self.isSingleLineLabel = NO;
        [self handleFixedSection];
    }
    if ([self.section isKindOfClass:[FMLayoutLabelSection class]]) {
        self.isSingleLineLabel = YES;
        [self handleLabelSection];
    }
}

- (void)handleFixedSection{
    FMLayoutFixedSection *section = (FMLayoutFixedSection *)self.section;
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    NSMutableArray *itemAttrs = [NSMutableArray array];
    NSInteger singleCount = self.collectionView.bounds.size.width / (section.itemSize.width + section.itemSpace);///单行可显示的最大个数
    if (items > singleCount * section.column) { //可滚动
        singleCount = items % section.column == 0 ? items / section.column : (items / section.column + 1);
    }
    NSInteger realLines = items % singleCount == 0 ? items / singleCount : (items / singleCount + 1);
    
    for (int i = 0; i<items; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        FMCollectionLayoutAttributes *attr = [FMCollectionLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        NSInteger index = i % singleCount;
        NSInteger lines = i / singleCount;
        CGFloat x = section.sectionInset.left + index * (section.itemSize.width + self.section.itemSpace);
        CGFloat y = section.header.bottomMargin + lines * (section.itemSize.height + self.section.lineSpace);
        attr.frame = CGRectMake(x, y, section.itemSize.width, section.itemSize.height);
        [itemAttrs addObject:attr];
    }
    FMLayoutHorizontalSection *sectionH = [[FMLayoutHorizontalSection alloc] init];
    sectionH.itemsAttribute = [itemAttrs copy];
    sectionH.singleCount = singleCount;
    sectionH.realLines = realLines;
    self.horizontalSection = sectionH;
}

- (void)handleLabelSection{
    FMLayoutLabelSection *section = (FMLayoutLabelSection *)self.section;
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    NSMutableArray *itemAttrs = [NSMutableArray array];
    NSInteger realLines = 1;
    CGFloat startX = section.sectionInset.left;
    for (int i = 0; i<items; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        FMCollectionLayoutAttributes *attr = [FMCollectionLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        if (i > 0) {
            startX += section.itemSpace;
        }
        CGFloat width = section.widthBlock(section, i);
        CGFloat x = startX;
        CGFloat y = section.header.bottomMargin;
        attr.frame = CGRectMake(x, y, width, section.cellFixedHeight);
        [itemAttrs addObject:attr];
        startX += width;
    }
    FMLayoutHorizontalSection *sectionH = [[FMLayoutHorizontalSection alloc] init];
    sectionH.itemsAttribute = [itemAttrs copy];
    sectionH.realLines = realLines;
    self.horizontalSection = sectionH;
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
    if (self.isSingleLineLabel) {
        return CGSizeMake(CGRectGetMaxX([self.horizontalSection.itemsAttribute lastObject].frame) + self.section.sectionInset.right, self.collectionView.bounds.size.height);
    } else {
        FMLayoutFixedSection *section = (FMLayoutFixedSection *)self.section;
        return CGSizeMake(self.horizontalSection.singleCount * (section.itemSize.width) + (self.horizontalSection.singleCount - 1) * section.itemSpace + section.sectionInset.left + section.sectionInset.right, self.collectionView.bounds.size.height);
    }
}

@end
