//
//  FMTeslaLayoutView.h
//  FMCollectionLayout_Example
//
//  Created by 郑桂华 on 2020/4/8.
//  Copyright © 2020 周发明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FMCollectionLayoutView, FMTeslaLayoutView, FMLayoutBaseSection;
@protocol FMTeslaLayoutViewDelegate <NSObject>
@optional
///滚动结束事件
- (void)tesla:(FMTeslaLayoutView *)tesla didScrollEnd:(NSInteger)index currentLayoutView:(FMCollectionLayoutView *)layoutView;
///滚动事件
- (void)tesla:(FMTeslaLayoutView *)tesla scrollViewDidScroll:(UIScrollView *)scrollView;
/// 当前上下滚动的事件
- (void)tesla:(FMTeslaLayoutView *)tesla currentLayoutViewScrollDidScroll:(FMCollectionLayoutView *)currentLayoutView contentOffset:(CGPoint)contentOffset;

/// 配置FMCollectionLayoutView
///2
- (void)tesla:(FMTeslaLayoutView *)tesla currentShowLayoutView:(FMCollectionLayoutView *)layoutView index:(NSInteger)index;

///0  即将根据Index创建FMCollectionLayoutView
- (void)tesla:(FMTeslaLayoutView *)tesla willCreateLayoutViewWithIndex:(NSInteger)index;

///0.5 根据Index自己创建FMCollectionLayoutView
- (FMCollectionLayoutView *)tesla:(FMTeslaLayoutView *)tesla customCreateWithIndex:(NSInteger)index;

///1 根据Index创建完毕FMCollectionLayoutView
- (void)tesla:(FMTeslaLayoutView *)tesla didCreatedLayoutViewWithIndex:(NSInteger)index layoutView:(FMCollectionLayoutView *)layoutView;

/// 悬停标签控制view的尺寸最小高度  可以留着做效果
- (CGFloat)shareSuspensionMinHeightWithTesla:(FMTeslaLayoutView *)tesla;
@end

@protocol FMTeslaLayoutViewDataSource <NSObject>
@required
- (NSInteger)numberOfScreenInTesla:(FMTeslaLayoutView *)tesla;
- (NSMutableArray<FMLayoutBaseSection *> *)tesla:(FMTeslaLayoutView *)tesla sectionsInScreenIndex:(NSInteger)screenIndex;
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
