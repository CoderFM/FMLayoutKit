//
//  FMLayoutHeader.h
//  FMLayoutKit
//
//  Created by 周发明 on 2020/3/20.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMSupplementary.h"
NS_ASSUME_NONNULL_BEGIN
/// 悬浮方式
typedef NS_ENUM(NSInteger, FMLayoutHeaderType) {
    ///跟着滚动
    FMLayoutHeaderTypeFixed,
    ///悬浮在顶部  跟着section动
    FMLayoutHeaderTypeSuspension,
    ///悬浮在顶部  不跟随section动   如果出现多个可能会被覆盖
    FMLayoutHeaderTypeSuspensionAlways,
    ///仅支持在第一个头部   下拉放大效果
    FMLayoutHeaderTypeSuspensionBigger
};

@interface FMLayoutHeader : FMSupplementary
/// 显示方式  是悬浮  还是跟着滚动   默认跟着滚动
@property(nonatomic, assign)FMLayoutHeaderType type;
/// 悬浮模式时距离顶部的高度  可以来设置两个悬浮的方式  多个顶部悬浮时  可以通过这个来达到层叠悬浮的模式
@property(nonatomic, assign)CGFloat suspensionTopMargin;
/// 距离第一个Item的距离 纵向-下方 横向-右边
@property(nonatomic, assign)CGFloat lastMargin;
///是否黏在顶部 目前仅支持FMLayoutHeaderTypeSuspensionAlways, FMLayoutHeaderTypeSuspensionBigger悬浮模式 不同的type效果不同 FMLayoutHeaderTypeSuspensionAlways是下拉黏在当前位置 上拉黏在顶部 而FMLayoutHeaderTypeSuspensionBiggers是上拉黏在顶部 下拉时放大效果
@property(nonatomic, assign)BOOL isStickTop;
/// 缩放模式(SuspensionBigger)下最小值  横向-宽度 纵向-高度  该值请务必小于size  默认是0
@property(nonatomic, assign)CGFloat minSize;
/// 缩放模式(SuspensionBigger)下最大值  横向-宽度 纵向-高度  该值请务必大于size  默认是CGFLOAT_MAX
@property(nonatomic, assign)CGFloat maxSize;

@end

NS_ASSUME_NONNULL_END
