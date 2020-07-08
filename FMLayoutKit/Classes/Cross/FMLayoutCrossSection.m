//
//  FMLayoutCrossSection.m
//  FMLayoutKit
//
//  Created by 周发明 on 2020/6/16.
//

#import "FMLayoutCrossSection.h"
#import "FMLayoutCrossCell.h"
#import "FMLayoutElement.h"
#import "FMCollectionLayoutAttributes.h"
#import "FMLayoutBaseSection+ConfigureBlock.h"

@interface FMLayoutCrossSection ()

@property(nonatomic, strong)FMLayoutElement *cellElement;///固定分组

@end

@implementation FMLayoutCrossSection

- (FMLayoutDirection)crossDirection{
    return self.direction == FMLayoutDirectionVertical ? FMLayoutDirectionHorizontal : FMLayoutDirectionVertical;
}

- (CGFloat)maxContentWidth{
    if (self.sections == nil || self.sections.count == 0) {
        return 0;
    }
    FMLayoutBaseSection *last = [self.sections lastObject];
    return last.sectionOffset + last.sectionSize;
}

- (void)setCanReuseCell:(BOOL)canReuseCell{
    _canReuseCell = canReuseCell;
    self.cellElement.reuseIdentifier = canReuseCell ? NSStringFromClass(self.cellElement.viewClass) : [NSString stringWithFormat:@"%@%@", self, NSStringFromClass(self.cellElement.viewClass)];
}

+ (instancetype)sectionAutoWithSection:(FMLayoutBaseSection *)section{
    FMLayoutCrossSection *hor = [[self alloc] init];
    hor.autoMaxSize = YES;
    hor.sections = [@[section] mutableCopy];
    return hor;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellElement = [FMLayoutElement elementWithViewClass:[FMLayoutCrossCell class]];
        self.canReuseCell = YES;
        [self setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
            FMLayoutCrossCell *hCell = (FMLayoutCrossCell *)cell;
            hCell.crossSection = (FMLayoutCrossSection *)section;
        }];
        self.sections = [NSMutableArray array];
    }
    return self;
}

- (NSInteger)itemCount{
    return 1;
}

- (void)prepareItems{
    if ([self prepareLayoutItemsIsOlnyChangeOffset]) return;
    [self resetcolumnSizes];
    FMCollectionLayoutAttributes *itemAttr = [FMCollectionLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:0 inSection:self.indexPath.section]];
    CGSize itemSize;
    if (self.autoMaxSize) {
        CGFloat maxSize = 0;
        for (FMLayoutBaseSection *section in self.sections) {
            section.direction = self.crossDirection;
            CGFloat size = [section crossSingleSectionSize];
            if (maxSize < size) {
                maxSize = size;
            }
        }
        if (self.direction == FMLayoutDirectionVertical) {
            itemSize = CGSizeMake(self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right, maxSize);
        } else {
            itemSize = CGSizeMake(maxSize, self.collectionView.frame.size.height - self.sectionInset.top - self.sectionInset.bottom);
        }
    } else {
        if (self.direction == FMLayoutDirectionVertical) {
            itemSize = CGSizeMake(self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right, self.size);
        } else {
            itemSize = CGSizeMake(self.size, self.collectionView.frame.size.height - self.sectionInset.top - self.sectionInset.bottom);
        }
    }
    CGFloat x = self.firstItemStartX;
    CGFloat y = self.firstItemStartY;
    itemAttr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
    self.itemsAttribute = @[itemAttr];
    self.columnSizes[@(0)] = self.direction == FMLayoutDirectionVertical ? @(itemSize.height) : @(itemSize.width);
}

- (UICollectionViewCell *)dequeueReusableCellForIndexPath:(NSIndexPath *)indexPath collectionView:(nonnull UICollectionView *)collectionView{
    return [collectionView dequeueReusableCellWithReuseIdentifier:self.cellElement.reuseIdentifier forIndexPath:indexPath];
}
- (void)registerCellsWithCollectionView:(UICollectionView *)collectionView{
    [self.cellElement registerElementWithCollection:collectionView];
}

#pragma mark ----- UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scrollDidScroll) {
        self.scrollDidScroll((UICollectionView *)scrollView, self);
    }
}

@end
