//
//  FMLayoutBackground.h
//  FMLayoutKit
//
//  Created by 周发明 on 2020/3/27.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMSupplementary.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const UICollectionElementKindSectionBackground = @"UICollectionElementKindSectionBackground";

@interface FMLayoutBackground : FMSupplementary

+ (instancetype)bgWithViewClass:(Class)viewClass;

@end

NS_ASSUME_NONNULL_END
