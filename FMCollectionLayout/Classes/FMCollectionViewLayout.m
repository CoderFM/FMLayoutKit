//
//  FMCollectionViewLayout.m
//  LiangXinApp
//
//  Created by 郑桂华 on 2020/3/20.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMCollectionViewLayout.h"
#import "FMLayoutBaseSection.h"
#import "FMCollectionSupplementary.h"
#import "FMCollectionLayoutAttributes.h"
#import "NSMutableArray+FM.h"

@interface FMCollectionViewLayout ()

@property(nonatomic, assign)CGFloat firstSectionOffsetY;

@end

@implementation FMCollectionViewLayout

- (void)setFirstSectionOffsetY:(CGFloat)offsetY{
    _firstSectionOffsetY = offsetY;
}

- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

- (void)prepareLayout{
    [self handleSections];
}

- (void)setMinSectionChangeOffsetYIndex:(NSInteger)minSectionChangeOffsetYIndex{
    if (minSectionChangeOffsetYIndex < _minSectionChangeOffsetYIndex) {
        _minSectionChangeOffsetYIndex = minSectionChangeOffsetYIndex;
    }
}

- (void)setSections:(NSMutableArray<FMLayoutBaseSection *> *)sections{
    if (_sections == sections) {
        return;
    }
    if (![sections isKindOfClass:[NSMutableArray class]]) {
        _sections = [sections mutableCopy];
    } else {
        _sections = sections;
    }
    [self invalidateLayout];
}

- (void)handleSections{
    [self registerSections];
    CGFloat sectionOffset = self.firstSectionOffsetY;
    NSInteger sections = [self.collectionView numberOfSections];
    sections = MIN(sections, self.sections.count);
    for (int i = 0; i < sections; i++) {
        
        FMLayoutBaseSection *section = self.sections[i];
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:i];
        section.indexPath = sectionIndexPath;
        section.sectionOffset = sectionOffset;
        
        __weak typeof(self) weakSelf = self;
        [section setItemsLayoutChanged:^(NSIndexPath * _Nonnull indexPath) {
            if (weakSelf.minSectionChangeOffsetYIndex > indexPath.section) {
                weakSelf.minSectionChangeOffsetYIndex  = indexPath.section;
            }
        }];
        
        if (self.reLayoutOlnyChanged) {// 只改变变过的
            if (i < self.minSectionChangeOffsetYIndex && section.hasHanble) {
                section.sectionOffset = sectionOffset;
                sectionOffset += section.sectionHeight;
                continue;
            }
        }
        
        section.sectionOffset = sectionOffset;
        [section handleLayout];
        
        sectionOffset = section.sectionOffset + section.sectionHeight;
        
        section.hasHanble = YES;
    }
    
    if (self.sections.count > 0) {
        _minSectionChangeOffsetYIndex = self.sections.count - 1;
    } else {
        _minSectionChangeOffsetYIndex = 0;
    }
}

- (void)registerSections{
    for (FMLayoutBaseSection *section in self.sections) {
        section.collectionView = self.collectionView;
        
        if (section.header) {
            [section.header registerWithCollectionView:section.collectionView];
        }
        if (section.footer) {
            [section.footer registerWithCollectionView:section.collectionView];
        }
        if (section.background) {
            [section.background registerWithCollectionView:section.collectionView];
        }
        [section registerCells];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray<UICollectionViewLayoutAttributes *> *attrs = [NSMutableArray array];
    for (FMLayoutBaseSection *section in self.sections) {
        if ([section intersectsRect:rect]) {
            if (section.headerAttribute) {
                UICollectionViewLayoutAttributes *showHeaderAttr = [section showHeaderLayout];
                if (CGRectIntersectsRect(rect, showHeaderAttr.frame)) {
                    [attrs addObject:showHeaderAttr];
                }
            }
            if (section.footerAttribute) {
                if (CGRectIntersectsRect(rect, section.footerAttribute.frame)) {
                    [attrs addObject:section.footerAttribute];
                }
            }
            if (section.bgAttribute) {
                if (CGRectIntersectsRect(rect, section.bgAttribute.frame)) {
                    [attrs addObject:section.bgAttribute];
                }
            }
            for (UICollectionViewLayoutAttributes *item in section.itemsAttribute) {
                if (CGRectIntersectsRect(rect, item.frame)) {
                    [attrs addObject:item];
                }
            }
        } else {
            if (section.header.type == FMSupplementaryTypeSuspensionAlways) {
                if (section.headerAttribute) {
                    UICollectionViewLayoutAttributes *showHeaderAttr = [section showHeaderLayout];
                    if (CGRectIntersectsRect(rect, showHeaderAttr.frame)) {
                        [attrs addObject:showHeaderAttr];
                    }
                }
            }
        }
    }
    return attrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    FMLayoutBaseSection *section = self.sections[indexPath.section];
    if (!section.hasHanble) {
        return nil;
    }
    return section.itemsAttribute[indexPath.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    FMLayoutBaseSection *section = self.sections[indexPath.section];
    if (!section.hasHanble) {
        return nil;
    }
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [section showHeaderLayout];
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]){
        return section.footerAttribute;
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionBackground]) {
        return section.bgAttribute;
    }
    return nil;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    if (!self.collectionView) {
        return NO;
    }
    BOOL change = !CGRectEqualToRect(self.collectionView.bounds, newBounds);
    NSMutableArray *headerIndexPaths = [NSMutableArray array];
    NSMutableArray *itemIndexPaths = [NSMutableArray array];
    for (FMLayoutBaseSection *section in self.sections) {
        if ([section intersectsRect:newBounds]) {
            if (section.header.type == FMSupplementaryTypeSuspension) {
                [headerIndexPaths addObject:section.indexPath];
            }
            for (FMCollectionLayoutAttributes *itemAttr in section.itemsAttribute) {
                if (itemAttr.isInvalidate) {
                    [itemIndexPaths addObject:itemAttr.indexPath];
                }
            }
        }
        if (section.header.type == FMSupplementaryTypeSuspensionAlways || section.header.type == FMSupplementaryTypeSuspensionBigger) {
            [headerIndexPaths addObject:section.indexPath];
        }
    }
    
    BOOL result = change && (headerIndexPaths.count > 0 || itemIndexPaths.count > 0);
    if (result) {
        UICollectionViewLayoutInvalidationContext *context = [[UICollectionViewLayoutInvalidationContext alloc] init];
        [context invalidateSupplementaryElementsOfKind:UICollectionElementKindSectionHeader atIndexPaths:headerIndexPaths];
        [context invalidateItemsAtIndexPaths:itemIndexPaths];
        [self invalidateLayoutWithContext:context];
    }
    return result;
}

- (CGSize)collectionViewContentSize{
    FMLayoutBaseSection *section = [self.sections lastObject];
    CGSize contentSize = CGSizeMake(self.collectionView.bounds.size.width, section.sectionOffset + section.sectionHeight + self.fixedBottomMargin);
    if (contentSize.height < self.minContentSizeHeight) {
        contentSize.height = self.minContentSizeHeight;
    }
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath{
    return [self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:elementIndexPath];
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath{
    return [self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:elementIndexPath];
}

@end
