//
//  FMLayoutView.m
//  FMLayoutKit
//
//  Created by 周发明 on 2020/4/1.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutView.h"
#import "FMLayoutFixedSection.h"
#import "FMLayoutLabelSection.h"
#import "FMLayoutBaseSection+ConfigureBlock.h"

@interface _FMLayoutSussEmptyView : UICollectionReusableView

@end

@implementation _FMLayoutSussEmptyView
 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
    }
    return self;
}

@end

@interface FMLayoutView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, weak)id<UICollectionViewDataSource> externalDataSource;
@property(nonatomic, weak)id<UICollectionViewDelegate> externalDelegate;
@end

@implementation FMLayoutView

#pragma mark ----- Public
- (void)appendLayoutSections:(NSArray<FMLayoutBaseSection *> *)sections{
    [self.layout.sections addObjectsFromArray:sections];
}
- (void)insertLayoutSections:(NSArray<FMLayoutBaseSection *> *)sections atIndexSet:(NSIndexSet *)indexSet{
    [self.layout.sections insertObjects:sections atIndexes:indexSet];
}
- (void)insertLayoutSection:(FMLayoutBaseSection *)section atIndex:(NSInteger)index{
    if (index > self.layout.sections.count) {
        [self.layout.sections addObject:section];
    } else {
        [self.layout.sections insertObject:section atIndex:index];
    }
}
- (void)deleteLayoutSections:(NSArray<FMLayoutBaseSection *> *)sections{
    [self.layout.sections removeObjectsInArray:sections];
}

- (void)deleteLayoutSectionAt:(NSUInteger)index{
    [self.layout.sections removeObjectAtIndex:index];
}

- (void)deleteLayoutSectionSet:(NSIndexSet *)set{
    [self.layout.sections removeObjectsAtIndexes:set];
}

- (void)exchangeLayoutSection:(NSUInteger)index to:(NSUInteger)to{
    [self.layout.sections exchangeObjectAtIndex:index withObjectAtIndex:to];
}

- (NSMutableArray<FMLayoutBaseSection *> *)sections{
    return self.layout.sections;
}

- (void)setSections:(NSMutableArray<FMLayoutBaseSection *> *)sections{
    self.layout.sections = sections;
}

- (void)dealloc{
    FMLayoutLog(@"FMLayoutView dealloc");
}

- (instancetype)initHorizontal{
    return [self initHorizontalWithFrame:CGRectZero];
}
- (instancetype)initHorizontalWithFrame:(CGRect)frame{
    if (self = [self initWithFrame:frame]) {
        self.layout.direction = FMLayoutDirectionHorizontal;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame collectionViewLayout:[[FMLayout alloc] init]];
    if (self) {
        self.layout = (FMLayout *)self.collectionViewLayout;
        self.dataSource = self;
        self.delegate = self;
        self.reloadOlnyChanged = YES;
        self.directionalLockEnabled = YES;
        
        [self registerClass:[_FMLayoutSussEmptyView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([_FMLayoutSussEmptyView class])];
        [self registerClass:[_FMLayoutSussEmptyView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([_FMLayoutSussEmptyView class])];
        [self registerClass:[_FMLayoutSussEmptyView class] forSupplementaryViewOfKind:UICollectionElementKindSectionBackground withReuseIdentifier:NSStringFromClass([_FMLayoutSussEmptyView class])];
    }
    return self;
}

- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource{
    if (dataSource == self) {
        self.externalDataSource = nil;
    } else {
        self.externalDataSource = dataSource;
    }
    [super setDataSource:self];
}

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate{
    if (delegate == nil) {
        return;
    }
    if (delegate == self) {
        self.externalDelegate = nil;
    } else {
        self.externalDelegate = delegate;
    }
    [super setDelegate:self];
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated{
    CGPoint offset = [self contentOffsetScrollToIndexPath:indexPath atScrollPosition:scrollPosition];
    [self setContentOffset:offset animated:animated];
}

- (void)setReloadOlnyChanged:(BOOL)reloadOlnyChanged{
    _reloadOlnyChanged = reloadOlnyChanged;
    self.layout.reLayoutOlnyChanged = reloadOlnyChanged;
}

- (void)reloadChangedSectionsData{
    if (self.reloadOlnyChanged) {
        if (self.layout.sections == nil || self.layout.sections.count == 0) {
            [super reloadData];
            return;
        }
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (int i = 0; i<self.layout.sections.count; i++) {
            FMLayoutBaseSection *section = self.layout.sections[i];
            if (section.hasHandle == NO) {
                [set addIndex:i];
            }
        }
        if (set.count > 0) {
            [super reloadSections:set];
        } else {
            [super reloadData];
        }
    } else {
        [super reloadData];
    }
}

- (CGPoint)contentOffsetScrollToIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition{
    if (CGSizeEqualToSize(CGSizeZero, self.contentSize)) {
        [self layoutIfNeeded];
    }
    UICollectionViewLayoutAttributes *layoutAttr = [self.layout layoutAttributesForItemAtIndexPath:indexPath];
    CGPoint offset = self.contentOffset;
    if (!layoutAttr) {
        return offset;
    }
    if (self.layout.direction == FMLayoutDirectionVertical) {
        switch (scrollPosition) {
            case UICollectionViewScrollPositionTop:
                offset.y = CGRectGetMinY(layoutAttr.frame);
                break;
            case UICollectionViewScrollPositionCenteredVertically:
                offset.y = CGRectGetMinY(layoutAttr.frame) - self.frame.size.height * 0.5 + layoutAttr.frame.size.height * 0.5;
                break;
            case UICollectionViewScrollPositionBottom:
                offset.y = CGRectGetMinY(layoutAttr.frame) - self.frame.size.height + layoutAttr.frame.size.height;
                break;
            default:
                break;
        }
        if (offset.y < 0) {
            offset.y = 0;
        }
    } else {
        switch (scrollPosition) {
            case UICollectionViewScrollPositionLeft:
                offset.x = CGRectGetMinX(layoutAttr.frame);
                break;
            case UICollectionViewScrollPositionCenteredHorizontally:
                offset.x = CGRectGetMinX(layoutAttr.frame) - self.frame.size.width * 0.5 + layoutAttr.frame.size.width * 0.5;
                break;
            case UICollectionViewScrollPositionRight:
                offset.x = CGRectGetMinX(layoutAttr.frame) - self.frame.size.width + layoutAttr.frame.size.width;
                break;
            default:
                break;
        }
        if (offset.x < 0) {
            offset.x = 0;
        }
    }
    return offset;
}

- (void)reloadSections:(NSIndexSet *)sections{
    NSArray *layoutSections = [self.layout.sections objectsAtIndexes:sections];
    for (FMLayoutBaseSection *section in layoutSections) {
        section.hasHandle = NO;
    }
    [super reloadSections:sections];
}

- (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    for (NSIndexPath *indexPath in indexPaths) {
        NSInteger section = indexPath.section;
        if (section < self.layout.sections.count) {
            FMLayoutBaseSection *layoutSection = self.layout.sections[section];
            layoutSection.hasHandle = NO;
        }
    }
    [super reloadItemsAtIndexPaths:indexPaths];
}

#pragma mark ----- dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.externalDataSource && [self.externalDataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        return [self.externalDataSource numberOfSectionsInCollectionView:collectionView];
    }
    return self.layout.sections.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self.externalDataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        return [self.externalDataSource collectionView:collectionView numberOfItemsInSection:section];
    }
    return self.layout.sections[section].itemCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.externalDataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]) {
        return [self.externalDataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    FMLayoutBaseSection *sectionM = self.layout.sections[indexPath.section];
    UICollectionViewCell *cell = [sectionM dequeueReusableCellForIndexPath:indexPath];
    if (sectionM.configureCellData) {
        sectionM.configureCellData(sectionM, cell, indexPath.item);
    }
    if (self.configuration && [self.configuration respondsToSelector:@selector(layoutView:configurationCell:indexPath:)]) {
        [self.configuration layoutView:self configurationCell:cell indexPath:indexPath];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (self.externalDataSource && [self.externalDataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        return [self.externalDataSource collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    FMLayoutBaseSection *sectionM = self.layout.sections[indexPath.section];
    if (sectionM.header && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:sectionM.header.elementKind withReuseIdentifier:NSStringFromClass(sectionM.header.viewClass) forIndexPath:indexPath];
        if (sectionM.configureHeaderData) {
            sectionM.configureHeaderData(sectionM, header);
        }
        if (self.configuration && [self.configuration respondsToSelector:@selector(layoutView:configurationHeader:indexPath:)]) {
            [self.configuration layoutView:self configurationHeader:header indexPath:indexPath];
        }
        return header;
    }
    if (sectionM.footer && [kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:sectionM.footer.elementKind withReuseIdentifier:NSStringFromClass(sectionM.footer.viewClass) forIndexPath:indexPath];
        if (sectionM.configureFooterData) {
            sectionM.configureFooterData(sectionM, footer);
        }
        if (self.configuration && [self.configuration respondsToSelector:@selector(layoutView:configurationFooter:indexPath:)]) {
            [self.configuration layoutView:self configurationFooter:footer indexPath:indexPath];
        }
        return footer;
    }
    if (sectionM.background && [kind isEqualToString:UICollectionElementKindSectionBackground]) {
        UICollectionReusableView *bg = [collectionView dequeueReusableSupplementaryViewOfKind:sectionM.background.elementKind withReuseIdentifier:NSStringFromClass(sectionM.background.viewClass) forIndexPath:indexPath];
        if (sectionM.configureBg) {
            sectionM.configureBg(sectionM, bg);
        }
        if (self.configuration && [self.configuration respondsToSelector:@selector(layoutView:configurationSectionBg:indexPath:)]) {
            [self.configuration layoutView:self configurationSectionBg:bg indexPath:indexPath];
        }
        return bg;
    }
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([_FMLayoutSussEmptyView class]) forIndexPath:indexPath];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(9.0)){
    return [self.externalDataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)] && [self.externalDataSource collectionView:collectionView canMoveItemAtIndexPath:indexPath];
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath API_AVAILABLE(ios(9.0)){
    if ([self.externalDataSource respondsToSelector:@selector(collectionView:moveItemAtIndexPath:toIndexPath:)]) {
        [self.externalDataSource collectionView:collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}

- (nullable NSArray<NSString *> *)indexTitlesForCollectionView:(UICollectionView *)collectionView API_AVAILABLE(tvos(10.2)){
    if ([self.externalDataSource respondsToSelector:@selector(indexTitlesForCollectionView:)]) {
        return [self.externalDataSource indexTitlesForCollectionView:collectionView];
    }
    return nil;
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView indexPathForIndexTitle:(NSString *)title atIndex:(NSInteger)index API_AVAILABLE(tvos(10.2)){
    if ([self.externalDataSource respondsToSelector:@selector(collectionView:indexPathForIndexTitle:atIndex:)]) {
        return [self.externalDataSource collectionView:collectionView indexPathForIndexTitle:title atIndex:index];
    }
    return nil;
}

#pragma mark ----- delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.layout.sections.count) {
        FMLayoutBaseSection *sectionM = self.layout.sections[indexPath.section];
        if (sectionM.clickCellBlock) {
            sectionM.clickCellBlock(sectionM, indexPath.item);
        }
    }
    if ([self.externalDelegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.externalDelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.externalDelegate respondsToSelector:@selector(collectionView:willDisplayCell:forItemAtIndexPath:)]) {
        [self.externalDelegate collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    if ([self.externalDelegate respondsToSelector:@selector(collectionView:willDisplaySupplementaryView:forElementKind:atIndexPath:)]) {
        [self.externalDelegate collectionView:collectionView willDisplaySupplementaryView:view forElementKind:elementKind atIndexPath:indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.externalDelegate respondsToSelector:@selector(collectionView:didEndDisplayingCell:forItemAtIndexPath:)]) {
        [self.externalDelegate collectionView:collectionView didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    if ([self.externalDelegate respondsToSelector:@selector(collectionView:didEndDisplayingSupplementaryView:forElementOfKind:atIndexPath:)]) {
        [self.externalDelegate collectionView:collectionView didEndDisplayingSupplementaryView:view forElementOfKind:elementKind atIndexPath:indexPath];
    }
}

#pragma mark ----- scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.externalDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.externalDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self.externalDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.externalDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if ([self.externalDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.externalDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([self.externalDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.externalDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([self.externalDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.externalDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.externalDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.externalDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if ([self.externalDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.externalDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    if ([self.externalDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.externalDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if ([self.externalDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.externalDelegate scrollViewDidScrollToTop:scrollView];
    }
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView API_AVAILABLE(ios(11.0), tvos(11.0)){
    if ([self.externalDelegate respondsToSelector:@selector(scrollViewDidChangeAdjustedContentInset:)]) {
        [self.externalDelegate scrollViewDidChangeAdjustedContentInset:scrollView];
    }
}

@end
