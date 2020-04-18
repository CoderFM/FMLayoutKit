//
//  FMCollectionCustomCell.m
//  FMCollectionLayout_Example
//
//  Created by 郑桂华 on 2020/4/8.
//  Copyright © 2020 周发明. All rights reserved.
//

#import "FMCollectionCustomCell.h"
#import <Masonry/Masonry.h>

@implementation FMCollectionCustomCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSInteger aRedValue =arc4random() %255;
        NSInteger aGreenValue =arc4random() %255;
        NSInteger aBlueValue =arc4random() %255;
        UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
        self.contentView.backgroundColor = randColor;
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSStringFromClass(self.class);
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        self.label = label;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

@end
