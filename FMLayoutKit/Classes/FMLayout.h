//
//  FMLayout.h
//  FMLayoutKit
//
//  Created by 周发明 on 2020/6/16.
//

#import <UIKit/UIKit.h>
#import "FMLayoutBaseSection.h"
#import "FMLayoutHeader.h"
#import "FMLayoutFooter.h"
#import "FMLayoutBackground.h"
#import "FMCollectionLayoutAttributes.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMLayout : UICollectionViewLayout

@property(nonatomic, assign)FMLayoutDirection direction;
@property(nonatomic, strong)NSMutableArray<FMLayoutBaseSection *> *sections;
///最后固定边距   跟section的inset无关  contentSize会自动加上去
@property(nonatomic, assign)CGFloat fixedLastMargin;
///是否只计算改变的布局  NO为每一次  都是重新计算所有布局
@property(nonatomic, assign)BOOL reLayoutOlnyChanged;
///最小可滑动的大小   横向-高度  纵向-宽度
@property(nonatomic, assign)CGFloat minContentSize;
///第一个Section的偏移量
@property(nonatomic, assign)CGFloat firstSectionOffset;

@end

NS_ASSUME_NONNULL_END
