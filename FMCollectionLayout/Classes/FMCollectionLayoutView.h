//
//  FMCollectionLayoutView.h
//  FMLayoutKit
//
//  Created by 郑桂华 on 2020/4/1.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMCollectionViewLayout.h"

NS_ASSUME_NONNULL_BEGIN
@class FMCollectionLayoutView;
@protocol FMCollectionLayoutViewConfigurationDelegate <NSObject>
@optional
- (void)layoutView:(FMCollectionLayoutView *)layoutView configurationCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)layoutView:(FMCollectionLayoutView *)layoutView configurationHeader:(UICollectionReusableView *)header indexPath:(NSIndexPath *)indexPath;
- (void)layoutView:(FMCollectionLayoutView *)layoutView configurationFooter:(UICollectionReusableView *)footer indexPath:(NSIndexPath *)indexPath;
- (void)layoutView:(FMCollectionLayoutView *)layoutView configurationSectionBg:(UICollectionReusableView *)bg indexPath:(NSIndexPath *)indexPath;
@end

@interface FMCollectionLayoutView : UICollectionView
@property(nonatomic, weak)id<FMCollectionLayoutViewConfigurationDelegate> configuration;
@property(nonatomic, strong)FMCollectionViewLayout *layout;
@property(nonatomic, assign)BOOL reloaOlnyChanged;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
