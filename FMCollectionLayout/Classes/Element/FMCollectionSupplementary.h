//
//  FMCollectionSupplementary.h
//  LiangXinApp
//
//  Created by 郑桂华 on 2020/3/20.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FMSupplementaryType) {/// 目前仅支持header悬浮
    ///跟着滚动
    FMSupplementaryTypeFixed,
    ///悬浮在顶部  跟着section动
    FMSupplementaryTypeSuspension,
    ///悬浮在顶部  不跟随section动   如果出现多个可能会被覆盖
    FMSupplementaryTypeSuspensionAlways
};

typedef NS_ENUM(NSInteger, FMSupplementaryZIndex) {
    ///最底层   头部  底部   Item的下方
    FMSupplementaryZIndexBg = -9999,
    ///Item的下方
    FMSupplementaryZIndexBackOfItem = -1,
    /// 自动悬浮可能会被覆盖
    FMSupplementaryZIndexAuto = 0,
    /// Item的上方
    FMSupplementaryZIndexFrontOfItem = 1,
    /// 最最上方
    FMSupplementaryZIndexFrontAlways = 9999
};

NS_ASSUME_NONNULL_BEGIN

@interface FMCollectionSupplementary : NSObject

@property(nonatomic, assign)CGFloat height;///高度
@property(nonatomic, assign)Class viewClass;///视图的类

@property(nonatomic, assign)FMSupplementaryType type;/// 显示方式  是悬浮  还是跟着滚动   默认跟着滚动
@property(nonatomic, assign)FMSupplementaryZIndex zIndex;///视图层级   最上方还是最下方等

@property(nonatomic, copy, readonly)NSString *elementKind; // UICollectionElementKindSectionFooter

+ (instancetype)supplementaryHeight:(CGFloat)height viewClass:(Class)vClass;
+ (instancetype)supplementaryHeight:(CGFloat)height viewClass:(Class)vClass isNib:(BOOL)isNib;

- (void)registerWithCollectionView:(UICollectionView *)collectionView;

@end

NS_ASSUME_NONNULL_END
