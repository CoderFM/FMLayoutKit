//
//  FMCollectionViewDelegateDataSourceProvider.m
//  FMLayoutKit
//
//  Created by 郑桂华 on 2021/3/27.
//

#import "FMCollectionViewDelegateDataSourceProvider.h"
#import "FMLayoutBaseSection.h"
#import "FMLayoutHeader.h"
#import "FMLayoutFooter.h"
#import "FMLayoutBackground.h"
#import "_FMLayoutSussEmptyView.h"

@implementation FMCollectionViewDelegateDataSourceProvider

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sections[section].itemCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FMLayoutBaseSection *sectionM = self.sections[indexPath.section];
    UICollectionViewCell *cell = [sectionM dequeueReusableCellForIndexPath:indexPath];
    if (sectionM.configureCellData) {
        sectionM.configureCellData(sectionM, cell, indexPath.item);
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    FMLayoutBaseSection *sectionM = self.sections[indexPath.section];
    if (sectionM.header && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [sectionM.header dequeueReusableViewWithCollection:collectionView indexPath:indexPath];
        if (sectionM.configureHeaderData) {
            sectionM.configureHeaderData(sectionM, header);
        }
        return header;
    }
    if (sectionM.footer && [kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footer = [sectionM.footer dequeueReusableViewWithCollection:collectionView indexPath:indexPath];
        if (sectionM.configureFooterData) {
            sectionM.configureFooterData(sectionM, footer);
        }
        return footer;
    }
    if (sectionM.background && [kind isEqualToString:UICollectionElementKindSectionBackground]) {
        UICollectionReusableView *bg = [sectionM.background dequeueReusableViewWithCollection:collectionView indexPath:indexPath];
        if (sectionM.configureBg) {
            sectionM.configureBg(sectionM, bg);
        }
        return bg;
    }
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([_FMLayoutSussEmptyView class]) forIndexPath:indexPath];
}
#pragma mark ----- delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.sections.count) {
        FMLayoutBaseSection *sectionM = self.sections[indexPath.section];
        if (sectionM.clickCellBlock) {
            sectionM.clickCellBlock(sectionM, indexPath.item);
        }
    }
}

@end
