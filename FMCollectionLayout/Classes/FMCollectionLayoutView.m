//
//  FMCollectionLayoutView.m
//  FMLayoutKit
//
//  Created by 郑桂华 on 2020/4/1.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMCollectionLayoutView.h"
#import "FMHorizontalScrollCollCell.h"

@interface FMCollectionLayoutView ()<UICollectionViewDataSource>

@property(nonatomic, weak)id<UICollectionViewDataSource> externalDataSource;

@end

@implementation FMCollectionLayoutView

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
    }
    return self;
}

- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource{
    if (dataSource == self) {
        [super setDataSource:dataSource];
    } else {
        self.externalDataSource = dataSource;
        [super setDataSource:dataSource];
    }
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
    return self.layout.sections[section].itemDatas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.externalDataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]) {
        return [self.externalDataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    FMCollectionLayoutBaseSection *sectionM = self.layout.sections[indexPath.section];
    UICollectionViewCell *cell = [sectionM dequeueReusableCellForIndexPath:indexPath];
    if ([cell isKindOfClass:[FMHorizontalScrollCollCell class]]) {
        FMHorizontalScrollCollCell *hCell = (FMHorizontalScrollCollCell *)cell;
        __weak typeof(self) weakSelf = self;
        [hCell setConfigurationBlock:^(UICollectionViewCell * _Nonnull hItemCell, NSInteger item) {
            if (weakSelf.configuration && [weakSelf.configuration respondsToSelector:@selector(configurationCell:indexPath:)]) {
                [weakSelf.configuration configurationCell:hItemCell indexPath:[NSIndexPath indexPathForItem:item inSection:indexPath.section]];
            }
        }];
        [hCell setSelectCellBlock:^(NSInteger item) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
                [weakSelf.delegate collectionView:collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:indexPath.section]];
            }
        }];
        hCell.section = (FMLayoutSingleFixedSizeSection *)sectionM;
    }
    if (self.configuration && [self.configuration respondsToSelector:@selector(configurationCell:indexPath:)]) {
        [self.configuration configurationCell:cell indexPath:indexPath];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (self.externalDataSource && [self.externalDataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        return [self.externalDataSource collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    FMCollectionLayoutBaseSection *sectionM = self.layout.sections[indexPath.section];
    if (sectionM.header && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:sectionM.header.elementKind withReuseIdentifier:NSStringFromClass(sectionM.header.viewClass) forIndexPath:indexPath];
        if (self.configuration && [self.configuration respondsToSelector:@selector(configurationHeader:indexPath:)]) {
            [self.configuration configurationHeader:header indexPath:indexPath];
        }
        return header;
    }
    if (sectionM.footer && [kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:sectionM.footer.elementKind withReuseIdentifier:NSStringFromClass(sectionM.footer.viewClass) forIndexPath:indexPath];
        if (self.configuration && [self.configuration respondsToSelector:@selector(configurationFooter:indexPath:)]) {
            [self.configuration configurationFooter:footer indexPath:indexPath];
        }
        return footer;
    }
    if (sectionM.background && [kind isEqualToString:UICollectionElementKindSectionBackground]) {
        UICollectionReusableView *bg = [collectionView dequeueReusableSupplementaryViewOfKind:sectionM.background.elementKind withReuseIdentifier:NSStringFromClass(sectionM.background.viewClass) forIndexPath:indexPath];
        if (self.configuration && [self.configuration respondsToSelector:@selector(configurationSectionBg:indexPath:)]) {
            [self.configuration configurationSectionBg:bg indexPath:indexPath];
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

@end
