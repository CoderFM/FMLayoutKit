//
//  FMLayoutFooter.m
//  FMLayoutKit
//
//  Created by 周发明 on 2020/3/20.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutFooter.h"

@implementation FMLayoutFooter

- (NSString *)elementKind{
    return UICollectionElementKindSectionFooter;
}

- (id)copyWithZone:(NSZone *)zone{
    FMLayoutFooter *footer = [super copyWithZone:zone];
    footer.topMargin = self.topMargin;
    return footer;
}

@end
