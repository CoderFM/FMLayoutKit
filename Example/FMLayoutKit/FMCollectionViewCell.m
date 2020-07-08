//
//  FMCollectionViewCell.m
//  FMLayoutKit_Example
//
//  Created by 周发明 on 2020/6/15.
//  Copyright © 2020 zhoufaming251@163.com. All rights reserved.
//

#import "FMCollectionViewCell.h"

@implementation FMCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor cyanColor];
}

@end
