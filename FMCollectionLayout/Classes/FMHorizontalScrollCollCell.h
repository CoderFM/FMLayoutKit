//
//  FMHorizontalScrollCollCell.h
//  LiangXinApp
//
//  Created by 郑桂华 on 2020/3/24.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FMLayoutSingleFixedSizeSection;
@interface FMHorizontalScrollCollCell : UICollectionViewCell
@property(nonatomic, strong)FMLayoutSingleFixedSizeSection *section;
@property(nonatomic, copy)void(^configurationBlock)(UICollectionViewCell *cell, NSInteger item);
@property(nonatomic, copy)void(^selectCellBlock)(NSInteger item);
@end

NS_ASSUME_NONNULL_END
