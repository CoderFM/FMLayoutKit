//
//  FMCollectionLayoutAttributes.m
//  LiangXinApp
//
//  Created by 郑桂华 on 2020/3/25.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMCollectionLayoutAttributes.h"

@implementation FMCollectionLayoutAttributes

- (id)copyWithZone:(NSZone *)zone{
    FMCollectionLayoutAttributes *attr = [super copyWithZone:zone];
    attr.isInvalidate = self.isInvalidate;
    return attr;
}

@end
