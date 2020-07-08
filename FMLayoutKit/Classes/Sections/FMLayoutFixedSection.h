//
//  FMLayoutFixedSection.h
//  FMLayoutKit
//
//  Created by 周发明 on 2020/4/1.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutBaseSection.h"
#import "FMLayoutElement.h"
NS_ASSUME_NONNULL_BEGIN

///固定cell的大小  单一一种cell样式   支持同样cell是否可以横向滚动 内嵌collectionView  支持纵向插横向
@interface FMLayoutFixedSection : FMLayoutBaseSection

@property(nonatomic, assign)CGSize itemSize;///分组cell大小

@property(nonatomic, strong)FMLayoutElement *cellElement;///固定分组

@end

NS_ASSUME_NONNULL_END
