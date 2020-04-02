//
//  FMViewController.m
//  FMCollectionLayout
//
//  Created by 周发明 on 04/01/2020.
//  Copyright (c) 2020 周发明. All rights reserved.
//

#import "FMViewController.h"
#import <FMCollectionLayoutKit.h>
#import <Masonry/Masonry.h>


@interface FMCollectionCustomCell : UICollectionViewCell

@property(nonatomic, weak)UILabel *label;

@end

@implementation FMCollectionCustomCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        NSInteger aRedValue =arc4random() %255;
//        NSInteger aGreenValue =arc4random() %255;
//        NSInteger aBlueValue =arc4random() %255;
//        UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
//        self.contentView.backgroundColor = randColor;
        
        self.contentView.backgroundColor = [UIColor cyanColor];
        
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
//    self.label.frame = self.contentView.bounds;
}

@end

@interface FMCollectionCustomDecoration : UICollectionReusableView

@end

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

@interface FMViewController ()<FMCollectionLayoutViewConfigurationDelegate>

@property(nonatomic, strong)NSMutableArray<FMCollectionLayoutBaseSection *> *sections;
@property(nonatomic, weak)FMCollectionLayoutView *collectionView;

@end

@implementation FMViewController

- (FMCollectionLayoutView *)collectionView{
    if (_collectionView == nil) {
        FMCollectionLayoutView *collectionView = [[FMCollectionLayoutView alloc] initWithFrame:CGRectZero];
        collectionView.configuration = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.bounces = YES;
        collectionView.alwaysBounceVertical = YES;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sections = [NSMutableArray array];
    {
        FMLayoutSingleFixedSizeSection *section = [FMLayoutSingleFixedSizeSection sectionWithSectionInset:UIEdgeInsetsMake(15, 15, 15, 15) itemSpace:10 lineSpace:10 column:2];
        
        section.header = [FMSupplementaryHeader supplementaryHeight:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.bottomMargin = 10;
        section.header.type = FMSupplementaryTypeSuspension;
        
        section.footer = [FMSupplementaryFooter supplementaryHeight:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;
        
        section.itemSize = CGSizeMake(100, 100);
        section.itemDatas = [@[@"1", @"2", @"3"] mutableCopy];
        section.cellElement = [FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]];
        [self.sections addObject:section];
    }
    {
        FMLayoutSingleFixedSizeSection *section = [FMLayoutSingleFixedSizeSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:10 lineSpace:10 column:3];
        
        section.header = [FMSupplementaryHeader supplementaryHeight:150 viewClass:[FMCollectionCustomDecoration class]];
        section.header.zIndex = FMSupplementaryZIndexFrontOfItem;
        section.header.type = FMSupplementaryTypeFixed;
        section.header.bottomMargin = 10;
        
        section.isHorizontalCanScroll = YES;
        section.itemSize = CGSizeMake(150, 100);
        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", ] mutableCopy];
        section.cellElement = [FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]];
        [self.sections addObject:section];
    }
    {
        FMLayoutDynamicSection *section = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:0 lineSpace:10 column:1];
        
        section.header = [FMSupplementaryHeader supplementaryHeight:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.bottomMargin = 10;
        section.header.type = FMSupplementaryTypeSuspensionAlways;
        section.header.zIndex = FMSupplementaryZIndexFrontAlways;
        
        section.footer = [FMSupplementaryFooter supplementaryHeight:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;
        
        section.itemDatas = [@[@"1", @"2", @"3"] mutableCopy];
        section.cellElements = @[[FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]]];
        section.cellFixedWidth = self.view.bounds.size.width;
        [section setHeightBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
            return 100 + item * 100;
        }];
        [section setDeqCellReturnReuseId:^NSString * _Nonnull(FMLayoutDynamicSection * _Nonnull section, NSInteger index) {
            return [section.cellElements firstObject].reuseIdentifier;
        }];
        
        [self.sections addObject:section];
    }
    
    {
        FMLayoutDynamicSection *section = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(10, 0, 0, 0) itemSpace:10 lineSpace:10 column:2];
        
        section.header = [FMSupplementaryHeader supplementaryHeight:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.bottomMargin = 10;
        
        section.footer = [FMSupplementaryFooter supplementaryHeight:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;
        
        section.itemDatas = [@[@"1", @"2", @"3", @"2", @"3", @"2", @"3"] mutableCopy];
        section.cellElements = @[[FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]]];
        section.cellFixedWidth = (self.view.bounds.size.width - 10) * 0.5;
        [section setHeightBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
            return 100 + item * 30;
        }];
        [section setDeqCellReturnReuseId:^NSString * _Nonnull(FMLayoutDynamicSection * _Nonnull section, NSInteger index) {
            return [section.cellElements firstObject].reuseIdentifier;
        }];
        [self.sections addObject:section];
    }
    
    {
        FMLayoutDynamicSection *section = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(10, 0, 0, 0) itemSpace:10 lineSpace:10 column:2];
        
        section.header = [FMSupplementaryHeader supplementaryHeight:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.bottomMargin = 10;
        
        section.footer = [FMSupplementaryFooter supplementaryHeight:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;
        
        section.itemDatas = [@[@"1\n1", @"2\n2\n2", @"3", @"2\n2\n2\n2\n2\n2\n2\n2\n2", @"3\n2\n2\n2\n2", @"2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2", @"3\n2\n2"] mutableCopy];
        section.cellElements = @[[FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]]];
        section.cellFixedWidth = (self.view.bounds.size.width - 10) * 0.5;
        [section setDeqCellReturnReuseId:^NSString * _Nonnull(FMLayoutDynamicSection * _Nonnull section, NSInteger index) {
            return [section.cellElements firstObject].reuseIdentifier;
        }];
        
        section.autoHeightFixedWidth = YES;
        __weak typeof(self) weakSelf = self;
        [section setConfigurationCell:^(FMLayoutDynamicSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger index) {
            [weakSelf configurationCell:cell indexPath:[NSIndexPath indexPathForItem:index inSection:section.indexPath.section]];
        }];
        [self.sections addObject:section];
    }
    
    [self.collectionView.layout setSections:self.sections];
    [self.collectionView reloadData];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (void)configurationCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        FMCollectionCustomCell *customCell = (FMCollectionCustomCell *)cell;
        customCell.label.text = self.sections[indexPath.section].itemDatas[indexPath.item];
    }
}

@end
