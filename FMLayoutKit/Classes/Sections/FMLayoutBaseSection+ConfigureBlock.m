//
//  FMLayoutBaseSection+DYConfigure.m
//  ChaZhiJia
//
//  Created by 周发明 on 2020/4/23.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutBaseSection+ConfigureBlock.h"
#import "FMLayoutDynamicSection.h"
#import "FMLayoutFooter.h"
#import "FMLayoutHeader.h"
#import <objc/runtime.h>

static void * FMLayoutBaseSectionHeaderDataKey = &FMLayoutBaseSectionHeaderDataKey;
static void * FMLayoutBaseSectionFooterDataKey = &FMLayoutBaseSectionFooterDataKey;
static void * FMLayoutBaseSectionConfigureCellDataKey = &FMLayoutBaseSectionConfigureCellDataKey;
static void * FMLayoutBaseSectionConfigureHeaderDataKey = &FMLayoutBaseSectionConfigureHeaderDataKey;
static void * FMLayoutBaseSectionConfigureFooterDataKey = &FMLayoutBaseSectionConfigureFooterDataKey;
static void * FMLayoutBaseSectionConfigureBgKey = &FMLayoutBaseSectionConfigureBgKey;

static void * FMLayoutBaseSectionClickCellKey = &FMLayoutBaseSectionClickCellKey;

@implementation FMLayoutBaseSection (ConfigureBlock)

- (id)headerData{
    return objc_getAssociatedObject(self, FMLayoutBaseSectionHeaderDataKey);
}

- (void)setHeaderData:(id)headerData{
    objc_setAssociatedObject(self, FMLayoutBaseSectionHeaderDataKey, headerData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)footerData{
    return objc_getAssociatedObject(self, FMLayoutBaseSectionFooterDataKey);
}

- (void)setFooterData:(id)footerData{
    objc_setAssociatedObject(self, FMLayoutBaseSectionFooterDataKey, footerData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(FMLayoutBaseSection * _Nonnull, UICollectionViewCell * _Nonnull, NSInteger))configureCellData{
    return objc_getAssociatedObject(self, FMLayoutBaseSectionConfigureCellDataKey);
}

- (void)setConfigureCellData:(void (^)(FMLayoutBaseSection * _Nonnull, UICollectionViewCell * _Nonnull, NSInteger))configureCellData{
    if ([self isKindOfClass:[FMLayoutDynamicSection class]]) {
        FMLayoutDynamicSection *dySection = (FMLayoutDynamicSection *)self;
        if (!dySection.configurationCell) {
            dySection.configurationCell = configureCellData;
        }
    }
    objc_setAssociatedObject(self, FMLayoutBaseSectionConfigureCellDataKey, configureCellData, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(FMLayoutBaseSection * _Nonnull, UICollectionReusableView * _Nonnull))configureFooterData{
    return objc_getAssociatedObject(self, FMLayoutBaseSectionConfigureFooterDataKey);
}

- (void)setConfigureFooterData:(void (^)(FMLayoutBaseSection * _Nonnull, UICollectionReusableView * _Nonnull))configureFooterData{
    if (self.footer.autoHeight && configureFooterData) {
        if (!self.footer.configureDataAutoHeight) {
            __weak typeof(self) weakSelf = self;
            [self.footer setConfigureDataAutoHeight:^(UICollectionReusableView * _Nonnull view) {
                !configureFooterData?:configureFooterData(weakSelf, view);
            }];
        }
    }
    objc_setAssociatedObject(self, FMLayoutBaseSectionConfigureFooterDataKey, configureFooterData, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(FMLayoutBaseSection * _Nonnull, UICollectionReusableView * _Nonnull))configureHeaderData{
    return objc_getAssociatedObject(self, FMLayoutBaseSectionConfigureHeaderDataKey);
}

- (void)setConfigureHeaderData:(void (^)(FMLayoutBaseSection * _Nonnull, UICollectionReusableView * _Nonnull))configureHeaderData{
    if (self.header.autoHeight && configureHeaderData) {
        if (!self.header.configureDataAutoHeight) {
            __weak typeof(self) weakSelf = self;
            [self.header setConfigureDataAutoHeight:^(UICollectionReusableView * _Nonnull view) {
                !configureHeaderData?:configureHeaderData(weakSelf, view);
            }];
        }
    }
    objc_setAssociatedObject(self, FMLayoutBaseSectionConfigureHeaderDataKey, configureHeaderData, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (void (^)(FMLayoutBaseSection * _Nonnull, UICollectionReusableView * _Nonnull))configureBg{
    return objc_getAssociatedObject(self, FMLayoutBaseSectionConfigureBgKey);
}

- (void)setConfigureBg:(void (^)(FMLayoutBaseSection * _Nonnull, UICollectionReusableView * _Nonnull))configureBg{
    objc_setAssociatedObject(self, FMLayoutBaseSectionConfigureBgKey, configureBg, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (void (^)(FMLayoutBaseSection * _Nonnull, NSInteger))clickCellBlock{
    return objc_getAssociatedObject(self, FMLayoutBaseSectionClickCellKey);
}

- (void)setClickCellBlock:(void (^)(FMLayoutBaseSection * _Nonnull, NSInteger))clickCellBlock{
    objc_setAssociatedObject(self, FMLayoutBaseSectionClickCellKey, clickCellBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
