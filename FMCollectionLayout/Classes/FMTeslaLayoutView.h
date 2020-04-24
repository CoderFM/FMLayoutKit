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

- (void)tesla:(FMTeslaLayoutView *)tesla willShowLayoutView:(FMCollectionLayoutView *)layoutView index:(NSInteger)index;

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
- (void)reLoadSubViews;
- (void)reloadData;
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
