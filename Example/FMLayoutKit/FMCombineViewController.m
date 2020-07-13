//
//  FMCombineViewController.m
//  FMLayoutKit_Example
//
//  Created by 郑桂华 on 2020/7/12.
//  Copyright © 2020 zhoufaming251@163.com. All rights reserved.
//

#import "FMCombineViewController.h"
#import <FMLayoutKit/FMLayoutKit.h>
#import <Masonry.h>

#import "FMCollectionCustomDecoration.h"
#import "FMCollectionCustomCell.h"

@interface FMCombineViewController ()
@property(nonatomic, weak)FMLayoutView  *collectionView;
@end

@implementation FMCombineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FMLayoutView *view = [[FMLayoutView alloc] initHorizontal];
//    view.layout.minContentSize = 1000;
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(100);
    }];
    self.collectionView = view;
    [self addSections];
}

- (void)addSections{
    NSMutableArray *sections = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    {
        FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:10 lineSpace:10 column:2];

        section.itemSize = CGSizeMake(150, 100);
        section.itemDatas = [@[@"1", @"2", @"3", @"2", @"3", @"2", @"3", @"2", @"3", @"2", @"3"] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
        [section setClickCellBlock:^(FMLayoutBaseSection * _Nonnull section, NSInteger item) {
            
        }];
        [sections addObject:section];
    }
    
    {
        FMLayoutAbsoluteSection *section = [FMLayoutAbsoluteSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:0 lineSpace:0 column:0];

        section.itemDatas = [@[@"1", @"2", @"3"] mutableCopy];
        section.cellElements = @[[FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]]];
        [section setDeqCellReturnReuseId:^NSString * _Nonnull(FMLayoutDynamicSection * _Nonnull section, NSInteger index) {
            return [section.cellElements firstObject].reuseIdentifier;
        }];
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
        [section setClickCellBlock:^(FMLayoutBaseSection * _Nonnull section, NSInteger item) {
            
        }];
        [sections addObject:section];
    }
    
    FMLayoutCombineSection *section = [FMLayoutCombineSection combineSections:sections];
    
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
    
    self.collectionView.sections  = [@[section] mutableCopy];
    [self.collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
