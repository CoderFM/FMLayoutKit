//
//  FMAotuSizeReusableView.m
//  FMLayoutKit_Example
//
//  Created by 郑桂华 on 2020/7/3.
//  Copyright © 2020 zhoufaming251@163.com. All rights reserved.
//

#import "FMAotuSizeReusableView.h"
#import <Masonry.h>

@implementation FMAotuSizeReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColor.cyanColor;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"自动布局高度大小";
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(20);
        }];
        
        UILabel *content = [[UILabel alloc] init];
        content.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 40;
        content.text = @"内容\n内容埃里克森基多拉可接受的拉可视角度阿拉山口基多拉刷卡机的啦可视角度拉克丝基多拉可视角度拉克丝基多拉可视角度拉手孔";
        content.numberOfLines = 0;
        [self addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(label.mas_bottom).offset(20);
            make.bottom.mas_equalTo(-20);
        }];
        self.contentLabel = content;
    }
    return self;
}

@end
