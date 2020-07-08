//
//  FMCollectionCustomDecoration.m
//  FMCollectionLayout_Example
//
//  Created by 周发明 on 2020/4/8.
//  Copyright © 2020 周发明. All rights reserved.
//

#import "FMCollectionCustomDecoration.h"
#import <Masonry/Masonry.h>

@implementation FMCollectionCustomDecoration

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        NSInteger aRedValue =arc4random() %255;
//        NSInteger aGreenValue =arc4random() %255;
//        NSInteger aBlueValue =arc4random() %255;
//        UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
//        self.backgroundColor = randColor;
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timg"]];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds = YES;
        [self addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        UILabel *text = [[UILabel alloc] init];
        text.numberOfLines = 0;
        text.textColor = [UIColor whiteColor];
        [self addSubview:text];
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.right.mas_equalTo(0);
        }];
        self.textLabel = text;
    }
    return self;
}



@end
