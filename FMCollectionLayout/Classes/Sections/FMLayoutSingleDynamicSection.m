//
//  FMLayoutSingleDynamicSection.m
//  LiangShanApp
//
//  Created by 郑桂华 on 2020/4/9.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutSingleDynamicSection.h"

@implementation FMLayoutSingleDynamicSection

- (instancetype)init
{
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        [self setDeqCellReturnReuseId:^NSString * _Nonnull(FMLayoutDynamicSection * _Nonnull section, NSInteger index) {
            return weakSelf.cellElement.reuseIdentifier;
        }];
    }
    return self;
}

- (void)setCellElement:(FMCollectionViewElement *)cellElement{
    _cellElement = cellElement;
    self.cellElements = @[cellElement];
}

- (void)setSectionHeight:(CGFloat)sectionHeight{
    
    [super setSectionHeight:sectionHeight];
}

@end
