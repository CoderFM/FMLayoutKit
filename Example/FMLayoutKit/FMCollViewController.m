//
//  FMCollViewController.m
//  FMCollectionLayout_Example
//
//  Created by 周发明 on 2020/4/11.
//  Copyright © 2020 周发明. All rights reserved.
//

#import "FMCollViewController.h"
#import <FMLayoutKit/FMLayoutKit.h>
#import <Masonry/Masonry.h>
#import "FMAddViewController.h"

#import "FMCollectionCustomDecoration.h"
#import "FMCollectionCustomCell.h"
#import "FMCollectionNavTitleView.h"
#import "LS_HomeActivityCell.h"

#import "FMCollectionViewCell.h"

#import "FMFPSLabel.h"

@interface FMCollViewController ()<FMCollectionLayoutViewConfigurationDelegate, UICollectionViewDelegate>

@property(nonatomic, strong)NSMutableArray<FMLayoutBaseSection *> *shareSections;
@property(nonatomic, weak)FMLayoutView  *collectionView;
@end

@implementation FMCollViewController

- (void)dealloc{
    NSLog(@"FMCollViewController dealloc");
}

- (void)reloadSection{
 
    {
        FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsMake(0, 15, 15, 15) itemSpace:10 lineSpace:10 column:3];

        section.header = [FMLayoutHeader elementSize:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.lastMargin = 10;
        section.header.type = FMLayoutHeaderTypeSuspension;
        section.header.inset = UIEdgeInsetsMake(0, -15, 0, -15);

        section.footer = [FMLayoutFooter elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;

        section.itemSize = CGSizeMake(100, 100);
        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3"] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
        [self.collectionView insertLayoutSection:section atIndex:1];
    }
    [self.collectionView reloadData];
}

- (void)addItem{
    [[self.shareSections firstObject].itemDatas addObject:@"1"];
    [self.collectionView reloadData];
}

- (void)insetItem{
    [[self.shareSections firstObject].itemDatas insertObject:@"1" atIndex:0];
    [self.collectionView reloadData];
}

- (void)deleteSection{
    [self.collectionView deleteLayoutSectionAt:1];
    [self.collectionView reloadData];
}

- (void)deleteItem{
    [[self.shareSections firstObject].itemDatas removeObjectAtIndex:1];
    [self.collectionView reloadData];
}

- (void)reloadItem{
    [[self.shareSections firstObject] markChangeAt:3];
    [self.collectionView reloadData];
}

- (void)addSection{
    {
        FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsMake(0, 15, 15, 15) itemSpace:10 lineSpace:10 column:3];

        section.header = [FMLayoutHeader elementSize:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.lastMargin = 10;
        section.header.type = FMLayoutHeaderTypeSuspension;
        section.header.inset = UIEdgeInsetsMake(0, -15, 0, -15);

        section.footer = [FMLayoutFooter elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;

        section.itemSize = CGSizeMake(100, 100);
        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3"] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
        [self.shareSections addObject:section];
    }
    [self.collectionView reloadData];
}

//- (void)addItem{
//    [[self.shareSections firstObject].itemDatas removeObjectAtIndex:1];
//    [self.collectionView reloadData];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"纵向布局";
    __weak typeof(self) weakSelf = self;
    self.view.backgroundColor = [UIColor redColor];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"插组" style:UIBarButtonItemStyleDone target:self action:@selector(reloadSection)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"插单" style:UIBarButtonItemStyleDone target:self action:@selector(insetItem)];
    UIBarButtonItem *item11 = [[UIBarButtonItem alloc] initWithTitle:@"删组" style:UIBarButtonItemStyleDone target:self action:@selector(deleteSection)];
    UIBarButtonItem *item22 = [[UIBarButtonItem alloc] initWithTitle:@"删单" style:UIBarButtonItemStyleDone target:self action:@selector(deleteItem)];
    UIBarButtonItem *item111 = [[UIBarButtonItem alloc] initWithTitle:@"加组" style:UIBarButtonItemStyleDone target:self action:@selector(addSection)];
    UIBarButtonItem *item222 = [[UIBarButtonItem alloc] initWithTitle:@"加单" style:UIBarButtonItemStyleDone target:self action:@selector(addItem)];
    UIBarButtonItem *item2222 = [[UIBarButtonItem alloc] initWithTitle:@"刷单" style:UIBarButtonItemStyleDone target:self action:@selector(reloadItem)];
    self.navigationItem.rightBarButtonItems = @[item2, item1, item22, item11, item111, item222, item2222];
    
    self.shareSections = [NSMutableArray array];
    {
        FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsMake(0, 15, 15, 15) itemSpace:10 lineSpace:10 column:2];

        section.header = [FMLayoutHeader elementSize:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.lastMargin = 10;
        section.header.type = FMLayoutHeaderTypeSuspensionBigger;
        section.header.inset = UIEdgeInsetsMake(0, -15, 0, -15);
        [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
            FMCollectionCustomDecoration *customHeader = (FMCollectionCustomDecoration *)header;
            customHeader.textLabel.text = @"固定大小, 从左往右从上往下排的分组, 头部放大缩放效果";
        }];

        section.footer = [FMLayoutFooter elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;

        section.itemSize = CGSizeMake(200, 100);
        section.itemDatas = [@[@"1", @"2", @"3"] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionViewCell class] isNib:YES];
        [section setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {

        }];

        [section setClickCellBlock:^(FMLayoutBaseSection * _Nonnull section, NSInteger item) {
            FMAddViewController *add = [[FMAddViewController alloc] init];
            [weakSelf.navigationController pushViewController:add animated:YES];
        }];

        [self.shareSections addObject:section];
    }
    
    {
        FMLayoutDynamicSection *section = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(5, 15, 5, 15) itemSpace:10 lineSpace:10 column:2];

        section.header = [FMLayoutHeader elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
        section.header.zIndex = FMLayoutZIndexFrontOfItem;
        section.header.type = FMLayoutHeaderTypeFixed;
        [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
            FMCollectionCustomDecoration *customHeader = (FMCollectionCustomDecoration *)header;
            customHeader.textLabel.text = @"自动适应高度布局, 续固定宽度";
        }];

        section.cellFixedSize = 166;
        section.autoHeightFixedWidth = YES;
        section.itemDatas = [@[@1, @1, @1, @1, @1, @1] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[LS_HomeActivityCell class]];
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
                ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的";
                return;
            }
            ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述\n一些描述";
        }];
        [self.shareSections addObject:section];
    }
    
    {
        FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:10 lineSpace:10 column:3];

        section.header = [FMLayoutHeader elementSize:150 viewClass:[FMCollectionCustomDecoration class]];
        section.header.zIndex = FMLayoutZIndexFrontAlways;
        section.header.type = FMLayoutHeaderTypeSuspensionAlways;
        section.header.lastMargin = 10;
        [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
            FMCollectionCustomDecoration *customHeader = (FMCollectionCustomDecoration *)header;
            customHeader.textLabel.text = @"固定大小, 从左往右从上往下排的分组, 可横向滚动, 可设置多行, 头部悬停, 跟着分组滚动(类似table的section的plain模式)";
        }];

//        section.isHorizontalCanScroll = YES;
        section.itemSize = CGSizeMake(150, 100);
        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", ] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
        
        [section setConfigureCellLayoutAttributes:^(id  _Nonnull section, UICollectionViewLayoutAttributes * _Nonnull attributes, NSInteger item) {
            if (item == 10) {
                attributes.transform = CGAffineTransformMakeRotation(M_PI_4);
                attributes.zIndex = FMLayoutZIndexFrontOfItem;
            }
        }];
//        [self.shareSections addObject:section];
        [self.shareSections addObject:[FMLayoutCrossSection sectionAutoWithSection:section]];
    }
    
    {
        FMLayoutFillSection *section = [[FMLayoutFillSection alloc] init];
        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3",] mutableCopy];

        section.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);

        section.header = [FMLayoutHeader elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
//        section.header.suspensionTopMargin = 150;
        section.header.zIndex = FMLayoutZIndexFrontAlways;
        section.header.type = FMLayoutHeaderTypeSuspensionAlways;
        [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
            FMCollectionCustomDecoration *customHeader = (FMCollectionCustomDecoration *)header;
            customHeader.textLabel.text = @"填充布局,寻找合适的空档,支持多种cell, header样式一直悬停在顶部";
        }];

        section.cellElements = @[[FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]]];
        [section setDeqCellReturnReuseId:^NSString * _Nonnull(FMLayoutDynamicSection * _Nonnull section, NSInteger index) {
            return [section.cellElements firstObject].reuseIdentifier;
        }];
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
    }
    
    
    
    {
            FMLayoutDynamicSection *section = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(10, 0, 0, 0) itemSpace:0 lineSpace:10 column:1];

            section.header = [FMLayoutHeader elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
            section.header.zIndex = FMLayoutZIndexFrontOfItem;
            section.header.type = FMLayoutHeaderTypeFixed;
            [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
                FMCollectionCustomDecoration *customHeader = (FMCollectionCustomDecoration *)header;
                customHeader.textLabel.text = @"列表的样式, 支持多种cell, 当前手动返回计算返回高度";
            }];

            section.footer = [FMLayoutFooter elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
            section.footer.topMargin = 10;

            section.itemDatas = [@[@"1", @"2", @"3"] mutableCopy];
            section.cellElements = @[[FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]]];
            section.cellFixedSize = [UIScreen mainScreen].bounds.size.width;
            [section setOtherBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
                return 100 + item * 100;
            }];
            [section setDeqCellReturnReuseId:^NSString * _Nonnull(FMLayoutDynamicSection * _Nonnull section, NSInteger index) {
                return [section.cellElements firstObject].reuseIdentifier;
            }];

            [self.shareSections addObject:section];
        }

    {
        FMLayoutDynamicSection *section = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(10, 0, 0, 0) itemSpace:10 lineSpace:10 column:2];

        section.header = [FMLayoutHeader elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
        section.header.zIndex = FMLayoutZIndexFrontOfItem;
        section.header.type = FMLayoutHeaderTypeFixed;
        [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
            FMCollectionCustomDecoration *customHeader = (FMCollectionCustomDecoration *)header;
            customHeader.textLabel.text = @"瀑布流, 列表也就是单列, 列数可设置";
        }];

        section.footer = [FMLayoutFooter elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;

        section.itemDatas = [@[@"1", @"2", @"3", @"2", @"3", @"2", @"3"] mutableCopy];
        section.cellElements = @[[FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]]];
        section.cellFixedSize = ([UIScreen mainScreen].bounds.size.width - 10) * 0.5;
        [section setOtherBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
            return 100 + item * 30;
        }];
        [section setDeqCellReturnReuseId:^NSString * _Nonnull(FMLayoutDynamicSection * _Nonnull section, NSInteger index) {
            return [section.cellElements firstObject].reuseIdentifier;
        }];
        [self.shareSections addObject:section];
    }

    {
        FMLayoutLabelSection *section = [FMLayoutLabelSection sectionWithSectionInset:UIEdgeInsetsMake(10, 10, 10, 10) itemSpace:10 lineSpace:10 column:3];

        section.header = [FMLayoutHeader elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
        section.header.zIndex = FMLayoutZIndexFrontOfItem;
        section.header.type = FMLayoutHeaderTypeFixed;
        section.header.lastMargin = 10;
        [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
            FMCollectionCustomDecoration *customHeader = (FMCollectionCustomDecoration *)header;
            customHeader.textLabel.text = @"标签式布局, 单行横向滚动模式";
        }];

//        section.isSingleLineCanScroll = YES;
        section.maxLine = 6;
        section.cellFixedHeight = 40;
        [section setWidthBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
            return item * 20 + 100;
        }];
        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", ] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
        [self.shareSections addObject:section];
    }

    {
        FMLayoutLabelSection *section = [FMLayoutLabelSection sectionWithSectionInset:UIEdgeInsetsMake(0, 10, 0, 10) itemSpace:10 lineSpace:10 column:3];

        section.header = [FMLayoutHeader elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
        section.header.zIndex = FMLayoutZIndexFrontOfItem;
        section.header.type = FMLayoutHeaderTypeFixed;
        section.header.lastMargin = 10;
        [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
            FMCollectionCustomDecoration *customHeader = (FMCollectionCustomDecoration *)header;
            customHeader.textLabel.text = @"标签式布局, 多行模式";
        }];

        section.maxLine = 6;
        section.cellFixedHeight = 40;
        [section setWidthBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
            return item * 20 + 100;
        }];
        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", ] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
        [self.shareSections addObject:section];
    }
    
    FMLayoutView *view = [[FMLayoutView alloc] init];
    view.delegate = self;
//    view.reloadOlnyChanged = NO;
    [view.layout setSections:self.shareSections];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(100);
    }];
    self.collectionView = view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"collectionView:didSelectItemAtIndexPath");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidScroll");
}

@end
