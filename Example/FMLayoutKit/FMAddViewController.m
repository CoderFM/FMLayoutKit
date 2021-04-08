//
//  FMAddViewController.m
//  FMCollectionLayout_Example
//
//  Created by 周发明 on 2020/4/17.
//  Copyright © 2020 周发明. All rights reserved.
//

#import "FMAddViewController.h"
#import <FMLayoutKit/FMLayoutkit.h>
#import <Masonry/Masonry.h>
#import "LS_HomeActivityCell.h"

#import "FMCollectionCustomDecoration.h"
#import "FMCollectionCustomCell.h"
#import "FMCollectionNavTitleView.h"

#import "FMHorizontalLayoutController.h"

#import "FMAotuSizeReusableView.h"

@interface FMAddViewController ()<UICollectionViewDelegate>

@property(nonatomic, strong)NSMutableArray<FMLayoutBaseSection *> *shareSections;
@property(nonatomic, weak)FMLayoutView  *collectionView;


@property(nonatomic, weak)FMLayoutBaseSection *firstSection;
@property(nonatomic, weak)FMLayoutDynamicSection *secondSection;

@property(nonatomic, assign)BOOL twoChangeed;

@end

@implementation FMAddViewController

- (void)firstAdd{
    [self.firstSection.itemDatas addObjectsFromArray:@[@"1", @"2", @"3", @"4"]];
//    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
//    [self.collectionView.layout.sections exchangeObjectAtIndex:1 withObjectAtIndex:2];
//    [self.collectionView moveSection:1 toSection:2];
    [self.collectionView reloadChangedSectionsData];
}
- (void)firstDelete{
//    [self.firstSection.itemDatas removeLastObject];
//    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
//    [self.collectionView reloadData];
}
- (void)secondsReplace{
    self.twoChangeed = !self.twoChangeed;
    [self.secondSection markChangeAt:3];
//    [self.secondSection.itemDatas replaceObjectAtIndex:2 withObject:@"2"];
    [self.collectionView reloadChangedSectionsData];
}
- (void)secondsAdd{
    [self.secondSection.itemDatas addObjectsFromArray:@[@"1", @"2", @"3", @"4"]];
    [self.collectionView reloadChangedSectionsData];
}
- (void)secondsDelete{
    [self.secondSection.itemDatas removeLastObject];
    [self.collectionView reloadChangedSectionsData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"追加数据测试";
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"一添加" style:UIBarButtonItemStyleDone target:self action:@selector(firstAdd)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"一删除" style:UIBarButtonItemStyleDone target:self action:@selector(firstDelete)];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"二替换" style:UIBarButtonItemStyleDone target:self action:@selector(secondsReplace)];
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithTitle:@"二添加" style:UIBarButtonItemStyleDone target:self action:@selector(secondsAdd)];
    UIBarButtonItem *item5 = [[UIBarButtonItem alloc] initWithTitle:@"二删除" style:UIBarButtonItemStyleDone target:self action:@selector(secondsDelete)];
    self.navigationItem.rightBarButtonItems = @[item2, item1, item3, item4, item5];
    
    self.shareSections = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    {
        FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsMake(0, 15, 0, 15) itemSpace:10 lineSpace:10 column:2];

//        section.header = [FMLayoutHeader elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
        section.header = [FMLayoutHeader elementSize:0 viewClass:[FMAotuSizeReusableView class]];
        section.header.autoHeight = YES;
//        section.header.type = FMLayoutHeaderTypeSuspensionAlways;
//        section.header.zIndex = FMLayoutZIndexFrontAlways;
//        section.header.isStickTop = YES;
        section.header.inset = UIEdgeInsetsMake(0, -15, 0, -15);
        [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
            [(FMAotuSizeReusableView *)header contentLabel].text = @"按实际大街上肯德基哈克斯就打回修改后\n1\n2\n3\n4\n阿拉山口基多拉科技的拉升科技大理石科技大流口水基多拉考试记录";
        }];
//        [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
//            FMCollectionCustomDecoration *custom = (FMCollectionCustomDecoration *)header;
//            custom.textLabel.text = @"第一个悬浮的顶部视图, 黏在顶部";
//        }];
        [self.shareSections addObject:section];
    }
    {
            FMLayoutFillSection *section = [[FMLayoutFillSection alloc] init];
            section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3",] mutableCopy];
            section.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//        section.lineSpace = 10;
//        section.itemSpace = 10;
            section.header = [FMLayoutHeader elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
    //        section.header.suspensionTopMargin = 150;
            section.header.zIndex = FMLayoutZIndexFrontAlways;
            section.header.type = FMLayoutHeaderTypeSuspensionAlways;
            [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
                FMCollectionCustomDecoration *customHeader = (FMCollectionCustomDecoration *)header;
                customHeader.textLabel.text = @"填充布局,寻找合适的空档,支持多种cell, header样式一直悬停在顶部";
            }];

            section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
   
            [section setSizeBlock:^CGSize(id  _Nonnull section, NSInteger item) {
                switch (item) {
                    case 2:
                        return CGSizeMake(150, 140.32);
                    case 5:
                        return CGSizeMake((weakSelf.view.frame.size.width-20-150)/2, 70.19);
                    case 8:
                    case 11:
                        return CGSizeMake(100, 240);
                    case 10:
                        return CGSizeMake(weakSelf.view.frame.size.width-20-200, 140);
                    case 9:
                    case 12:
                        return CGSizeMake(weakSelf.view.frame.size.width-20-100, 100);
                    case 0:
                    case 1:
                    case 3:
                    case 4:
                        return CGSizeMake((weakSelf.view.frame.size.width-20-150)/4, 70.13);
                    default:
                        return CGSizeMake((weakSelf.view.frame.size.width-20-150)/4, 70.19);
                }
            }];
    //        [section setConfigureCellLayoutAttributes:^(id  _Nonnull section, UICollectionViewLayoutAttributes * _Nonnull attributes, NSInteger item) {
    //            if (item == 10) {
    //                attributes.transform = CGAffineTransformMakeRotation(M_PI_4);
    //            }
    //        }];
            [section setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
                FMCollectionCustomCell *customCell = (FMCollectionCustomCell *)cell;
                customCell.label.text = [NSString stringWithFormat:@"%ld", item];
            }];
            [self.shareSections addObject:section];
        self.firstSection = section;
        }
    {
        FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsMake(0, 15, 15, 15) itemSpace:10 lineSpace:10 column:2];

        section.header = [FMLayoutHeader elementSize:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.lastMargin = 10;
        section.header.type = FMLayoutHeaderTypeSuspensionAlways;
        section.header.zIndex = FMLayoutZIndexFrontAlways;
        section.header.isStickTop = NO;
        section.header.suspensionTopMargin = 50;
        section.header.inset = UIEdgeInsetsMake(0, -15, 0, -15);
        [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
            FMCollectionCustomDecoration *custom = (FMCollectionCustomDecoration *)header;
            custom.textLabel.text = @"第二个悬浮的顶部视图, 不黏在顶部";
        }];

        section.footer = [FMLayoutFooter elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;

        section.itemSize = CGSizeMake(100, 100);
        section.itemDatas = [@[@"1", @"2", @"3"] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
        [section setClickCellBlock:^(FMLayoutBaseSection * _Nonnull section, NSInteger item) {
            FMHorizontalLayoutController *vc = [[FMHorizontalLayoutController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        [self.shareSections addObject:section];
//        self.firstSection = section;
    }
    
    {
        
        
        FMLayoutLabelSection *section = [FMLayoutLabelSection sectionWithSectionInset:UIEdgeInsetsMake(0, 10, 0, 10) itemSpace:10 lineSpace:10 column:3];
        
        section.header = [FMLayoutHeader elementSize:30 viewClass:[FMCollectionCustomDecoration class]];
        section.header.zIndex = FMLayoutZIndexFrontOfItem;
        section.header.type = FMLayoutHeaderTypeFixed;
        section.header.lastMargin = 10;
        
//        section.isSingleLineCanScroll = YES;
        section.maxLine = 2;
        section.cellFixedHeight = 40;
        [section setWidthBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
            return item * 20 + 100;
        }];
        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", ] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
        
//        FMLayoutCrossSection *hSection = [FMLayoutCrossSection sectionAutoWithSection:section];
        [self.shareSections addObject:section];
        
//        self.firstSection = section;
    }
    
    {
        FMLayoutDynamicSection *section = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(5, 15, 5, 15) itemSpace:10 lineSpace:10 column:2];
        
        section.cellFixedSize = 166;
        section.autoHeightFixedWidth = YES;
        section.itemDatas = [@[@1, @1, @1, @1, @1, @1] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[LS_HomeActivityCell class]];
        __weak typeof(self) weakSelf = self;
        [section setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
            if (item == 0) {
                ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少肯德基分离式的";
                return;
            }
            if (item == 1) {
                ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少肯德基分离式的\n爱神的箭埃里克森基多拉\n离开时尽量少肯德基分离式的";
                return;
            }
            if (item == 2) {
                ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述";
                return;
            }
            if (item == 3) {
                if (weakSelf.twoChangeed) {
                    ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的";
                    return;
                } else {
                    ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述\n爱神的箭埃里克森基多拉\n";
                    return;
                }
            }
            ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少";
        }];
        self.secondSection = section;
        [self.shareSections addObject:section];
    }
    
    {
        FMLayoutAbsoluteSection *section = [FMLayoutAbsoluteSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:0 lineSpace:0 column:0];
        
        section.itemDatas = [@[@"1", @"2", @"3"] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
        [section setFrameBlock:^CGRect(id  _Nonnull section, NSInteger item) {
            switch (item) {
                case 0:
                    return CGRectMake(0, 0, 100, 100);
                case 1:
                    return CGRectMake(200, 100, 150, 100);
                case 2:
                    return CGRectMake(100, 400, 400, 90);
                default:
                    return CGRectZero;
                    break;
            }
        }];
        [self.shareSections addObject:section];
    }
    
    FMLayoutView *view = [[FMLayoutView alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    view.delegate = self;
    [view.layout setSections:self.shareSections];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(100);
    }];
    self.collectionView = view;
}

@end
