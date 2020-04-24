//
//  LS_HomeActivityCell.m
//  LiangShanApp
//
//  Created by 郑桂华 on 2020/4/9.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "LS_HomeActivityCell.h"
#import <Masonry/Masonry.h>
#import "FMLayoutLabel.h"

@implementation LS_HomeActivityCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *title = [[UILabel alloc] init];
        title.text = @"大标题";
        title.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(15);
        }];
        
        UILabel *detail = [[UILabel alloc] init];
        detail.text = @"小标题";
        detail.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:detail];
        [detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(title.mas_bottom).offset(5);
        }];
        
        UIImageView *left = [[UIImageView alloc] init];
        left.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:left];
        [left mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(detail.mas_bottom).offset(9);
            make.width.height.mas_equalTo(81);
        }];
        self.leftImageView = left;
        
        UIImageView *right = [[UIImageView alloc] init];
        right.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:right];
        [right mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(left.mas_right).offset(5);
            make.top.mas_equalTo(left);
            make.width.height.mas_equalTo(81);
        }];
        
        UILabel *intro = [[UILabel alloc] init];
        intro.preferredMaxLayoutWidth = 166;
        intro.numberOfLines = 0;
//        intro.text = @"一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少肯德基分离式的\n";
        intro.text = @"一些描述";
        [self.contentView addSubview:intro];
        [intro mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(left.mas_bottom);
            make.bottom.mas_equalTo(-10);
        }];
        self.introLabel = intro;
    }
    return self;
}

@end
