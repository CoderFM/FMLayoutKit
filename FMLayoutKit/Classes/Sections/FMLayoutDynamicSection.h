//
//  FMLayoutDynamicSection.h
//  FMLayoutKit
//
//  Created by 周发明 on 2020/4/1.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutBaseSection.h"
#import "FMLayoutElement.h"
NS_ASSUME_NONNULL_BEGIN

///返回cell大小的block  横向-返回宽度  纵向-返回高度
typedef CGFloat(^FMLayoutItemOtherBlock)(id section, NSInteger item);

///动态  可以注册多种cell  宽度固定   高度可以自适应 但需要用block填充数据  需要设置deqCellReturnReuseId该block值以获取cell    高度亦可以通过手动计算heightBlock返回   手动计算优先级要高
@interface FMLayoutDynamicSection : FMLayoutBaseSection
/// yes时   布局耗时比较长 是否自动计算高度 需设置configurationCell方法填充数据 仅支持纵向布局时使用
@property(nonatomic, assign)BOOL autoHeightFixedWidth;
///cell固定一个方向的大小 纵向-宽度   横向-高度
@property(nonatomic, assign)CGFloat cellFixedSize;
///需要注册的cell元素
@property(nonatomic, strong)NSArray<FMLayoutElement *> *cellElements;
///固定单一分组  当固定单一分组时  可以不用手动配置deqCellReturnReuseId
@property(nonatomic, strong)FMLayoutElement *cellElement;
///获取cell的复用FMLayoutElement
@property(nonatomic, copy)FMLayoutElement *(^deqCellReturnElement)(FMLayoutDynamicSection *section, NSInteger item);
///填充数据  仅当autoHeightFixedWidth为Yes时有用
@property(nonatomic, copy)void(^configurationCell)(FMLayoutDynamicSection *section, UICollectionViewCell *cell, NSInteger item);
///block返回手动计算的高度  优先级比自动的高
@property(nonatomic, copy)FMLayoutItemOtherBlock otherBlock;

- (CGFloat)autoHeightVerticalWithWidth:(CGFloat)fixedWidth index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
