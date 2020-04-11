//
//  FMLayoutFillSection.h
//  FMCollectionLayout
//
//  Created by 郑桂华 on 2020/4/11.
//

#import "FMLayoutDynamicSection.h"

NS_ASSUME_NONNULL_BEGIN

///返回cell大小的block
typedef CGSize(^FMLayoutItemSizeBlock)(id section, NSInteger item);

@interface FMLayoutFillSection : FMLayoutDynamicSection

@property(nonatomic, copy)FMLayoutItemSizeBlock sizeBlock;

@end

NS_ASSUME_NONNULL_END
