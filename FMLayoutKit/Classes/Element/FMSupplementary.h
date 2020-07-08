//
//  FMSupplementary.h
//  FMLayoutKit
//
//  Created by 周发明 on 2020/3/20.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutElement.h"

typedef NS_ENUM(NSInteger, FMLayoutZIndex) {
    ///最底层   头部  底部   Item的下方
    FMLayoutZIndexBg = -9999,
    ///Item的下方
    FMLayoutZIndexBackOfItem = -1,
    /// 自动悬浮可能会被覆盖
    FMLayoutZIndexAuto = 0,
    /// Item的上方
    FMLayoutZIndexFrontOfItem = 1,
    /// 最最上方
    FMLayoutZIndexFrontAlways = 9999
};

NS_ASSUME_NONNULL_BEGIN
/// 请使用子类Footer, Header, Background
@interface FMSupplementary : FMLayoutElement
///该Element的大小 纵向-高度    横向-宽度
@property(nonatomic, assign)CGFloat size;
///视图层级   最上方还是最下方等
@property(nonatomic, assign)FMLayoutZIndex zIndex;
///内边距  HeaderFooter受sectionInset影响   Background不受sectionInset影响
@property(nonatomic, assign)UIEdgeInsets inset;
///Element类型 Header Footer Background等
@property(nonatomic, copy, readonly)NSString *elementKind;
///是否自适应高度   仅当垂直布局时可用
@property(nonatomic, assign)BOOL autoHeight;
@property(nonatomic, copy)void(^configureDataAutoHeight)(UICollectionReusableView *view);

+ (instancetype)elementSize:(CGFloat)size viewClass:(Class)vClass;
+ (instancetype)elementSize:(CGFloat)size viewClass:(Class)vClass isNib:(BOOL)isNib;
+ (instancetype)elementSize:(CGFloat)size viewClass:(Class)vClass isNib:(BOOL)isNib reuseIdentifier:(NSString *)reuseIdentifier;

- (UICollectionReusableView *)dequeueReusableViewWithCollection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

- (void)updateHeightWithCollection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath maxWidth:(CGFloat)maxWidth;
@end

NS_ASSUME_NONNULL_END
