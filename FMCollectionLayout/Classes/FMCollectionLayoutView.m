//
//  FMCollectionLayoutView.m
//  FMLayoutKit
//
//  Created by 郑桂华 on 2020/4/1.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMCollectionLayoutView.h"
#import "FMHorizontalScrollCollCell.h"
#import "FMLayoutFixedSection.h"
#import "FMLayoutLabelSection.h"
#import "FMLayoutBaseSection+ConfigureBlock.h"

@interface FMCollectionLayoutView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, weak)id<UICollectionViewDataSource> externalDataSource;

@end

@implementation FMCollectionLayoutView

#pragma mark ----- Public
- (void)appendSections:(NSArray<FMLayoutBaseSection *> *)sections{
    [self.layout.sections addObjectsFromArray:sections];
}
- (void)insertSections:(NSArray<FMLayoutBaseSection *> *)sections atIndexSet:(NSIndexSet *)indexSet{
    [self.layout.sections insertObjects:sections atIndexes:indexSet];
    NSUInteger min = [indexSet firstIndex];
    self.layout.minSectionChangeOffsetYIndex = min;
}
- (void)insertSection:(FMLayoutBaseSection *)section atIndex:(NSInteger)index{
    if (index > self.layout.sections.count) {
        [self.layout.sections addObject:section];
    } else {
        [self.layout.sections insertObject:section atIndex:index];
    }
    self.layout.minSectionChangeOffsetYIndex = index;
}
- (void)deleteSections:(NSArray<FMLayoutBaseSection *> *)sections{
    [self.layout.sections removeObjectsInArray:sections];
    for (FMLayoutBaseSection *section in self.layout.sections) {
        section.hasHanble = NO;
    }
}

- (FMCollectionViewLayout *)layout{
    if (_layout == nil) {
        _layout = [[FMCollectionViewLayout alloc] init];
    }
    return _layout;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame collectionViewLayout:self.layout];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.reloaOlnyChanged = YES;
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

- (void)setReloaOlnyChanged:(BOOL)reloaOlnyChanged{
    _reloaOlnyChanged = reloaOlnyChanged;
    self.layout.reLayoutOlnyChanged = reloaOlnyChanged;
}

- (void)reloadData{
    self.layout.minSectionChangeOffsetYIndex = 0;
    [super reloadData];
}

- (void)reloadSections:(NSIndexSet *)sections{
    NSArray *layoutSections = [self.layout.sections objectsAtIndexes:sections];
    for (FMLayoutBaseSection *section in layoutSections) {
        section.hasHanble = NO;
        section.hanbleItemStart = 0;
    }
    [super reloadSections:sections];
}

- (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    for (NSIndexPath *indexPath in indexPaths) {
        NSInteger section = indexPath.section;
        if (section < self.layout.sections.count) {
            FMLayoutBaseSection *layoutSection = self.layout.sections[section];
            layoutSection.hasHanble = NO;
            if (indexPath.item < layoutSection.hanbleItemStart) {
                layoutSection.hanbleItemStart = indexPath.item;
            }
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
    FMLayoutBaseSection *sectionM = self.layout.sections[section];
    if ([sectionM isKindOfClass:[FMLayoutFixedSection class]]) {
        FMLayoutFixedSection *fixed = (FMLayoutFixedSection *)sectionM;
        if (fixed.isHorizontalCanScroll) {
            return 1;
        }
    }
    if ([sectionM isKindOfClass:[FMLayoutLabelSection class]]) {
        FMLayoutLabelSection *label = (FMLayoutLabelSection *)sectionM;
        if (label.isSingleLineCanScroll) {
            return 1;
        }
    }
    return self.layout.sections[section].itemDatas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.externalDataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]) {
        return [self.externalDataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    FMLayoutBaseSection *sectionM = self.layout.sections[indexPath.section];
    UICollectionViewCell *cell = [sectionM dequeueReusableCellForIndexPath:indexPath];
    if ([cell isKindOfClass:[FMHorizontalScrollCollCell class]]) {
        FMHorizontalScrollCollCell *hCell = (FMHorizontalScrollCollCell *)cell;
        __weak typeof(self) weakSelf = self;
        [hCell setConfigurationBlock:^(UICollectionViewCell * _Nonnull hItemCell, NSInteger item) {
            if (weakSelf.configuration && [weakSelf.configuration respondsToSelector:@selector(layoutView:configurationCell:indexPath:)]) {
                [weakSelf.configuration layoutView:weakSelf configurationCell:hItemCell indexPath:[NSIndexPath indexPathForItem:item inSection:indexPath.section]];
            } else {
                if (sectionM.configureCellData) {
                    sectionM.configureCellData(sectionM, cell, item);
                }
            }
        }];
        [hCell setSelectCellBlock:^(NSInteger item) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
                [weakSelf.delegate collectionView:collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:indexPath.section]];
            } else {
                if (sectionM.clickCellBlock) {
                    sectionM.clickCellBlock(sectionM, item);
                }
            }
        }];
        hCell.section = (FMLayoutFixedSection *)sectionM;
    } else {
        if (self.configuration && [self.configuration respondsToSelector:@selector(layoutView:configurationCell:indexPath:)]) {
            [self.configuration layoutView:self configurationCell:cell indexPath:indexPath];
        } else {
            if (sectionM.configureCellData) {
                sectionM.configureCellData(sectionM, cell, indexPath.item);
            }
        }
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
        if (self.configuration && [self.configuration respondsToSelector:@selector(layoutView:configurationHeader:indexPath:)]) {
            [self.configuration layoutView:self configurationHeader:header indexPath:indexPath];
        } else {
            if (sectionM.configureHeaderData) {
                sectionM.configureHeaderData(sectionM, header);
            }
        }
        return header;
    }
    if (sectionM.footer && [kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:sectionM.footer.elementKind withReuseIdentifier:NSStringFromClass(sectionM.footer.viewClass) forIndexPath:indexPath];
        if (self.configuration && [self.configuration respondsToSelector:@selector(layoutView:configurationFooter:indexPath:)]) {
            [self.configuration layoutView:self configurationFooter:footer indexPath:indexPath];
        } else {
            if (sectionM.configureFooterData) {
                sectionM.configureFooterData(sectionM, footer);
            }
        }
        return footer;
    }
    if (sectionM.background && [kind isEqualToString:UICollectionElementKindSectionBackground]) {
        UICollectionReusableView *bg = [collectionView dequeueReusableSupplementaryViewOfKind:sectionM.background.elementKind withReuseIdentifier:NSStringFromClass(sectionM.background.viewClass) forIndexPath:indexPath];
        if (self.configuration && [self.configuration respondsToSelector:@selector(layoutView:configurationSectionBg:indexPath:)]) {
            [self.configuration layoutView:self configurationSectionBg:bg indexPath:indexPath];
        } else {
            if (sectionM.configureBg) {
                sectionM.configureBg(sectionM, bg);
            }
        }
        return bg;
    }
    return nil;
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.layout.sections) {
        FMLayoutBaseSection *sectionM = self.layout.sections[indexPath.section];
        if (sectionM.clickCellBlock) {
            sectionM.clickCellBlock(sectionM, indexPath.item);
        }
    }
}

@end
