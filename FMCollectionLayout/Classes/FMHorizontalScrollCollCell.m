//
//  FMHorizontalScrollCollCell.m
//  LiangXinApp
//
//  Created by 郑桂华 on 2020/3/24.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMHorizontalScrollCollCell.h"
#import "FMLayoutSingleFixedSizeSection.h"
#import "FMSupplementaryFooter.h"
#import "FMSupplementaryHeader.h"

@interface FMHorizontalScrollCollCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, weak)UICollectionView *collectionView;
@end

@implementation FMHorizontalScrollCollCell

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *coll = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
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

- (void)setSection:(FMLayoutSingleFixedSizeSection *)section{
    _section = section;
    [self.collectionView registerClass:section.cellElement.viewClass forCellWithReuseIdentifier:section.cellElement.reuseIdentifier];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = section.itemSize;
    layout.sectionInset = UIEdgeInsetsMake(section.header.bottomMargin, section.sectionInset.left, section.footer.topMargin, section.sectionInset.right);
    layout.minimumInteritemSpacing = section.itemSpace;
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
