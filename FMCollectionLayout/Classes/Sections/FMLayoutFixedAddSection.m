//
//  FMLayoutFixedAddSection.m
//  FMCollectionLayout
//
//  Created by 郑桂华 on 2020/4/17.
//

#import "FMLayoutFixedAddSection.h"
#import "FMSupplementaryFooter.h"
#import "FMSupplementaryHeader.h"
#import "FMSupplementaryBackground.h"
#import "FMCollectionLayoutAttributes.h"

@interface FMLayoutFixedAddSection ()

@property(nonatomic, assign)BOOL isAppend;

@end

@implementation FMLayoutFixedAddSection

- (BOOL)isHorizontalCanScroll{
    return NO;
}

- (void)setHandleItemStart:(NSInteger)handleItemStart{
    [super setHandleItemStart:handleItemStart];
    if (self.handleItemStart == self.itemsAttribute.count) {
        self.isAppend = YES;
    } else {
        self.isAppend = NO;
    }
}

- (void)prepareItems{
    if (!self.isAppend) {
        [super prepareItems];
    } else {
        NSInteger items = [self.collectionView numberOfItemsInSection:self.indexPath.section];
        NSMutableArray *attrs = [self.itemsAttribute mutableCopy];
        for (int j = self.handleItemStart; j < items; j++) {
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

@end
