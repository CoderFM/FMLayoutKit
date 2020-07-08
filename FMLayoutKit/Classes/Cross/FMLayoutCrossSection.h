//
//  FMLayoutCrossSection.h
//  FMLayoutKit
//
//  Created by 周发明 on 2020/6/16.
//

#import "FMLayoutBaseSection.h"

NS_ASSUME_NONNULL_BEGIN
@interface FMLayoutCrossSection : FMLayoutBaseSection<UICollectionViewDelegate>
@property(nonatomic, assign, readonly)FMLayoutDirection crossDirection;
/// 所有section计算获取最大的高度
@property(nonatomic, assign)BOOL autoMaxSize;
/// 所有section计算获取最大的高度
@property(nonatomic, assign)CGFloat size;
@property(nonatomic, assign)BOOL canReuseCell;
@property(nonatomic, assign, readonly)CGFloat maxContentWidth;

@property(nonatomic, strong)NSMutableArray<FMLayoutBaseSection *> *sections;

@property(nonatomic, copy)void(^scrollDidScroll)(UICollectionView *collectionView, FMLayoutCrossSection *hSection);
@property(nonatomic, copy)void(^configureCollectionView)(UICollectionView *collectionView, FMLayoutCrossSection *hSection);

+ (instancetype)sectionAutoWithSection:(FMLayoutBaseSection *)section;

@end

NS_ASSUME_NONNULL_END
