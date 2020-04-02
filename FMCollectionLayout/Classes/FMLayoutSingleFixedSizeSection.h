//
//  FMLayoutSingleFixedSizeSection.h
//  FMLayoutKit
//
//  Created by 郑桂华 on 2020/4/1.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMCollectionLayoutBaseSection.h"
#import "FMCollectionViewElement.h"
NS_ASSUME_NONNULL_BEGIN

//typedef NS_ENUM(NSUInteger, FMLayoutHorizontalStyle) {
//    FMLayoutHorizontalStyleZ,
//    FMLayoutHorizontalStyleN
//};

@interface FMLayoutSingleFixedSizeSection : FMCollectionLayoutBaseSection

@property(nonatomic, assign)CGSize itemSize;///分组cell大小
@property(nonatomic, strong)FMCollectionViewElement *cellElement;///固定分组

@property(nonatomic, assign)BOOL isHorizontalCanScroll;///横向布局可滚动   插入一个cell+collection方式
//@property(nonatomic, assign)FMLayoutHorizontalStyle horizontalStyle;///横向布局方式  Z 还是  N
@end

NS_ASSUME_NONNULL_END
