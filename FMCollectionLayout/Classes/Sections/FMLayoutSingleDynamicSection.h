//
//  FMLayoutSingleDynamicSection.h
//  LiangShanApp
//
//  Created by 郑桂华 on 2020/4/9.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutDynamicSection.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMLayoutSingleDynamicSection : FMLayoutDynamicSection

@property(nonatomic, strong)FMCollectionViewElement *cellElement;///固定分组

@end

NS_ASSUME_NONNULL_END
