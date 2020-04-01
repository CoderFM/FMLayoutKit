//
//  FMSupplementaryBackground.m
//  LiangXinApp
//
//  Created by 郑桂华 on 2020/3/27.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMSupplementaryBackground.h"

@implementation FMSupplementaryBackground

- (NSString *)elementKind{
    return UICollectionElementKindSectionBackground;
}

+ (instancetype)bgWithViewClass:(Class)viewClass{
    FMSupplementaryBackground *bg = [super supplementaryHeight:0 viewClass:viewClass];
    bg.zIndex = FMSupplementaryZIndexBg;
    return bg;
}

@end
