//
//  FMLayoutDynamicSection.h
//  FMLayoutKit
//
//  Created by 郑桂华 on 2020/4/1.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMCollectionLayoutBaseSection.h"
#import "FMCollectionViewElement.h"
NS_ASSUME_NONNULL_BEGIN

///返回cell大小的block
typedef CGFloat(^FMLayoutItemHeightBlock)(id section, NSInteger item);

@interface FMLayoutDynamicSection : FMCollectionLayoutBaseSection

@property(nonatomic, assign)BOOL autoHeightFixedWidth;/// 是否自动计算高度 需设置configurationCell方法  填充数据
@property(nonatomic, assign)CGFloat cellFixedWidth;///目前仅支持纵向布局  cell固定宽度

@property(nonatomic, strong)NSArray<FMCollectionViewElement *> *cellElements;///需要注册的cell元素

@property(nonatomic, copy)NSString *(^deqCellReturnReuseId)(FMLayoutDynamicSection *section, NSInteger index);///获取cell的复用标识
@property(nonatomic, copy)void(^configurationCell)(FMLayoutDynamicSection *section, UICollectionViewCell *cell, NSInteger index);///填充数据
@property(nonatomic, copy)FMLayoutItemHeightBlock heightBlock;///block返回手动计算的高度  优先级比自动的高

@end

NS_ASSUME_NONNULL_END
