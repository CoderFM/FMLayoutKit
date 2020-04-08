//
//  FMCollectionCustomDecoration.m
//  FMCollectionLayout_Example
//
//  Created by 郑桂华 on 2020/4/8.
//  Copyright © 2020 周发明. All rights reserved.
//

#import "FMCollectionCustomDecoration.h"

@implementation FMCollectionCustomDecoration

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSInteger aRedValue =arc4random() %255;
        NSInteger aGreenValue =arc4random() %255;
        NSInteger aBlueValue =arc4random() %255;
        UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
        self.backgroundColor = randColor;
    }
    return self;
}

@end
