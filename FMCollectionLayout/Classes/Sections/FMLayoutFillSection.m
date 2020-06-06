//
//  FMLayoutFillSection.m
//  FMCollectionLayout
//
//  Created by 郑桂华 on 2020/4/11.
//

#import "FMLayoutFillSection.h"
#import "FMCollectionLayoutAttributes.h"
#import "FMSupplementaryHeader.h"

@implementation FMLayoutFillSection

- (void)prepareItems{
    if ([self prepareLayoutItemsIsOlnyChangeY]) return;
    [self resetColumnHeights];
    NSInteger items = [self.collectionView numberOfItemsInSection:self.indexPath.section];
    NSMutableArray *attrs = [NSMutableArray array];
    CGFloat maxHeight = 0;
    for (int j = 0; j < items; j++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:self.indexPath.section];
        FMCollectionLayoutAttributes *itemAttr = [FMCollectionLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        CGSize itemSize = !self.sizeBlock?CGSizeZero:self.sizeBlock(self, j);
        if (attrs.count == 0) {
            CGFloat x = self.sectionInset.left;
            CGFloat y = self.firstItemStartY;
            itemAttr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);

            maxHeight = itemSize.height;
        } else {
            
            CGFloat lastX = 0;
            CGFloat lastY = 0;
    
            /// 放在右侧寻找最适合
            for (FMCollectionLayoutAttributes *attr in attrs) {
                CGFloat thisX = CGRectGetMaxX(attr.frame);
                CGFloat thisY = CGRectGetMinY(attr.frame);
                
                if (thisX + itemSize.width > self.collectionView.bounds.size.width) {
                    continue;
                } else {
                    CGRect frame = CGRectMake(thisX, thisY, itemSize.width, itemSize.height);
                    if (![self intersectsRectInExsitAttributes:attrs frame:frame]) {///没有交集  可以是放
                        if (lastX == 0 && lastY == 0) { ///如果都没有设置  则就设置为最合适的
                            lastY = thisY;
                            lastX = thisX;
                        } else {
                            if (thisY <= lastY) {
                                lastY = thisY;
                                lastX = thisX;
                            } else {
                                if (thisX < lastX) {
                                    lastX = thisX;
                                    lastY = thisY;
                                }
                            }
                        }
                    }
                }
            }
            
            /// 放在下侧寻找最适合
            for (FMCollectionLayoutAttributes *attr in attrs) {
                CGFloat thisX = CGRectGetMinX(attr.frame);
                CGFloat thisY = CGRectGetMaxY(attr.frame);

                if (thisX + itemSize.width > self.collectionView.bounds.size.width) {
                    continue;
                } else {
                    CGRect frame = CGRectMake(thisX, thisY, itemSize.width, itemSize.height);
                    if (![self intersectsRectInExsitAttributes:attrs frame:frame]) {///没有交集  可以是放
                        if (lastX == 0 && lastY == 0) {
                            lastY = thisY;
                            lastX = thisX;
                        } else {
                            if (lastX > 0 || lastY > 0) { ///找到合适位置
                                if (thisY < lastY) { /// 如果找到的合适的y值小于之前的找到的y值  则设置为现在
                                    lastY = thisY;
                                    lastX = thisX;
                                } else if([self roundFloat:thisY] == [self roundFloat:lastY]) {///会有精度比较问题
                                    if (thisX < lastX) {
                                        lastY = thisY;
                                        lastX = thisX;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            CGRect frame = CGRectMake(lastX, lastY, itemSize.width, itemSize.height);
            CGFloat height = CGRectGetMaxY(frame) - self.sectionOffset - self.sectionInset.top - self.header.height - self.header.bottomMargin;
            if (height > maxHeight) {
                maxHeight = height;
            }
            itemAttr.frame = frame;
        }
        [attrs addObject:itemAttr];
    }
    self.columnHeights[@(0)] = @(maxHeight);
    self.itemsAttribute = [attrs copy];
}

- (BOOL)intersectsRectInExsitAttributes:(NSArray<FMCollectionLayoutAttributes *> *)attributes frame:(CGRect)frame{
    for (FMCollectionLayoutAttributes *attr in attributes) {
        if (CGRectIntersectsRect(attr.frame, frame)) {
            return YES;
        }
    }
    return NO;
}

-(CGFloat)roundFloat:(CGFloat)value{
    return roundf(value*100)/100;
}

@end
