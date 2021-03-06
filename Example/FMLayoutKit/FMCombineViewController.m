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
#import "FMAddViewController.h"
#import "FMCollectionViewCell.h"
#import "LS_HomeActivityCell.h"

@interface FMDeletePanGestureRecognizer : UIPanGestureRecognizer

@property(nonatomic, assign)BOOL isLeft;

@end

@implementation FMDeletePanGestureRecognizer

@end

@interface FMCollectionDeleteCell : UICollectionViewCell<UIGestureRecognizerDelegate>

@property(nonatomic, assign)CGFloat handleViewWidth;

@end

@implementation FMCollectionDeleteCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.handleViewWidth = 100;
        
        NSInteger aRedValue =arc4random() %255;
        NSInteger aGreenValue =arc4random() %255;
        NSInteger aBlueValue =arc4random() %255;
        UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
        self.contentView.backgroundColor = randColor;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        pan.delegate = self;
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)panGesture:(UIPanGestureRecognizer *)pan{
    CGPoint translate = [pan translationInView:self];
    NSLog(@"translate: %@", [NSValue valueWithCGPoint:translate]);
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (-translate.x < self.handleViewWidth) {
                self.transform = CGAffineTransformMakeTranslation(translate.x, 0);
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (-translate.x < self.handleViewWidth * 0.5) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.transform = CGAffineTransformIdentity;
                }];
            } else {
                [UIView animateWithDuration:0.2 animations:^{
                    self.transform = CGAffineTransformMakeTranslation(-self.handleViewWidth, 0);;
                }];
            }
        }
        default:
            break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint vel = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
    if (fabs(vel.y) < 20 && vel.x < 0) {
        return YES;
    }
    return NO;
}

@end

@interface FMCombineViewController ()
@property(nonatomic, weak)FMLayoutView  *collectionView;
@end

@implementation FMCombineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FMLayoutView *view = [[FMLayoutView alloc] init];
    //    view.layout.minContentSize = 1000;
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(100);
    }];
    self.collectionView = view;
//        [self addSections];
    [self addCrossFixedSections];
//    [self addScaleSection];
//    self.collectionView.enableLongPressDrag = YES;
//    [self.collectionView setConfigureSourceView:^UIView * _Nonnull(UICollectionViewCell * _Nonnull sourceCell) {
//        UIView *source = [[UIView alloc] initWithFrame:sourceCell.frame];
//        source.backgroundColor = [UIColor purpleColor];
//        return source;
//    }];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self.collectionView action:@selector(reloadData)];
}

- (void)addSections{
    NSMutableArray *sections = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    __weak typeof(self) weakSelf = self;
    {
        FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsMake(20, 15, 15, 15) itemSpace:10 lineSpace:10 column:2];
        section.header = [FMLayoutHeader elementSize:100 viewClass:[FMCollectionCustomDecoration class] isNib:NO reuseIdentifier:@"按实际大嫂家打卡机塑料袋卡死来得快"];
        section.header.lastMargin = 10;
        section.header.type = FMLayoutHeaderTypeSuspensionBigger;
        section.header.minSize = 50;
        section.header.isStickTop = YES;
        section.header.inset = UIEdgeInsetsMake(0, -15, 0, -15);
        [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
            FMCollectionCustomDecoration *customHeader = (FMCollectionCustomDecoration *)header;
            customHeader.textLabel.text = @"固定大小, 从左往右从上往下排的分组, 头部放大缩放效果";
        }];
        
        section.footer = [FMLayoutFooter elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;
        
        section.itemSize = CGSizeMake(200, 100);
        section.itemDatas = [@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionViewCell class] isNib:YES];
        [section setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
            [(FMCollectionViewCell *)cell label].text = section.itemDatas[item];
        }];
        
        [section setClickCellBlock:^(FMLayoutBaseSection * _Nonnull section, NSInteger item) {
            FMAddViewController *add = [[FMAddViewController alloc] init];
            [weakSelf.navigationController pushViewController:add animated:YES];
        }];
        
        section.canLongPressExchange = YES;
        [sections addObject:section];
    }
    {
        NSMutableArray *subSections = [NSMutableArray array];
        {
            FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:10 lineSpace:10 column:2];
            
            section.itemSize = CGSizeMake(150, 100);
            section.itemDatas = [@[@"0-1", @"0-2", @"0-3", @"0-4", @"0-5", @"0-6", @"0-7", @"0-8", @"0-9", @"0-10", @"0-11"] mutableCopy];
            section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
            [section setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
                [(FMCollectionCustomCell *)cell label].text = section.itemDatas[item];
            }];
            [section setClickCellBlock:^(FMLayoutBaseSection * _Nonnull section, NSInteger item) {
                
            }];
            [subSections addObject:section];
        }
        
        {
            FMLayoutAbsoluteSection *section = [FMLayoutAbsoluteSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:0 lineSpace:0 column:0];
            
            section.itemDatas = [@[@"1-1", @"1-2", @"1-3"] mutableCopy];
            section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
            [section setDeqCellReturnElement:^FMLayoutElement * _Nonnull(FMLayoutDynamicSection * _Nonnull section, NSInteger index) {
                return [section.cellElements lastObject];
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
            [section setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
                [(FMCollectionCustomCell *)cell label].text = section.itemDatas[item];
            }];
            [section setClickCellBlock:^(FMLayoutBaseSection * _Nonnull section, NSInteger item) {
                
            }];
            [subSections addObject:section];
        }
        
        FMLayoutCombineSection *section = [FMLayoutCombineSection combineSections:subSections];
        [section setCanLongPressExchangeItem:^BOOL(id  _Nonnull section, NSInteger item) {
            if (item < 2) {
                return NO;
            }
            return YES;
        }];
        section.canLongPressExchange = YES;
        section.header = [FMLayoutHeader elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
        section.header.type = FMLayoutHeaderTypeSuspensionAlways;
        section.header.zIndex = FMLayoutZIndexFrontAlways;
        //        section.header.isStickTop = YES;
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
        
        {
            FMLayoutDynamicSection *dsection = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(10, 0, 0, 0) itemSpace:0 lineSpace:10 column:1];
            
            dsection.itemDatas = [@[@"1", @"2", @"3"] mutableCopy];
            dsection.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionDeleteCell class]];
            dsection.cellFixedSize = [UIScreen mainScreen].bounds.size.width;
            [dsection setOtherBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
                return 100 + item * 100;
            }];
            [section appendSection:dsection];
        }
        
        {
            FMLayoutDynamicSection *dsection = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(10, 0, 0, 0) itemSpace:0 lineSpace:10 column:1];
            
            dsection.itemDatas = [@[@"1", @"2", @"3"] mutableCopy];
            dsection.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionDeleteCell class]];
            dsection.cellFixedSize = [UIScreen mainScreen].bounds.size.width;
            [dsection setOtherBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
                return 100 + item * 100;
            }];
            [section insetSection:dsection atIndex:1];
        }
        
        [sections addObject:section];
        
    }
    
    
    
    {
        FMLayoutDynamicSection *section = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(10, 0, 0, 0) itemSpace:0 lineSpace:10 column:1];
        section.canLongPressExchange = YES;
        section.moveType = FMLayoutLongMoveTable;
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
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionDeleteCell class]];
        section.cellFixedSize = [UIScreen mainScreen].bounds.size.width;
        [section setOtherBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
            return 100 + item * 100;
        }];

        [sections addObject:section];
    }
    
    self.collectionView.sections  = sections;
    [self.collectionView reloadData];
}

- (void)addCrossFixedSections{
    NSMutableArray *sections = [NSMutableArray array];
    
    {
        FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsMake(50, 50, 50, 50) itemSpace:20 lineSpace:0 column:1];
        section.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 100, 300);
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
        //
        section.itemDatas = [@[@"1", @"2", @"2", @"3", @"2", @"3", @"2", @"3", @"2", @"3", @"2", @"3"] mutableCopy];
        
        FMLayoutCrossTransformSection *cSection = [FMLayoutCrossTransformSection sectionAutoWithSection:section];
        cSection.transformType = FMLayoutCrossTransformScale;
        //        [cSection setTransformBlock:^(UICollectionViewCell * _Nonnull cell, CGFloat progress) {
        //            cell.la
        //        }];
        [sections addObject:cSection];
    }
    
    self.collectionView.sections  = sections;
    [self.collectionView reloadData];
}

- (void)addScaleSection{
    NSMutableArray *sections = [NSMutableArray array];
    
    {
        FMLayoutScaleSection *section = [FMLayoutScaleSection sectionWithSectionInset:UIEdgeInsetsMake(10, 10, 10, 10) itemSpace:10 lineSpace:10 column:1];
        
        section.scales = @"1:0.5";
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
        [section setOtherBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
            switch (item) {
                case 0:
                case 3:
                case 6:
                case 9:
                    return ([UIScreen mainScreen].bounds.size.width - 30) / 3.0 * 2;
                    break;
                default:
                    return (([UIScreen mainScreen].bounds.size.width - 30) / 3.0 * 2 - 10) * 0.5;
                    break;
            }
            //            return 50 + ((item % 2 == 0) ? item * 50 : item * 10);
        }];
        //
        section.itemDatas = [@[@"1", @"2", @"2", @"3", @"2", @"3", @"2", @"3", @"2", @"3", @"2", @"3"] mutableCopy];
        [section setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
            [(FMCollectionCustomCell *)cell label].text = [NSString stringWithFormat:@"%ld", item];
        }];
        
        [sections addObject:section];
    }
    
    {
        FMLayoutScaleSection *section = [FMLayoutScaleSection sectionWithSectionInset:UIEdgeInsetsMake(10, 10, 10, 10) itemSpace:10 lineSpace:10 column:1];
        
        section.sizeNums = @[@100, @200];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
//        section.cellElement = [FMLayoutElement elementWithViewClass:[LS_HomeActivityCell class]];
//        section.autoHeightFixedWidth = YES;
        [section setOtherBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
            switch (item) {
                case 0:
                case 3:
                case 6:
                case 9:
                    return ([UIScreen mainScreen].bounds.size.width - 30) / 3.0 * 2;
                    break;
                default:
                    return (([UIScreen mainScreen].bounds.size.width - 30) / 3.0 * 2 - 10) * 0.5;
                    break;
            }
//            return 50 + ((item % 2 == 0) ? item * 50 : item * 10);
        }];

        section.itemDatas = [@[@"1", @"2", @"2", @"3", @"2", @"3", @"2", @"3", @"2", @"3", @"2", @"3"] mutableCopy];
        [section setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
            [(FMCollectionCustomCell *)cell label].text = [NSString stringWithFormat:@"%ld", item];
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
//
//            }
//            ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少";
        }];
        
        [sections addObject:section];
    }
    
    self.collectionView.sections  = sections;
    [self.collectionView reloadData];
}

@end
