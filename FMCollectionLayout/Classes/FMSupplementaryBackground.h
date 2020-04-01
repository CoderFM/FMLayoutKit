//
//  FMSupplementaryBackground.h
//  LiangXinApp
//
//  Created by 郑桂华 on 2020/3/27.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMCollectionSupplementary.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const UICollectionElementKindSectionBackground = @"UICollectionElementKindSectionBackground";

@interface FMSupplementaryBackground : FMCollectionSupplementary

@property(nonatomic, assign)UIEdgeInsets inset;

+ (instancetype)bgWithViewClass:(Class)viewClass;

@end

NS_ASSUME_NONNULL_END
