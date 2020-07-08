//
//  FMLayoutBaseSection+DYConfigure.h
//  ChaZhiJia
//
//  Created by 周发明 on 2020/4/23.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutBaseSection.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMLayoutBaseSection (ConfigureBlock)
@property(nonatomic, strong)id headerData;
@property(nonatomic, strong)id footerData;
@property(nonatomic, copy)void(^configureHeaderData)(FMLayoutBaseSection *section, UICollectionReusableView *header);
@property(nonatomic, copy)void(^configureFooterData)(FMLayoutBaseSection *section, UICollectionReusableView *footer);
@property(nonatomic, copy)void(^configureBg)(FMLayoutBaseSection *section, UICollectionReusableView *bg);
@property(nonatomic, copy)void(^configureCellData)(FMLayoutBaseSection *section, UICollectionViewCell *cell, NSInteger item);

@property(nonatomic, copy)void(^clickCellBlock)(FMLayoutBaseSection *section, NSInteger item);

@end

NS_ASSUME_NONNULL_END
