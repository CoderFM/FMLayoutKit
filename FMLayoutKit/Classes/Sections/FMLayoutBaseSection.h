//
//  FMLayoutBaseSection.h
//  FMLayoutKit
//
//  Created by 周发明 on 2020/3/20.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FMLayoutDebugLog.h"

typedef NS_ENUM(NSUInteger, FMLayoutHandleType) {
    /// 重新计算 重新布局该分组
    FMLayoutHandleTypeReLayout,
    /// 只是分组偏移高度改变
    FMLayoutHandleTypeOlnyChangeOffset,
    /// 追加布局
    FMLayoutHandleTypeAppend
};
///布局方向
typedef NS_ENUM(NSUInteger, FMLayoutDirection) {
    ///垂直布局
    FMLayoutDirectionVertical,
    ///水平布局
    FMLayoutDirectionHorizontal
};
///Item布局方向
typedef NS_ENUM(NSUInteger, FMLayoutItemDirection) {
    ///水平左边开始  垂直上面开始
    FMLayoutItemDirectionLeftTop,
    ///水平右边开始  垂直下面开始
    FMLayoutItemDirectionRightBottom
};
///长按移动的方式
typedef NS_ENUM(NSUInteger, FMLayoutLongMoveType) {
    ///方格布局时  长按哪里  该cell的中心点就会跟着移动
    FMLayoutLongMoveItem,
    ///列表布局时  上下移动  X不动
    FMLayoutLongMoveTable,
};

NS_ASSUME_NONNULL_BEGIN
@class FMLayoutHeader, FMLayoutFooter, FMLayoutBackground, FMCollectionLayoutAttributes;

@interface FMLayoutBaseSection : NSObject<NSCopying>
///仅当布局生效之后才会有值
@property(nonatomic, weak)UICollectionView *collectionView;
///仅当布局生效之后才会有值
@property(nonatomic, strong)NSIndexPath *indexPath;

///是否需要重新计算 设置为NO  布局会重新计算
@property(nonatomic, assign)FMLayoutDirection direction;
@property(nonatomic, assign)BOOL hasHandle;
@property(nonatomic, assign)NSInteger handleItemStart;///重新计算哪一个开始
@property(nonatomic, assign)FMLayoutHandleType handleType;
@property(nonatomic, assign)CGFloat changeOffset;

@property(nonatomic, strong)FMCollectionLayoutAttributes * __nullable bgAttribute;
@property(nonatomic, strong)FMCollectionLayoutAttributes * __nullable headerAttribute;
@property(nonatomic, strong)FMCollectionLayoutAttributes * __nullable footerAttribute;
@property(nonatomic, strong)NSArray<FMCollectionLayoutAttributes *> *itemsAttribute;
/// 分组偏移高度
@property(nonatomic, assign)CGFloat sectionOffset;
/// 分组大小  纵向-高度  横向-宽度
@property(nonatomic, assign)CGFloat sectionSize;
/// 分组内边距
@property(nonatomic, assign)UIEdgeInsets sectionInset;
///分组头部
@property(nonatomic, strong)FMLayoutHeader * __nullable header;
///分组底部
@property(nonatomic, strong)FMLayoutFooter * __nullable footer;
///分组背景
@property(nonatomic, strong)FMLayoutBackground * __nullable background;
///cell行间距
@property(nonatomic, assign)CGFloat lineSpace;
///cell间距
@property(nonatomic, assign)CGFloat itemSpace;
///cell列数  纵向-列数   横向-行数
@property(nonatomic, assign)NSInteger column;
///每一列的高度缓存
@property(nonatomic, strong)NSMutableDictionary *columnSizes;
///每一个分组的item个数  默认返回itemDatas.count
@property(nonatomic, assign)NSInteger itemCount;
///cell数据数组
@property(nonatomic, strong)NSMutableArray *itemDatas;
///是否可以长按移动排序该分组  默认No  需配合FMLayoutView的enableLongPressDrag使用
@property(nonatomic, assign)BOOL canLongPressExchange;
///长按移动的方式
@property(nonatomic, assign)FMLayoutLongMoveType moveType;
///某一个item是否可以移动替换
@property(nonatomic, copy)BOOL(^canLongPressExchangeItem)(id section, NSInteger item);
///第一个Item的Y值  横向纵向有区别
@property(nonatomic, assign, readonly)CGFloat firstItemStartY;
///第一个Item的X值  横向纵向有区别
@property(nonatomic, assign, readonly)CGFloat firstItemStartX;
///配置一下Attributes
@property(nonatomic, copy)void(^configureCellLayoutAttributes)(id section, UICollectionViewLayoutAttributes *attributes, NSInteger item);

///配置头部的block
@property(nonatomic, copy)void(^configureHeaderData)(FMLayoutBaseSection *section, UICollectionReusableView *header);
///配置底部的block
@property(nonatomic, copy)void(^configureFooterData)(FMLayoutBaseSection *section, UICollectionReusableView *footer);
///配置背景的block
@property(nonatomic, copy)void(^configureBg)(FMLayoutBaseSection *section, UICollectionReusableView *bg);
///配置Cell的block
@property(nonatomic, copy)void(^configureCellData)(FMLayoutBaseSection *section, UICollectionViewCell *cell, NSInteger item);
///cell点击事件
@property(nonatomic, copy)void(^clickCellBlock)(FMLayoutBaseSection *section, NSInteger item);

+ (instancetype)sectionWithSectionInset:(UIEdgeInsets)inset itemSpace:(CGFloat)itemSpace lineSpace:(CGFloat)lineSpace column:(NSInteger)column;
///标记某一个改变  即将刷新该分组的大小  主要用于动态分组
- (void)markChangeAt:(NSInteger)index;

- (void)handleLayout;

- (BOOL)intersectsRect:(CGRect)rect;

- (void)prepareHeader;
- (void)prepareFooter;
- (void)prepareItems;
- (void)prepareBackground;

- (NSArray *)showLayoutAttributesInRect:(CGRect)rect;
///即将显示的头部布局
- (UICollectionViewLayoutAttributes *)showHeaderLayout;
///根据index计算出该布局对象
- (FMCollectionLayoutAttributes *)getItemAttributesWithIndex:(NSInteger)index;
- (BOOL)prepareLayoutItemsIsOlnyChangeOffset;

///获取最小高度的列
- (NSInteger)getMinHeightColumn;

- (CGFloat)getColumnMaxHeight;
///重置所有列的高度缓存
- (void)resetcolumnSizes;

///交叉布局时单一sention的大小
- (CGFloat)crossSingleSectionSize;

- (void)exchangeObjectAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex;

- (UICollectionViewCell *)dequeueReusableCellForIndexPath:(NSIndexPath *)indexPath;
- (UICollectionViewCell *)dequeueReusableCellForIndexPath:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView;
- (void)registerCells;
- (void)registerCellsWithCollectionView:(UICollectionView *)collectionView;

@end

NS_ASSUME_NONNULL_END
