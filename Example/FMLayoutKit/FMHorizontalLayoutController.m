//
//  FMHorizontalLayoutController.m
//  FMLayoutKit_Example
//
//  Created by 周发明 on 2020/6/15.
//  Copyright © 2020 zhoufaming251@163.com. All rights reserved.
//

#import "FMHorizontalLayoutController.h"
#import <FMLayoutKit/FMLayoutkit.h>
#import <Masonry/Masonry.h>
#import "LS_HomeActivityCell.h"

#import "FMCollectionCustomDecoration.h"
#import "FMCollectionCustomCell.h"
#import "FMCollectionNavTitleView.h"

#import "FMViewController.h"

#import "FMFPSLabel.h"

@interface FMHorizontalLayoutController ()<UICollectionViewDelegate>
@property(nonatomic, strong)NSMutableArray<FMLayoutBaseSection *> *shareSections;
@property(nonatomic, weak)FMLayoutView  *collectionView;

@property(nonatomic, strong)NSMutableDictionary *fillSizeData;

@end

@implementation FMHorizontalLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"横向布局";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换" style:UIBarButtonItemStyleDone target:self action:@selector(changeLayoutDirection)];
    self.shareSections = [NSMutableArray array];
    self.fillSizeData = [NSMutableDictionary dictionary];
//    FMLayoutCloseLog()
    
    __weak typeof(self) weakSelf = self;
    {
        FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:10 lineSpace:10 column:2];

        section.header = [FMLayoutHeader elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
        section.header.type = FMLayoutHeaderTypeSuspensionAlways;
        section.header.zIndex = FMLayoutZIndexFrontAlways;
        section.header.isStickTop = YES;
//        section.header.inset = UIEdgeInsetsMake(0, -15, 0, -15);
        [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
            FMCollectionCustomDecoration *custom = (FMCollectionCustomDecoration *)header;
            custom.textLabel.text = @"第一个悬浮的顶部视图, 黏在顶部";
        }];


        section.footer = [FMLayoutFooter elementSize:100 viewClass:[FMCollectionCustomDecoration class]];
//        section.footer.inset = UIEdgeInsetsMake(10, 0, 10, 0);
        section.footer.topMargin = 10;

        section.background = [FMLayoutBackground bgWithViewClass:[UICollectionReusableView class]];
        section.background.inset = UIEdgeInsetsMake(10, 10, 10, 10);
        [section setConfigureBg:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull bg) {
            bg.backgroundColor = [UIColor yellowColor];
        }];
        FMLayoutCrossSection *hSection = [FMLayoutCrossSection sectionAutoWithSection:section];
        hSection.autoMaxSize = NO;
        hSection.size = 300;
//        [self.shareSections addObject:hSection];
    }
    
    {
        FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsZero itemSpace:10 lineSpace:10 column:3];

        section.header = [FMLayoutHeader elementSize:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.lastMargin = 10;
        section.header.type = FMLayoutHeaderTypeSuspensionAlways;
        section.header.zIndex = FMLayoutZIndexFrontAlways;
        section.header.isStickTop = NO;
//        section.header.suspensionTopMargin = 50;
//        section.header.inset = UIEdgeInsetsMake(0, -15, 0, -15);
        
        section.footer = [FMLayoutFooter elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;

//        section.isHorizontalCanScroll = YES;
        section.itemSize = CGSizeMake(150, 100);
        section.itemDatas = [@[@"1", @"2", @"3", @"2", @"3", @"2", @"3", @"2", @"3", @"2", @"3"] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
        [section setClickCellBlock:^(FMLayoutBaseSection * _Nonnull section, NSInteger item) {
            FMViewController *vc = [[FMViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
        FMLayoutCrossSection *hSection = [FMLayoutCrossSection sectionAutoWithSection:section];
        hSection.header = [FMLayoutHeader elementSize:100 viewClass:[FMCollectionCustomDecoration class]];
        [hSection setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
            FMCollectionCustomDecoration *custom = (FMCollectionCustomDecoration *)header;
            custom.textLabel.text = @"FMLayoutFixedSection";
        }];
//        [self.shareSections addObject:hSection];
    }
//    
    {
        FMLayoutLabelSection *section = [FMLayoutLabelSection sectionWithSectionInset:UIEdgeInsetsMake(0, 10, 0, 10) itemSpace:10 lineSpace:10 column:3];

        section.header = [FMLayoutHeader elementSize:30 viewClass:[FMCollectionCustomDecoration class]];
        section.header.zIndex = FMLayoutZIndexFrontOfItem;
        section.header.type = FMLayoutHeaderTypeFixed;
        section.header.lastMargin = 10;

//        section.isSingleLineCanScroll = YES;
        section.maxLine = 1;
        section.cellFixedHeight = 40;
        [section setWidthBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
            return item * 20 + 100;
        }];
        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", ] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
        
        FMLayoutCrossSection *hSection = [FMLayoutCrossSection sectionAutoWithSection:section];
        hSection.header = [FMLayoutHeader elementSize:100 viewClass:[FMCollectionCustomDecoration class]];
        [hSection setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
            FMCollectionCustomDecoration *custom = (FMCollectionCustomDecoration *)header;
            custom.textLabel.text = @"FMLayoutLabelSection";
        }];
//        [self.shareSections addObject:hSection];
//        [self.shareSections addObject:section];
    }
    
//    {
//        FMLayoutSingleDynamicAddSection *section = [FMLayoutSingleDynamicAddSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:10 lineSpace:10 column:3];
//
//        section.header = [FMLayoutHeader elementSize:150 viewClass:[FMCollectionCustomDecoration class]];
//        section.header.zIndex = FMLayoutZIndexFrontOfItem;
//        section.header.type = FMLayoutHeaderTypeFixed;
//        section.header.lastMargin = 10;
//
//        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", ] mutableCopy];
//        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
//        section.cellFixedSize = 100;
//        [section setHeightBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
//            return 100 + (item % 3) * 20;
//        }];
//        [self.shareSections addObject:section];
//        self.secondSection = section;
//    }
    
//    {
//        FMLayoutSingleDynamicAddSection *section = [FMLayoutSingleDynamicAddSection sectionWithSectionInset:UIEdgeInsetsMake(5, 15, 5, 15) itemSpace:10 lineSpace:10 column:2];
//
//        section.cellFixedSize = 166;
//        section.autoHeightFixedWidth = YES;
//        section.itemDatas = [@[@1, @1, @1, @1, @1, @1] mutableCopy];
//        section.cellElement = [FMLayoutElement elementWithViewClass:[LS_HomeActivityCell class]];
//        __weak typeof(self) weakSelf = self;
//        [section setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
//            if (item == 0) {
//                ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少肯德基分离式的";
//                return;
//            }
//            if (item == 1) {
//                ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少肯德基分离式的\n爱神的箭埃里克森基多拉\n离开时尽量少肯德基分离式的";
//                return;
//            }
//            if (item == 2) {
//                ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述";
//                return;
//            }
//            if (item == 3) {
//                ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的";
//                return;
//            }
//            ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少";
//        }];
//        [self.shareSections addObject:section];
//    }
    
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
        FMLayoutCrossSection *hSection = [FMLayoutCrossSection sectionAutoWithSection:section];
        hSection.header = [FMLayoutHeader elementSize:100 viewClass:[FMCollectionCustomDecoration class]];
        [hSection setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
            FMCollectionCustomDecoration *custom = (FMCollectionCustomDecoration *)header;
            custom.textLabel.text = @"FMLayoutAbsoluteSection";
        }];
//        [self.shareSections addObject:hSection];
//        [self.shareSections addObject:section];
    }
    
//    {
//        FMLayoutAbsoluteSection *section = [FMLayoutAbsoluteSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:0 lineSpace:0 column:0];
//
//        section.itemDatas = [@[@"1", @"2", @"3"] mutableCopy];
//        section.cellElements = @[[FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]]];
//        [section setDeqCellReturnReuseId:^NSString * _Nonnull(FMLayoutDynamicSection * _Nonnull section, NSInteger index) {
//            return [section.cellElements firstObject].reuseIdentifier;
//        }];
//        [section setFrameBlock:^CGRect(id  _Nonnull section, NSInteger item) {
//            switch (item) {
//                case 0:
//                    return CGRectMake(0, 0, 100, 100);
//                case 1:
//                    return CGRectMake(200, 100, 150, 100);
//                case 2:
//                    return CGRectMake(100, 400, 400, 90);
//                default:
//                    return CGRectZero;
//                    break;
//            }
//        }];
//        [self.shareSections addObject:section];
//    }
    
    {
            FMLayoutFillSection *section = [[FMLayoutFillSection alloc] init];
            

            section.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);

            section.header = [FMLayoutHeader elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
            section.header.suspensionTopMargin = 0;
//            section.header.zIndex = FMLayoutZIndexFrontAlways;
//            section.header.type = FMLayoutHeaderTypeSuspensionAlways;
            [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
                FMCollectionCustomDecoration *customHeader = (FMCollectionCustomDecoration *)header;
                customHeader.textLabel.text = @"填充布局,寻找合适的空档,支持多种cell, header样式一直悬停在顶部";
            }];

        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
            section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"3", @"1", @"2", @"3",] mutableCopy];
            [section setSizeBlock:^CGSize(id  _Nonnull section, NSInteger item) {
                switch (item) {
                    case 2:
                        return CGSizeMake(150, 140);
                    case 5:
                        return CGSizeMake((weakSelf.view.frame.size.width-20-150)/2, 70);
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
                        return CGSizeMake((weakSelf.view.frame.size.width-20-150)/4, 70);
                    default:
//                    {
//                        NSValue *value = weakSelf.fillSizeData[@(item)];
//                        if (value == nil) {
//                            value = [NSValue valueWithCGSize:CGSizeMake(FMLayoutRandomValue(100, 300), FMLayoutRandomValue(50, 200))];
//                            weakSelf.fillSizeData[@(item)] = value;
//                        }
//                        return [value CGSizeValue];
//                    }
                        return CGSizeMake((weakSelf.view.frame.size.width-20-150)/4, 70);
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
        
//        FMLayoutCrossSection *hSection = [FMLayoutCrossSection sectionAutoWithSection:section];
//        hSection.autoMaxSize = NO;
//        hSection.height = 500;
//        hSection.header = [FMLayoutHeader elementSize:100 viewClass:[FMCollectionCustomDecoration class]];
//        [hSection setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
//            FMCollectionCustomDecoration *custom = (FMCollectionCustomDecoration *)header;
//            custom.textLabel.text = @"FMLayoutFillSection";
//        }];
//        [self.shareSections addObject:hSection];
        
//            [self.shareSections addObject:section];
        }
    
    {
        FMLayoutCrossSection *sections = [FMLayoutCrossSection sectionWithSectionInset:UIEdgeInsetsMake(10, 10, 10, 10) itemSpace:0 lineSpace:0 column:1];
        sections.header = [FMLayoutHeader elementSize:100 viewClass:[FMCollectionCustomDecoration class]];
        sections.header.lastMargin = 10;
//        sections.size = 400;
        sections.autoMaxSize = YES;
        
        {
//                {
//                        FMLayoutFillSection *section = [[FMLayoutFillSection alloc] init];
//                        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3",] mutableCopy];
//
//                        section.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//
//                        section.header = [FMLayoutHeader elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
//                        section.header.suspensionTopMargin = 0;
//                        section.header.zIndex = FMLayoutZIndexFrontAlways;
//                        section.header.type = FMLayoutHeaderTypeSuspensionAlways;
//                        [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
//                            FMCollectionCustomDecoration *customHeader = (FMCollectionCustomDecoration *)header;
//                            customHeader.textLabel.text = @"填充布局,寻找合适的空档,支持多种cell, header样式一直悬停在顶部";
//                        }];
//
//                        section.cellElements = @[[FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]]];
//                        [section setDeqCellReturnReuseId:^NSString * _Nonnull(FMLayoutDynamicSection * _Nonnull section, NSInteger index) {
//                            return [section.cellElements firstObject].reuseIdentifier;
//                        }];
//                        [section setSizeBlock:^CGSize(id  _Nonnull section, NSInteger item) {
//                            switch (item) {
//                                case 2:
//                                    return CGSizeMake(150, 140.32);
//                                case 5:
//                                    return CGSizeMake((weakSelf.view.frame.size.width-20-150)/2, 70.19);
//                                case 8:
//                                case 11:
//                                    return CGSizeMake(100, 240);
//                                case 10:
//                                    return CGSizeMake(weakSelf.view.frame.size.width-20-200, 140);
//                                case 9:
//                                case 12:
//                                    return CGSizeMake(weakSelf.view.frame.size.width-20-100, 100);
//                                case 0:
//                                case 1:
//                                case 3:
//                                case 4:
//                                    return CGSizeMake((weakSelf.view.frame.size.width-20-150)/4, 70.13);
//                                default:
//                                    return CGSizeMake((weakSelf.view.frame.size.width-20-150)/4, 70.19);
//                            }
//                        }];
//                //        [section setConfigureCellLayoutAttributes:^(id  _Nonnull section, UICollectionViewLayoutAttributes * _Nonnull attributes, NSInteger item) {
//                //            if (item == 10) {
//                //                attributes.transform = CGAffineTransformMakeRotation(M_PI_4);
//                //            }
//                //        }];
//                        [section setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
//                            FMCollectionCustomCell *customCell = (FMCollectionCustomCell *)cell;
//                            customCell.label.text = [NSString stringWithFormat:@"%ld", item];
//                        }];
//                        [sections.sections addObject:section];
//                    }
            
                {
                    FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsZero itemSpace:10 lineSpace:10 column:3];

                    section.header = [FMLayoutHeader elementSize:100 viewClass:[FMCollectionCustomDecoration class]];
                    section.header.lastMargin = 10;
                    section.header.type = FMLayoutHeaderTypeSuspensionBigger;
                    section.header.zIndex = FMLayoutZIndexFrontAlways;
                    section.header.minSize = 50;
                    section.header.maxSize = 200;
                    section.header.isStickTop = YES;
            //        section.header.suspensionTopMargin = 50;
            //        section.header.inset = UIEdgeInsetsMake(0, -15, 0, -15);
                    [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
                        FMCollectionCustomDecoration *custom = (FMCollectionCustomDecoration *)header;
                        custom.textLabel.text = @"第二个悬浮的顶部视图, 不黏在顶部";
                    }];

//                    section.footer = [FMLayoutFooter elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
//                    section.footer.topMargin = 10;

            //        section.isHorizontalCanScroll = YES;
                    section.itemSize = CGSizeMake(150, 100);
                    section.itemDatas = [@[@"1", @"2", @"3", @"2", @"3", @"2", @"3", @"2", @"3", @"2", @"3", @"2", @"3", @"2", @"3", @"2", @"3", @"2", @"3", @"2", @"3"] mutableCopy];
                    section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
                    [section setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
                        FMCollectionCustomCell *custom = (FMCollectionCustomCell *)cell;
                        custom.label.text = [NSString stringWithFormat:@"%ld", (long)item];
                    }];
                    [section setClickCellBlock:^(FMLayoutBaseSection * _Nonnull section, NSInteger item) {

                    }];
//                    [sections.sections addObject:section];
                    [self.shareSections addObject:section];
                }
//            
//            {
//                    FMLayoutLabelSection *section = [FMLayoutLabelSection sectionWithSectionInset:UIEdgeInsetsMake(0, 10, 0, 10) itemSpace:10 lineSpace:10 column:3];
//
//                    section.header = [FMLayoutHeader elementSize:30 viewClass:[FMCollectionCustomDecoration class]];
//                    section.header.zIndex = FMLayoutZIndexFrontOfItem;
//                    section.header.type = FMLayoutHeaderTypeFixed;
//                    section.header.lastMargin = 10;
//                
////                    section.maxLine = 1;
//                    section.cellFixedHeight = 40;
//                    [section setWidthBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
//                        return item * 20 + 100;
//                    }];
//                    section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", ] mutableCopy];
//                    section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
//                    [sections.sections addObject:section];
//                }
//                {
//                    FMLayoutAbsoluteSection *section = [FMLayoutAbsoluteSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:0 lineSpace:0 column:0];
//
//                    section.itemDatas = [@[@"1", @"2", @"3"] mutableCopy];
//                    section.cellElements = @[[FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]]];
//                    [section setDeqCellReturnReuseId:^NSString * _Nonnull(FMLayoutDynamicSection * _Nonnull section, NSInteger index) {
//                        return [section.cellElements firstObject].reuseIdentifier;
//                    }];
//                    [section setFrameBlock:^CGRect(id  _Nonnull section, NSInteger item) {
//                        switch (item) {
//                            case 0:
//                                return CGRectMake(0, 0, 100, 100);
//                            case 1:
//                                return CGRectMake(200, 100, 150, 100);
//                            case 2:
//                                return CGRectMake(100, 400, 400, 90);
//                            default:
//                                return CGRectZero;
//                                break;
//                        }
//                    }];
//                    [sections.sections addObject:section];
//                }
            
//            {
//                    FMLayoutLabelSection *section = [FMLayoutLabelSection sectionWithSectionInset:UIEdgeInsetsMake(0, 10, 0, 10) itemSpace:10 lineSpace:10 column:3];
//
//                    section.header = [FMLayoutHeader elementSize:30 viewClass:[FMCollectionCustomDecoration class]];
//                    section.header.zIndex = FMLayoutZIndexFrontOfItem;
//                    section.header.type = FMLayoutHeaderTypeFixed;
//                    section.header.lastMargin = 10;
//
//            //        section.isSingleLineCanScroll = YES;
//                    section.maxLine = 1;
//                    section.cellFixedHeight = 40;
//                    [section setWidthBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
//                        return item * 20 + 100;
//                    }];
//                    section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", ] mutableCopy];
//                    section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
//                    [sections.sections addObject:section];
//                }
            
        }
        
//        [self.shareSections addObject:sections];
    }
    
    
    FMLayoutView *view = [[FMLayoutView alloc] initHorizontal];
    self.automaticallyAdjustsScrollViewInsets = NO;
    view.delegate = self;
//    view.alwaysBounceVertical = YES;
    [view.layout setSections:self.shareSections];
//    view.layout.minContentSize = 1000;
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(100);
    }];
    self.collectionView = view;
}

- (void)changeLayoutDirection{
    self.collectionView.layout.direction = self.collectionView.layout.direction == FMLayoutDirectionVertical ? FMLayoutDirectionHorizontal : FMLayoutDirectionVertical;
    [self.collectionView reloadChangedSectionsData];
    if (self.collectionView.layout.direction == FMLayoutDirectionVertical) {
        self.collectionView.alwaysBounceVertical = YES;
        self.collectionView.alwaysBounceHorizontal = NO;
    } else {
        self.collectionView.alwaysBounceVertical = NO;
        self.collectionView.alwaysBounceHorizontal = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /*
     <FMCollectionLayoutAttributes: 0x1054337f0> index path: (<NSIndexPath: 0xc2f905ad00943923> {length = 2, path = 0 - 0}); frame = (10 10; 61 70); ,
     <FMCollectionLayoutAttributes: 0x105439040> index path: (<NSIndexPath: 0xc2f905ad00b43923> {length = 2, path = 0 - 1}); frame = (71 10; 61 70); ,
     <FMCollectionLayoutAttributes: 0x105439180> index path: (<NSIndexPath: 0xc2f905ad00d43923> {length = 2, path = 0 - 2}); frame = (132 10; 150 140); ,
     <FMCollectionLayoutAttributes: 0x1054393d0> index path: (<NSIndexPath: 0xc2f905ad00f43923> {length = 2, path = 0 - 3}); frame = (282 10; 61 70); ,
     <FMCollectionLayoutAttributes: 0x105439510> index path: (<NSIndexPath: 0xc2f905ad00143923> {length = 2, path = 0 - 4}); frame = (343 10; 61 70); ,
     <FMCollectionLayoutAttributes: 0x105439650> index path: (<NSIndexPath: 0xc2f905ad00343923> {length = 2, path = 0 - 5}); frame = (10 80; 122 70); ,
     <FMCollectionLayoutAttributes: 0x105439790> index path: (<NSIndexPath: 0xc2f905ad00543923> {length = 2, path = 0 - 6}); frame = (282 80; 61 70); ,
     <FMCollectionLayoutAttributes: 0x1054398d0> index path: (<NSIndexPath: 0xc2f905ad00743923> {length = 2, path = 0 - 7}); frame = (343 80; 61 70); ,
     <FMCollectionLayoutAttributes: 0x105439a10> index path: (<NSIndexPath: 0xc2f905ad01943923> {length = 2, path = 0 - 8}); frame = (10 150; 100 240); ,
     <FMCollectionLayoutAttributes: 0x105439b50> index path: (<NSIndexPath: 0xc2f905ad01b43923> {length = 2, path = 0 - 9}); frame = (110 150; 294 100); ,
     <FMCollectionLayoutAttributes: 0x105439c90> index path: (<NSIndexPath: 0xc2f905ad01d43923> {length = 2, path = 0 - 10}); frame = (110 250; 194 140); ,
     <FMCollectionLayoutAttributes: 0x105439dd0> index path: (<NSIndexPath: 0xc2f905ad01f43923> {length = 2, path = 0 - 11}); frame = (304 250; 100 240); ,
     <FMCollectionLayoutAttributes: 0x105439f10> index path: (<NSIndexPath: 0xc2f905ad01143923> {length = 2, path = 0 - 12}); frame = (10 390; 294 100); ,
     <FMCollectionLayoutAttributes: 0x10543a050> index path: (<NSIndexPath: 0xc2f905ad01343923> {length = 2, path = 0 - 13}); frame = (10 490; 61 70); ,
     <FMCollectionLayoutAttributes: 0x10543a190> index path: (<NSIndexPath: 0xc2f905ad01543923> {length = 2, path = 0 - 14}); frame = (71 490; 61 70); ,
     <FMCollectionLayoutAttributes: 0x10543a2d0> index path: (<NSIndexPath: 0xc2f905ad01743923> {length = 2, path = 0 - 15}); frame = (132 490; 61 70); ,
     <FMCollectionLayoutAttributes: 0x10543a410> index path: (<NSIndexPath: 0xc2f905ad02943923> {length = 2, path = 0 - 16}); frame = (193 490; 61 70); ,
     <FMCollectionLayoutAttributes: 0x10543a550> index path: (<NSIndexPath: 0xc2f905ad02b43923> {length = 2, path = 0 - 17}); frame = (254 490; 61 70); ,
     <FMCollectionLayoutAttributes: 0x10543a690> index path: (<NSIndexPath: 0xc2f905ad02d43923> {length = 2, path = 0 - 18}); frame = (315 490; 61 70);
     */
}

@end
