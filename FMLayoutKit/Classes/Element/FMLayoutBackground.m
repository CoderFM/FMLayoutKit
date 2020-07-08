//
//  FMLayoutBackground.m
//  FMLayoutKit
//
//  Created by 周发明 on 2020/3/27.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutBackground.h"

@implementation FMLayoutBackground

- (NSString *)elementKind{
    return UICollectionElementKindSectionBackground;
}

+ (instancetype)bgWithViewClass:(Class)viewClass{
    FMLayoutBackground *bg = [super elementWithViewClass:viewClass];
    bg.zIndex = FMLayoutZIndexBg;
    return bg;
}

@end
