//
//  FMTeslaLayoutView.h
//  FMCollectionLayout_Example
//
//  Created by 郑桂华 on 2020/4/8.
//  Copyright © 2020 周发明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FMCollectionLayoutView, FMTeslaLayoutView;
@protocol FMTeslaLayoutViewDelegate <NSObject>
@optional
///点击事件
- (void)tesla:(FMTeslaLayoutView *)tesla didSelectIndexPath:(NSIndexPath *)indexPath isShare:(BOOL)isSahre multiIndex:(NSInteger)multiIndex layoutView:(FMCollectionLayoutView *)layoutView;
@end

@protocol FMTeslaLayoutViewDataSource <NSObject>
@optional
///配置cell
- (void)tesla:(FMTeslaLayoutView *)tesla configurationCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath isShare:(BOOL)isSahre multiIndex:(NSInteger)multiIndex layoutView:(FMCollectionLayoutView *)layoutView;
///配置header
- (void)tesla:(FMTeslaLayoutView *)tesla configurationHeader:(UICollectionReusableView *)cell indexPath:(NSIndexPath *)indexPath isShare:(BOOL)isSahre multiIndex:(NSInteger)multiIndex layoutView:(FMCollectionLayoutView *)layoutView;
///配置footer
- (void)tesla:(FMTeslaLayoutView *)tesla configurationFooter:(UICollectionReusableView *)cell indexPath:(NSIndexPath *)indexPath isShare:(BOOL)isSahre multiIndex:(NSInteger)multiIndex layoutView:(FMCollectionLayoutView *)layoutView;
///配置bg
- (void)tesla:(FMTeslaLayoutView *)tesla configurationBg:(UICollectionReusableView *)cell indexPath:(NSIndexPath *)indexPath isShare:(BOOL)isSahre multiIndex:(NSInteger)multiIndex layoutView:(FMCollectionLayoutView *)layoutView;
@end


@class FMLayoutBaseSection;
@interface FMTeslaLayoutView : UIView
@property(nonatomic, strong)NSMutableArray<FMLayoutBaseSection *> *shareSections;
@property(nonatomic, strong)NSArray<NSMutableArray<FMLayoutBaseSection *> *> *multiSections;
@property(nonatomic, weak)id<FMTeslaLayoutViewDataSource> dataSource;
@property(nonatomic, weak)id<FMTeslaLayoutViewDelegate> delegate;
- (void)reLoadSubViews;
- (void)reloadData;
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
