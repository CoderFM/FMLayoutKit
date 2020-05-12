//
//  FMSupplementaryHeader.h
//  LiangXinApp
//
//  Created by 郑桂华 on 2020/3/20.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMCollectionSupplementary.h"
NS_ASSUME_NONNULL_BEGIN

@interface FMSupplementaryHeader : FMCollectionSupplementary
/// 悬浮模式  具体顶部的高度  可以来设置两个悬浮的方式
@property(nonatomic, assign)CGFloat suspensionTopHeight;

@property(nonatomic, assign)CGFloat bottomMargin;

///是否黏在顶部 目前仅支持FMSupplementaryTypeSuspensionAlways悬浮模式
@property(nonatomic, assign)BOOL isStickTop;

@end

NS_ASSUME_NONNULL_END
