//
//  FMLayoutFixedSection.h
//  FMLayoutKit
//
//  Created by 郑桂华 on 2020/4/1.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutBaseSection.h"
#import "FMCollectionViewElement.h"
NS_ASSUME_NONNULL_BEGIN

///固定cell的大小  单一一种cell样式   支持同样cell是否可以横向滚动 内嵌collectionView
@interface FMLayoutFixedSection : FMLayoutBaseSection

@property(nonatomic, assign)CGSize itemSize;///分组cell大小

@property(nonatomic, strong)FMCollectionViewElement *cellElement;///固定分组

@property(nonatomic, assign)BOOL isHorizontalCanScroll;///横向布局可滚动   插入一个cell+collection方式
@end

NS_ASSUME_NONNULL_END
