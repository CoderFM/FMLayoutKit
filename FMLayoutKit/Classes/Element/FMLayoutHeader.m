//
//  FMLayoutHeader.m
//  FMLayoutKit
//
//  Created by 周发明 on 2020/3/20.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutHeader.h"

@implementation FMLayoutHeader

+ (instancetype)elementSize:(CGFloat)size viewClass:(Class)vClass isNib:(BOOL)isNib reuseIdentifier:(NSString *)reuseIdentifier{
    FMLayoutHeader *header = [super elementSize:size viewClass:vClass isNib:isNib reuseIdentifier:reuseIdentifier];
    return header;
}

- (NSString *)elementKind{
    return UICollectionElementKindSectionHeader;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxSize = CGFLOAT_MAX;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    FMLayoutHeader *header = [super copyWithZone:zone];
    header.lastMargin = self.lastMargin;
    header.type = self.type;
    header.suspensionTopMargin = self.suspensionTopMargin;
    header.isStickTop = self.isStickTop;
    header.minSize = self.minSize;
    header.maxSize = self.maxSize;
    return header;
}

@end
