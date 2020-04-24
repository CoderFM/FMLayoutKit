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

- (void)setSections:(NSArray<FMLayoutBaseSection *> *)sections{
    _sections = sections;
    [self invalidateLayout];
}

- (void)handleSections{
    [self registerSections];
    CGFloat sectionOffset = self.firstSectionOffsetY;
    for (int i = 0; i < self.sections.count; i++) {
        FMLayoutBaseSection *section = self.sections[i];
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:i];
        
        if (self.reLayoutOlnyChanged) {// 只改变变过的
            if (section.hasHanble) {
                section.indexPath = sectionIndexPath;
                section.sectionOffset = sectionOffset;
                sectionOffset += section.sectionHeight;
                continue;
            }
        }
        
        section.indexPath = sectionIndexPath;
        
        section.sectionOffset = sectionOffset;
        if (section.header) {
            [section prepareHeader];
        }
        [section prepareItems];
        if (section.footer) {
            {
                [section prepareFooter];
                section.sectionHeight = section.sectionInset.top + section.header.inset.top +section.header.height + section.header.inset.bottom + section.header.bottomMargin + [section getColumnMaxHeight] + section.footer.inset.top + section.footer.height +  section.footer.topMargin + section.footer.inset.bottom + section.sectionInset.bottom;
                sectionOffset = CGRectGetMaxY(section.footerAttribute.frame) + section.sectionInset.bottom;
            }
        } else {
            CGFloat itemMaxHeight = [section getColumnMaxHeight];
            section.sectionHeight = section.sectionInset.top + section.header.inset.top + section.header.height + section.header.inset.bottom + section.header.bottomMargin + itemMaxHeight + section.sectionInset.bottom;
            sectionOffset = section.sectionOffset + section.sectionHeight;
        }
        [section prepareBackground];
        section.hasHanble = YES;
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
    return section.itemsAttribute[indexPath.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    FMLayoutBaseSection *section = self.sections[indexPath.section];
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
    return CGSizeMake(self.collectionView.bounds.size.width, section.sectionOffset + section.sectionHeight + self.fixedBottomMargin);
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath{
    return [self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:elementIndexPath];
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath{
    return [self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:elementIndexPath];
}

@end
