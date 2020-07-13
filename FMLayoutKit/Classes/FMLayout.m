//
//  FMLayout.m
//  FMLayoutKit
//
//  Created by 周发明 on 2020/6/16.
//

#import "FMLayout.h"

@interface FMLayout ()

@property(nonatomic, strong)NSMutableArray *headerInvalidateSections;

@end

@implementation FMLayout

- (void)dealloc{
    FMLayoutLog(@"FMLayout dealloc");
}

- (instancetype)init{
    if (self = [super init]) {
        self.headerInvalidateSections = [NSMutableArray array];
    }
    return self;
}

- (void)prepareLayout{
    [self handleSections];
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

- (void)setDirection:(FMLayoutDirection)direction{
    if (_direction == direction) {
        return;
    }
    _direction = direction;
    for (FMLayoutBaseSection *section in self.sections) {
        section.hasHandle = NO;
    }
    [self invalidateLayout];
}

- (void)handleSections{
    [self registerSections];
    self.headerInvalidateSections = [NSMutableArray array];
    
    CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
    
    CGFloat sectionOffset = self.firstSectionOffset;
    NSInteger sections = [self.collectionView numberOfSections];
    sections = MIN(sections, self.sections.count);
    for (int i = 0; i < sections; i++) {
        
        CFAbsoluteTime oneTime =CFAbsoluteTimeGetCurrent();
        
        FMLayoutBaseSection *section = self.sections[i];
        section.direction = self.direction;
        
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:i];
        section.indexPath = sectionIndexPath;
        
        if (self.reLayoutOlnyChanged) {
            if (section.sectionOffset != sectionOffset && section.hasHandle == YES) {
                section.handleType = FMLayoutHandleTypeOlnyChangeOffset;
                section.changeOffset = sectionOffset - section.sectionOffset;
                section.hasHandle = NO;
            }
        } else {
            section.hasHandle = NO;
        }
        
        if (!section.hasHandle) {
            section.sectionOffset = sectionOffset;
            [section handleLayout];
        }
        
        sectionOffset = section.sectionOffset + section.sectionSize;
        
        section.changeOffset = 0;
        section.handleType = FMLayoutHandleTypeReLayout;
        section.hasHandle = YES;
        
        if (section.header) {
            if (section.header.type != FMLayoutHeaderTypeFixed) {
                [self.headerInvalidateSections addObject:section];
            }
        }
        
        CFAbsoluteTime oneEnd = (CFAbsoluteTimeGetCurrent() - oneTime);
        FMLayoutLog([NSString stringWithFormat:@"单个Section%@布局计算耗时 %f ms", section,oneEnd *1000.0]);
    }
    
    CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
    FMLayoutLog([NSString stringWithFormat:@"布局计算总耗时 %f ms", linkTime *1000.0]);
}

- (void)registerSections{
    for (FMLayoutBaseSection *section in self.sections) {
        section.collectionView = self.collectionView;
        
        if (section.header) {
            [section.header registerElementWithCollection:section.collectionView];
        }
        if (section.footer) {
            [section.footer registerElementWithCollection:section.collectionView];
        }
        if (section.background) {
            [section.background registerElementWithCollection:section.collectionView];
        }
        [section registerCells];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    if (self.direction == FMLayoutDirectionVertical) {
        rect.size.width = self.collectionView.frame.size.width;
    } else {
        rect.size.height = self.collectionView.frame.size.height;
    }
    NSMutableArray<UICollectionViewLayoutAttributes *> *attrs = [NSMutableArray array];
    for (FMLayoutBaseSection *section in self.sections) {
        [attrs addObjectsFromArray:[section showLayoutAttributesInRect:rect]];
    }
    return attrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    FMLayoutBaseSection *section = self.sections[indexPath.section];
    if (!section.hasHandle) {
        return nil;
    }
    if (indexPath.item < section.itemsAttribute.count) {
        return section.itemsAttribute[indexPath.item];
    }
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    FMLayoutBaseSection *section = self.sections[indexPath.section];
    if (!section.hasHandle) {
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
    BOOL change;
    if (self.direction == FMLayoutDirectionVertical) {
        change = self.collectionView.bounds.size.height != newBounds.size.height;
        newBounds.size.width = self.collectionView.frame.size.width;
    } else {
        change = self.collectionView.bounds.size.width != newBounds.size.width;
        newBounds.size.height = self.collectionView.frame.size.height;
    }
    NSMutableArray *headerIndexPaths = [NSMutableArray array];
    for (FMLayoutBaseSection *section in self.headerInvalidateSections) {
        if ([section intersectsRect:newBounds]) {
            if (section.header.type != FMLayoutHeaderTypeFixed) {
                [headerIndexPaths addObject:section.indexPath];
            }
        } else {
            if (section.header.type == FMLayoutHeaderTypeSuspensionAlways || section.header.type == FMLayoutHeaderTypeSuspensionBigger) {
                [headerIndexPaths addObject:section.indexPath];
            }
        }
    }
    if (!change && headerIndexPaths.count > 0) {
        UICollectionViewLayoutInvalidationContext *context = [[UICollectionViewLayoutInvalidationContext alloc] init];
        [context invalidateSupplementaryElementsOfKind:UICollectionElementKindSectionHeader atIndexPaths:headerIndexPaths];
        [self invalidateLayoutWithContext:context];
    }
    return change;
}

- (CGSize)collectionViewContentSize{
    FMLayoutBaseSection *section = [self.sections lastObject];
    if (self.direction == FMLayoutDirectionVertical) {
        CGSize contentSize = CGSizeMake(0, section.sectionOffset + section.sectionSize + self.fixedLastMargin);
        if (contentSize.height < self.minContentSize) {
            contentSize.height = self.minContentSize;
        }
        return contentSize;
    } else {
        CGSize contentSize = CGSizeMake(section.sectionOffset + section.sectionSize + self.fixedLastMargin, 0);
        if (contentSize.width < self.minContentSize) {
            contentSize.width = self.minContentSize;
        }
        return contentSize;
    }
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath{
    return [self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:elementIndexPath];
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath{
    return [self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:elementIndexPath];
}

@end
