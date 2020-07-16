//
//  FMTeslaLayoutView.h
//  FMCollectionLayout_Example
//
//  Created by 周发明 on 2020/4/8.
//  Copyright © 2020 周发明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FMLayoutView, FMTeslaLayoutView, FMLayoutBaseSection;
@protocol FMTeslaLayoutViewDelegate <NSObject>
@optional
///滚动结束事件
- (void)tesla:(FMTeslaLayoutView *)tesla didScrollEnd:(NSInteger)index currentScrollView:(UIScrollView *)scrollView;
///滚动事件
- (void)tesla:(FMTeslaLayoutView *)tesla scrollViewDidScroll:(UIScrollView *)scrollView;
/// 当前上下滚动的事件
- (void)tesla:(FMTeslaLayoutView *)tesla currentScrollViewScrollDidScroll:(UIScrollView *)currentScrollView contentOffset:(CGPoint)contentOffset;

/// 配置FMCollectionLayoutView
///2
- (void)tesla:(FMTeslaLayoutView *)tesla currentShowScrollView:(UIScrollView *)scrollView index:(NSInteger)index;

///0  即将根据Index创建FMCollectionLayoutView
- (void)tesla:(FMTeslaLayoutView *)tesla willCreateScrollViewWithIndex:(NSInteger)index;

///0.5 根据Index自己创建FMCollectionLayoutView shareHeight为共享头部的高度  请将shareHeight顶部空出来并且请保持不使用contentInset  如果返回nil会自动创建FMLayoutView
- (UIScrollView *)tesla:(FMTeslaLayoutView *)tesla customCreateWithIndex:(NSInteger)index shareHeight:(CGFloat)shareHeight;

///1 根据Index创建完毕UIScrollView
- (void)tesla:(FMTeslaLayoutView *)tesla didCreatedScrollViewWithIndex:(NSInteger)index scrollView:(UIScrollView *)scrollView;

/// 悬停标签控制view的尺寸最小高度  可以留着做效果
- (CGFloat)shareSuspensionMinHeightWithTesla:(FMTeslaLayoutView *)tesla;
@end

@protocol FMTeslaLayoutViewDataSource <NSObject>
@required
- (NSInteger)numberOfScreenInTesla:(FMTeslaLayoutView *)tesla;
@optional
- (NSArray<FMLayoutBaseSection *> *)shareSectionsInTesla:(FMTeslaLayoutView *)tesla;
@end

@class FMLayoutBaseSection;
@interface FMTeslaLayoutView : UIView
//@property(nonatomic, strong)NSMutableArray<FMLayoutBaseSection *> *shareSections;
@property(nonatomic, weak)id<FMTeslaLayoutViewDelegate> delegate;
@property(nonatomic, weak)id<FMTeslaLayoutViewDataSource> dataSource;
@property(nonatomic, assign)BOOL horizontalCanScroll;
@property(nonatomic, assign)BOOL allShareStickTop;
@property(nonatomic, assign)NSInteger selectIndex;
- (void)reLoadSubViews;
- (void)reloadData;
- (void)reloadDataWithIndex:(NSInteger)index;
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
