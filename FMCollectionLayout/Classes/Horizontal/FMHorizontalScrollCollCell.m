//
//  FMHorizontalScrollCollCell.m
//  LiangXinApp
//
//  Created by 郑桂华 on 2020/3/24.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMHorizontalScrollCollCell.h"
#import "FMLayoutFixedSection.h"
#import "FMSupplementaryFooter.h"
#import "FMSupplementaryHeader.h"
#import "FMCollectionHorizontalLayout.h"

@interface FMHorizontalScrollCollCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, weak)UICollectionView *collectionView;
@property(nonatomic, strong)FMCollectionHorizontalLayout *layout;
@end

@implementation FMHorizontalScrollCollCell

- (FMCollectionHorizontalLayout *)layout{
    if (_layout == nil) {
        _layout = [[FMCollectionHorizontalLayout alloc] init];
    }
    return _layout;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionView *coll = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        coll.backgroundColor = [UIColor clearColor];
        coll.delegate = self;
        coll.dataSource = self;
        coll.showsHorizontalScrollIndicator = NO;
        [coll registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [self.contentView addSubview:coll];
        _collectionView = coll;
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.contentView.bounds;
}

- (void)setSection:(FMLayoutFixedSection *)section{
    _section = section;
    [self.collectionView registerClass:section.cellElement.viewClass forCellWithReuseIdentifier:section.cellElement.reuseIdentifier];
    self.layout.section = section;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.section.itemDatas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.section) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.section.cellElement.reuseIdentifier forIndexPath:indexPath];
        !self.configurationBlock?:self.configurationBlock(cell, indexPath.item);
        return cell;
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectCellBlock) {
        self.selectCellBlock(indexPath.item);
    }
}

@end
