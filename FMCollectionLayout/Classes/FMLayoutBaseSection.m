//
//  FMLayoutBaseSection.m
//  LiangXinApp
//
//  Created by 郑桂华 on 2020/3/20.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutBaseSection.h"
#import "FMSupplementaryFooter.h"
#import "FMSupplementaryHeader.h"
#import "FMSupplementaryBackground.h"
#import "FMCollectionLayoutAttributes.h"

@interface FMLayoutBaseSection ()

@end

@implementation FMLayoutBaseSection

+ (instancetype)sectionWithSectionInset:(UIEdgeInsets)inset itemSpace:(CGFloat)itemSpace lineSpace:(CGFloat)lineSpace column:(NSInteger)column{
    FMLayoutBaseSection *section = [[self alloc] init];
    section.sectionInset = inset;
    section.itemSpace = itemSpace;
    section.lineSpace = lineSpace;
    section.column = column;
    [section resetColumnHeights];
    return section;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemDatas = [NSMutableArray array];
    }
    return self;
}

- (BOOL)intersectsRect:(CGRect)rect{
    return CGRectIntersectsRect(CGRectMake(0, self.sectionOffset, self.collectionView.bounds.size.width, self.sectionHeight), rect);
}

- (void)prepareHeader{
    FMCollectionLayoutAttributes *header = [FMCollectionLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:self.indexPath];
    header.frame = CGRectMake(self.sectionInset.left, self.sectionInset.top + self.sectionOffset, self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right, self.header.height);
    header.zIndex = self.header.zIndex;
    self.headerAttribute = header;
}

- (void)prepareFooter{
    FMCollectionLayoutAttributes *footer = [FMCollectionLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:self.indexPath];
    footer.frame = CGRectMake(self.sectionInset.left, self.sectionOffset + self.sectionInset.top + self.header.height + self.header.bottomMargin + [self getColumnMaxHeight] + self.footer.topMargin, self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right, self.footer.height);
    footer.zIndex = self.footer.zIndex;
    self.footerAttribute = footer;
}

- (void)prepareItems{
    
}

- (void)prepareBackground{
    if (self.background) {
        FMCollectionLayoutAttributes *bgAttr = [FMCollectionLayoutAttributes layoutAttributesForSupplementaryViewOfKind:self.background.elementKind withIndexPath:self.indexPath];
        bgAttr.frame = CGRectMake(self.background.inset.left, self.sectionOffset + self.background.inset.top, self.collectionView.bounds.size.width - (self.background.inset.left + self.background.inset.right), self.sectionHeight - (self.background.inset.top + self.background.inset.bottom));
        bgAttr.zIndex = self.background.zIndex;
        self.bgAttribute = bgAttr;
    }
}

///头部悬停布局计算
- (UICollectionViewLayoutAttributes *)showHeaderLayout{
    if (self.header.type == FMSupplementaryTypeFixed) {
        return self.headerAttribute;
    }
    if (self.header.type == FMSupplementaryTypeSuspension) {
        CGFloat columnMaxHeight = [self getColumnMaxHeight];
        CGFloat itemMaxHeight = self.sectionOffset + self.sectionInset.top + self.header.height + self.header.bottomMargin + columnMaxHeight;
        if (self.collectionView.contentOffset.y > self.sectionOffset + self.sectionInset.top && self.collectionView.contentOffset.y < itemMaxHeight - self.header.height) {
            UICollectionViewLayoutAttributes *show = [self.headerAttribute copy];
            CGRect frame = show.frame;
            frame.origin.y = self.collectionView.contentOffset.y;
            show.frame = frame;
            return show;
        } else if (self.collectionView.contentOffset.y >= itemMaxHeight - self.header.height) {
            UICollectionViewLayoutAttributes *show = [self.headerAttribute copy];
            CGRect frame = show.frame;
            frame.origin.y = itemMaxHeight - self.header.height;
            show.frame = frame;
            return show;
        } else {
            return self.headerAttribute;
        }
    }
    if (self.header.type == FMSupplementaryTypeSuspensionAlways) {
        if (self.collectionView.contentOffset.y > self.sectionOffset + self.sectionInset.top) {
            UICollectionViewLayoutAttributes *show = [self.headerAttribute copy];
            CGRect frame = show.frame;
            frame.origin.y = self.collectionView.contentOffset.y;
            show.frame = frame;
            return show;
        } else {
            return self.headerAttribute;
        }
    } else {
        return self.headerAttribute;
    }
}
///获取最小高度的列
- (NSInteger)getMinHeightColumn{
    if (self.column == 1) {
        return 0;
    }
    NSInteger column = 0;
    CGFloat minHeight = [self.columnHeights[@0] floatValue];
    for (int i = 1; i<self.column; i++) {
        CGFloat height = [self.columnHeights[@(i)] floatValue];
        if (height < minHeight) {
            column = i;
            minHeight = height;
        }
    }
    return column;
}
///获取最所有列的最大高度
- (CGFloat)getColumnMaxHeight{
    CGFloat maxHeight = [self.columnHeights[@0] floatValue];
    for (int i = 1; i<self.column; i++) {
        CGFloat height = [self.columnHeights[@(i)] integerValue];
        if (height > maxHeight) {
            maxHeight = height;
        }
    }
    return maxHeight;
}
///重置所有列的高度缓存
- (void)resetColumnHeights{
    self.columnHeights = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.column; i++) {
        self.columnHeights[@(i)] = @0;
    }
}

- (UICollectionViewCell *)dequeueReusableCellForIndexPath:(NSIndexPath *)indexPath{
    @throw [NSException exceptionWithName:@"child class must implementation this method" reason:@"FMLayoutBaseSection" userInfo:nil];
}
- (void)registerCells{
    
}
@end
