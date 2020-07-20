//
//  FMLayoutScaleSection.m
//  FMLayoutKit
//
//  Created by 郑桂华 on 2020/7/20.
//

#import "FMLayoutScaleSection.h"
#import "FMCollectionLayoutAttributes.h"

@interface __FMLayoutScaleModel : NSObject
@property(nonatomic, assign)BOOL hasHandle;
@property(nonatomic, assign)NSInteger index;
@property(nonatomic, assign)CGFloat scale;
@property(nonatomic, assign)CGFloat beginValue;
@property(nonatomic, assign)CGFloat fixedSize;
@property(nonatomic, assign)CGFloat x;
@property(nonatomic, assign)CGFloat y;
@end

@implementation __FMLayoutScaleModel

+ (instancetype)modelWithIndex:(NSInteger)index scale:(CGFloat)scale{
    __FMLayoutScaleModel *model = [[__FMLayoutScaleModel alloc] init];
    model.index = index;
    model.scale = scale;
    model.x = -1;
    model.y = -1;
    model.fixedSize = -1;
    return model;
}

@end

@interface FMLayoutScaleSection ()

@property(nonatomic, strong)NSMutableDictionary<NSNumber *, __FMLayoutScaleModel *> *fixedSizes;

@end

@implementation FMLayoutScaleSection

- (void)setScales:(NSString *)scales{
    _scales = scales;
    NSArray *scaleNums = [scales componentsSeparatedByString:@":"];
    self.column = scaleNums.count;
    CGFloat total = 0.0;
    for (NSString *num in scaleNums) {
        total += [num floatValue];
    }
    self.fixedSizes = [NSMutableDictionary dictionary];
    CGFloat totalS = 0.0;
    for (int i = 0; i < self.column; i++) {
        NSString *num = scaleNums[i];
        __FMLayoutScaleModel *model = [__FMLayoutScaleModel modelWithIndex:i scale:[num floatValue] / total];
        model.beginValue = totalS;
        self.fixedSizes[@(i)] = model;
        totalS += model.scale;
    }
}

- (void)setSizeNums:(NSArray<NSNumber *> *)sizeNums{
    _sizeNums = sizeNums;
    self.column = sizeNums.count;
    self.fixedSizes = [NSMutableDictionary dictionary];
    CGFloat begin = 0;
    for (int i = 0; i < self.column; i++) {
        NSNumber *num = sizeNums[i];
        __FMLayoutScaleModel *model = [[__FMLayoutScaleModel alloc] init];
        model.index = i;
        model.fixedSize = [num floatValue];
        model.beginValue = begin;
        self.fixedSizes[@(i)] = model;
        begin += model.fixedSize;
    }
}

- (__FMLayoutScaleModel *)getScaleModelColumn:(NSInteger)column{
    __FMLayoutScaleModel *model = self.fixedSizes[@(column)];
    if (model.hasHandle) {
        return model;
    }
    if (model.fixedSize > 0) {
        if (self.direction == FMLayoutDirectionVertical) {
            model.x = model.beginValue + self.sectionInset.left + column * self.itemSpace;
        } else {
            model.y = model.beginValue + self.sectionInset.top + column * self.lineSpace;
        }
        model.hasHandle = YES;
        return model;
    } else {
        CGFloat scale = model.scale;
        if (self.direction == FMLayoutDirectionVertical) {
            CGFloat totalWidth = self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.column - 1) * self.itemSpace;
            CGFloat size = totalWidth * scale;
            model.fixedSize = size;
            model.x = totalWidth * model.beginValue + self.sectionInset.left + column * self.itemSpace;
        } else {
            CGFloat totalHeight = self.collectionView.frame.size.height - self.sectionInset.top - self.sectionInset.bottom - (self.column - 1) * self.lineSpace;
            CGFloat size = totalHeight * scale;
            model.fixedSize = size;
            model.y = totalHeight * model.beginValue + self.sectionInset.top + column * self.lineSpace;
        }
        model.hasHandle = YES;
        return model;
    }
}

- (FMCollectionLayoutAttributes *)getItemAttributesWithIndex:(NSInteger)j{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:self.indexPath.section];
    FMCollectionLayoutAttributes *itemAttr = [FMCollectionLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSInteger column = [self getMinHeightColumn];
    __FMLayoutScaleModel *model = [self getScaleModelColumn:column];
    CGFloat itemFixed = model.fixedSize;
    CGFloat itemOther = 0;
    if (self.autoHeightFixedWidth) {
        if (self.direction == FMLayoutDirectionHorizontal) {
            @throw [NSException exceptionWithName:@"autoHeightFixedWidth must for FMLayoutDirectionVertical" reason:@"FMLayoutDynamicSection" userInfo:nil];
        }
        if (self.deqCellReturnReuseId) {
            UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:self.deqCellReturnReuseId(self, j) forIndexPath:indexPath];
            if (self.configurationCell) {
                self.configurationCell(self ,cell, j);
            }
            itemOther = [cell systemLayoutSizeFittingSize:CGSizeMake(itemFixed, MAXFLOAT)].height;
        }
    } else {
        itemOther = !self.otherBlock?0:self.otherBlock(self, j);
    }
    if (self.direction == FMLayoutDirectionVertical) {
        CGSize itemSize = CGSizeMake(itemFixed, itemOther);
        CGFloat x = model.x;
        CGFloat height = [self.columnSizes[@(column)] floatValue];
        CGFloat y = self.firstItemStartY + (height > 0 ? (height + self.lineSpace) : height);
        itemAttr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
        self.columnSizes[@(column)] = @(height + itemSize.height + (height > 0 ? self.lineSpace : 0));
    } else {
        CGSize itemSize = CGSizeMake(itemOther, itemFixed);
        CGFloat minWidth = [self.columnSizes[@(column)] floatValue];
        CGFloat x = self.firstItemStartX + (minWidth > 0 ? (minWidth + self.itemSpace) : minWidth);
        CGFloat y = model.y;
        itemAttr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
        self.columnSizes[@(column)] = @(minWidth + itemSize.width + (minWidth > 0 ? self.itemSpace : 0));
    }
    if (self.configureCellLayoutAttributes) {
        self.configureCellLayoutAttributes(self, itemAttr, j);
    }
    return itemAttr;
}


@end
