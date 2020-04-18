//
//  FMLayoutBaseSection.h
//  LiangXinApp
//
//  Created by 郑桂华 on 2020/3/20.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FMSupplementaryHeader, FMSupplementaryFooter, FMSupplementaryBackground, FMCollectionLayoutAttributes;
@interface FMLayoutBaseSection : NSObject

@property(nonatomic, weak)UICollectionView *collectionView;
@property(nonatomic, strong)NSIndexPath *indexPath;

@property(nonatomic, assign)BOOL hasHanble;///是否需要重新计算
@property(nonatomic, assign)NSInteger hanbleItemStart;///重新计算哪一个开始

@property(nonatomic, strong)FMCollectionLayoutAttributes *bgAttribute;
@property(nonatomic, strong)FMCollectionLayoutAttributes *headerAttribute;
@property(nonatomic, strong)FMCollectionLayoutAttributes *footerAttribute;
@property(nonatomic, strong)NSArray<FMCollectionLayoutAttributes *> *itemsAttribute;

@property(nonatomic, assign)CGFloat sectionOffset;/// 分组偏移高度
@property(nonatomic, assign)CGFloat sectionHeight;/// 分组高度
@property(nonatomic, assign)UIEdgeInsets sectionInset;/// 分组内边距

@property(nonatomic, strong)FMSupplementaryHeader *header;///分组头部
@property(nonatomic, strong)FMSupplementaryFooter *footer;///分组底部
@property(nonatomic, strong)FMSupplementaryBackground *background;///分组背景

@property(nonatomic, assign)CGFloat lineSpace;///cell行间距
@property(nonatomic, assign)CGFloat itemSpace;///cell间距
@property(nonatomic, assign)NSInteger column;///cell列数   如果是子类横向可滚动的  则该参数是最大行数

@property(nonatomic, strong)NSMutableDictionary *columnHeights;///每一列的高度缓存

@property(nonatomic, strong)NSMutableArray *itemDatas;///cell数据数组


@property(nonatomic, assign, readonly)CGFloat firstItemStartY;


+ (instancetype)sectionWithSectionInset:(UIEdgeInsets)inset itemSpace:(CGFloat)itemSpace lineSpace:(CGFloat)lineSpace column:(NSInteger)column;

- (BOOL)intersectsRect:(CGRect)rect;

- (void)prepareHeader;
- (void)prepareFooter;
- (void)prepareItems;
- (void)prepareBackground;

- (UICollectionViewLayoutAttributes *)showHeaderLayout;

///获取最小高度的列
- (NSInteger)getMinHeightColumn;

- (CGFloat)getColumnMaxHeight;
///重置所有列的高度缓存
- (void)resetColumnHeights;

- (UICollectionViewCell *)dequeueReusableCellForIndexPath:(NSIndexPath *)indexPath;
- (void)registerCells;
@end

NS_ASSUME_NONNULL_END
