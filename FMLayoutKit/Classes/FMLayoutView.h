//
//  FMLayoutView.h
//  FMLayoutKit
//
//  Created by 周发明 on 2020/4/1.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMLayoutView : UICollectionView
@property(nonatomic, weak)FMLayout *layout;
///重写了set get 目标指向->layout.sections
@property(nonatomic)NSMutableArray<FMLayoutBaseSection *> *sections;
@property(nonatomic, assign)BOOL reloadOlnyChanged;
///是否允许长按拖拽排序  不支持夸分组   分组需要开启canLongPressExchange才可以移动拖拽排序
@property(nonatomic, assign)BOOL enableLongPressDrag;
///长按拖拽开始时配置cell显示的样式
@property(nonatomic, copy)UIView *(^configureSourceView)(UICollectionViewCell *sourceCell);
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout NS_UNAVAILABLE;
- (instancetype)initHorizontal;
- (instancetype)initHorizontalWithFrame:(CGRect)frame;
/// 添加插入数组
- (void)appendLayoutSections:(NSArray<FMLayoutBaseSection *> *)sections;
- (void)insertLayoutSections:(NSArray<FMLayoutBaseSection *> *)sections atIndexSet:(NSIndexSet *)indexSet;
- (void)insertLayoutSection:(FMLayoutBaseSection *)section atIndex:(NSInteger)index;

/// 删除分组
- (void)deleteLayoutSections:(NSArray<FMLayoutBaseSection *> *)sections;
- (void)deleteLayoutSectionAt:(NSUInteger)index;
- (void)deleteLayoutSectionSet:(NSIndexSet *)set;

/// 交换分组
- (void)exchangeLayoutSection:(NSUInteger)index to:(NSUInteger)to;
/// 循环遍历出更改过的sections   如果有过增删分组 请使用原有的reloadData方法
- (void)reloadChangedSectionsData;
///获取到滚动到indexPath位置偏移量   如果获取到的不准确  请先调用layoutIfNeeded方法
- (CGPoint)contentOffsetScrollToIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition;

@end

NS_ASSUME_NONNULL_END
