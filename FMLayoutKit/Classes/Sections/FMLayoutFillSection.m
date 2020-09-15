//
//  FMLayoutFillSection.m
//  FMCollectionLayout
//
//  Created by 周发明 on 2020/4/11.
//

#import "FMLayoutFillSection.h"
#import "FMCollectionLayoutAttributes.h"
#import "FMLayoutHeader.h"

@interface FMLayoutFillSection ()

@property(nonatomic, assign)CGFloat maxSize;

@end

@implementation FMLayoutFillSection

- (id)copyWithZone:(NSZone *)zone{
    FMLayoutFillSection *section = [super copyWithZone:zone];
    section.sizeBlock = [self.sizeBlock copy];
    return section;
}

- (void)prepareItems{
    if ([self prepareLayoutItemsIsOlnyChangeOffset]) return;
    [self resetcolumnSizes];
    NSInteger items = MIN([self.collectionView numberOfItemsInSection:self.indexPath.section], self.itemCount);
    NSMutableArray *attrs = [NSMutableArray array];
    int first = 0;
    if (self.handleType == FMLayoutHandleTypeAppend) {
        attrs = [self.itemsAttribute?:@[] mutableCopy];
        first = (int)self.handleItemStart;
    }
    CGFloat maxHeight = 0;
    for (int j = first; j < items; j++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:self.indexPath.section];
        FMCollectionLayoutAttributes *itemAttr = [FMCollectionLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        CGSize itemSize = !self.sizeBlock?CGSizeZero:self.sizeBlock(self, j);
        if (attrs.count == 0) {
            CGFloat x = self.firstItemStartX;
            CGFloat y = self.firstItemStartY;
            itemAttr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);

            maxHeight = itemSize.height;
        } else {
    
            if (self.direction == FMLayoutDirectionVertical) {
                CGFloat lastX = 0;
                CGFloat lastY = 0;
                /// 放在右侧寻找最适合
                for (FMCollectionLayoutAttributes *attr in attrs) {
                    CGFloat thisX = CGRectGetMaxX(attr.frame) + self.itemSpace;
                    CGFloat thisY = CGRectGetMinY(attr.frame);
                    
                    if (thisX + itemSize.width > self.collectionView.frame.size.width-self.sectionInset.right) {
                        continue;
                    } else {
                        CGRect frame = CGRectMake(thisX, thisY, itemSize.width, itemSize.height);
                        if (![self intersectsRectInExsitAttributes:attrs frame:frame verticle:NO]) {///没有交集  可以是放
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
                    CGFloat thisY = CGRectGetMaxY(attr.frame) + self.lineSpace;

                    if (thisX + itemSize.width > self.collectionView.frame.size.width-self.sectionInset.right) {
                        continue;
                    } else {
                        CGRect frame = CGRectMake(thisX, thisY, itemSize.width, itemSize.height);
                        if (![self intersectsRectInExsitAttributes:attrs frame:frame verticle:YES]) {///没有交集  可以是放
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
                if (lastY == 0 && lastX == 0) {
                    lastY = self.firstItemStartY + maxHeight + self.lineSpace;
                    lastX = self.firstItemStartX;
                }
                CGRect frame = CGRectMake(lastX, lastY, itemSize.width, itemSize.height);
                CGFloat height = CGRectGetMaxY(frame) - self.sectionOffset - self.sectionInset.top - self.header.inset.top - self.header.size - - self.header.inset.bottom - self.header.lastMargin;
                if (height > maxHeight) {
                    maxHeight = height;
                }
                itemAttr.frame = frame;
                
            } else {
                
                CGFloat lastX = 0;
                CGFloat lastY = 0;
                
                /// 放在下侧寻找最适合
                for (FMCollectionLayoutAttributes *attr in attrs) {
                    CGFloat thisX = CGRectGetMinX(attr.frame);
                    CGFloat thisY = CGRectGetMaxY(attr.frame) + self.lineSpace;

                    if (thisY + itemSize.height > self.collectionView.frame.size.height-self.sectionInset.bottom) {
                        continue;
                    } else {
                        CGRect frame = CGRectMake(thisX, thisY, itemSize.width, itemSize.height);
                        if (![self intersectsRectInExsitAttributes:attrs frame:frame verticle:YES]) {///没有交集  可以是放
                            if (lastX == 0 && lastY == 0) {
                                lastY = thisY;
                                lastX = thisX;
                            } else {
                                if (thisX < lastX) { /// 如果找到的合适的x值小于之前的找到的x值  则设置为现在
                                    lastX = thisX;
                                    lastY = thisY;
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
                
                /// 放在右侧寻找最适合
                for (FMCollectionLayoutAttributes *attr in attrs) {
                    CGFloat thisX = CGRectGetMaxX(attr.frame) + self.itemSpace;
                    CGFloat thisY = CGRectGetMinY(attr.frame);

                    if (thisY + itemSize.height > self.collectionView.frame.size.height-self.sectionInset.bottom) {
                        continue;
                    } else {
                        CGRect frame = CGRectMake(thisX, thisY, itemSize.width, itemSize.height);
                        if (![self intersectsRectInExsitAttributes:attrs frame:frame verticle:YES]) {///没有交集  可以是放
                            if (lastX == 0 && lastY == 0) { ///如果都没有设置  则就设置为最合适的
                                lastY = thisY;
                                lastX = thisX;
                            } else {
                                if (thisX < lastX) {
                                    lastY = thisY;
                                    lastX = thisX;
                                }
                            }
                        }
                    }
                }
                
                if (lastY == 0 && lastX == 0) {
                    lastY = self.firstItemStartY;
                    lastX = self.firstItemStartX + maxHeight + self.itemSpace;
                }
                CGRect frame = CGRectMake(lastX, lastY, itemSize.width, itemSize.height);
                CGFloat height = CGRectGetMaxX(frame) - self.sectionOffset - self.sectionInset.left - self.header.inset.left - self.header.size - self.header.inset.right - self.header.lastMargin;
                if (height > maxHeight) {
                    maxHeight = height;
                }
                itemAttr.frame = frame;
                
            }
    
        }
        [attrs addObject:itemAttr];
        if (self.configureCellLayoutAttributes) {
            self.configureCellLayoutAttributes(self, itemAttr, j);
        }
    }
    self.columnSizes[@(0)] = @(maxHeight);
    self.itemsAttribute = [attrs copy];
}

- (BOOL)intersectsRectInExsitAttributes:(NSArray<FMCollectionLayoutAttributes *> *)attributes frame:(CGRect)frame verticle:(BOOL)verticle{
    for (FMCollectionLayoutAttributes *attr in attributes) {
        CGRect attrFrame = attr.frame;
        CGRect itemFrame = frame;
        if (!verticle) {
            attrFrame.size.height += self.lineSpace;
            itemFrame.size.width += self.itemSpace;
        } else {
            attrFrame.size.width += self.itemSpace;
            itemFrame.size.height += self.lineSpace;
        }
        if (CGRectIntersectsRect(attrFrame, itemFrame)) {
            return YES;
        }
    }
    return NO;
}

-(CGFloat)roundFloat:(CGFloat)value{
    return roundf(value*100)/100;
}

@end
