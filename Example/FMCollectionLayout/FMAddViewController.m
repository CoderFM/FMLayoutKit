//
//  FMAddViewController.m
//  FMCollectionLayout_Example
//
//  Created by 郑桂华 on 2020/4/17.
//  Copyright © 2020 周发明. All rights reserved.
//

#import "FMAddViewController.h"
#import <FMCollectionLayout.h>
#import <Masonry/Masonry.h>
#import "LS_HomeActivityCell.h"

#import "FMCollectionCustomDecoration.h"
#import "FMCollectionCustomCell.h"
#import "FMCollectionNavTitleView.h"

@interface FMAddViewController ()<FMCollectionLayoutViewConfigurationDelegate, UICollectionViewDelegate>

@property(nonatomic, strong)NSMutableArray<FMLayoutBaseSection *> *shareSections;
@property(nonatomic, weak)FMCollectionLayoutView  *collectionView;


@property(nonatomic, weak)FMLayoutFixedAddSection *firstSection;
@property(nonatomic, weak)FMLayoutSingleDynamicAddSection *secondSection;

@end

@implementation FMAddViewController

- (void)firstAdd{
    [self.firstSection.itemDatas addObjectsFromArray:@[@"1", @"2", @"3", @"4"]];
    [self.collectionView reloadData];
}
- (void)firstDelete{
    [self.firstSection.itemDatas removeLastObject];
    [self.collectionView reloadData];
}
- (void)secondsReplace{
    [self.secondSection.itemDatas replaceObjectAtIndex:2 withObject:@"2"];
    [self.collectionView reloadData];
}
- (void)secondsAdd{
    [self.secondSection.itemDatas addObjectsFromArray:@[@"1", @"2", @"3", @"4"]];
    [self.collectionView reloadData];
}
- (void)secondsDelete{
    [self.secondSection.itemDatas removeLastObject];
    [self.collectionView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"一添加" style:UIBarButtonItemStyleDone target:self action:@selector(firstAdd)];
//    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"一删除" style:UIBarButtonItemStyleDone target:self action:@selector(firstDelete)];
//    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"二替换" style:UIBarButtonItemStyleDone target:self action:@selector(secondsReplace)];
//    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithTitle:@"二添加" style:UIBarButtonItemStyleDone target:self action:@selector(secondsAdd)];
//    UIBarButtonItem *item5 = [[UIBarButtonItem alloc] initWithTitle:@"二删除" style:UIBarButtonItemStyleDone target:self action:@selector(secondsDelete)];
//    self.navigationItem.rightBarButtonItems = @[item2, item1, item3, item4, item5];
    
    self.shareSections = [NSMutableArray array];
    {
        FMLayoutFixedAddSection *section = [FMLayoutFixedAddSection sectionWithSectionInset:UIEdgeInsetsMake(15, 15, 15, 15) itemSpace:10 lineSpace:10 column:2];

        section.header = [FMSupplementaryHeader supplementaryHeight:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.bottomMargin = 10;
        section.header.type = FMSupplementaryTypeSuspension;
        section.header.inset = UIEdgeInsetsMake(0, -15, 0, -15);

        section.footer = [FMSupplementaryFooter supplementaryHeight:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;

        section.itemSize = CGSizeMake(100, 100);
        section.itemDatas = [@[@"1", @"2", @"3"] mutableCopy];
        section.cellElement = [FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]];
        [self.shareSections addObject:section];
        self.firstSection = section;
    }
    
    {
        FMLayoutLabelSection *section = [FMLayoutLabelSection sectionWithSectionInset:UIEdgeInsetsMake(0, 10, 0, 10) itemSpace:10 lineSpace:10 column:3];
        
        section.header = [FMSupplementaryHeader supplementaryHeight:30 viewClass:[FMCollectionCustomDecoration class]];
        section.header.zIndex = FMSupplementaryZIndexFrontOfItem;
        section.header.type = FMSupplementaryTypeFixed;
        section.header.bottomMargin = 10;
        
        section.isSingleLineCanScroll = YES;
        section.maxLine = 6;
        section.cellFixedHeight = 40;
        [section setWidthBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
            return item * 20 + 100;
        }];
        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", ] mutableCopy];
        section.cellElement = [FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]];
        [self.shareSections addObject:section];
    }
    
//    {
//        FMLayoutSingleDynamicAddSection *section = [FMLayoutSingleDynamicAddSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:10 lineSpace:10 column:3];
//
//        section.header = [FMSupplementaryHeader supplementaryHeight:150 viewClass:[FMCollectionCustomDecoration class]];
//        section.header.zIndex = FMSupplementaryZIndexFrontOfItem;
//        section.header.type = FMSupplementaryTypeFixed;
//        section.header.bottomMargin = 10;
//
//        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", ] mutableCopy];
//        section.cellElement = [FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]];
//        section.cellFixedWidth = 100;
//        [section setHeightBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
//            return 100 + (item % 3) * 20;
//        }];
//        [self.shareSections addObject:section];
//        self.secondSection = section;
//    }
    
    {
        FMLayoutSingleDynamicSection *section = [FMLayoutSingleDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(5, 15, 5, 15) itemSpace:10 lineSpace:10 column:2];
        
        section.cellFixedWidth = 166;
        section.autoHeightFixedWidth = YES;
        section.itemDatas = [@[@1, @1, @1, @1, @1, @1] mutableCopy];
        section.cellElement = [FMCollectionViewElement elementWithViewClass:[LS_HomeActivityCell class]];
        [section setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
            if (item == 0) {
                ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少肯德基分离式的";
            }
            if (item == 1) {
                ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少肯德基分离式的\n爱神的箭埃里克森基多拉\n离开时尽量少肯德基分离式的";
            }
            if (item == 2) {
                ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述";
            }
            if (item == 3) {
                ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的";
            }
        }];
        [self.shareSections addObject:section];
    }
    
    FMCollectionLayoutView *view = [[FMCollectionLayoutView alloc] init];
    view.configuration = self;
    view.delegate = self;
    [view.layout setSections:self.shareSections];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.collectionView = view;
}

@end
