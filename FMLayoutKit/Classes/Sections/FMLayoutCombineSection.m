//
//  FMLayoutCombineSection.m
//  FMLayoutKit
//
//  Created by 郑桂华 on 2020/7/12.
//

#import "FMLayoutCombineSection.h"
#import "FMCollectionLayoutAttributes.h"
#import "FMLayoutBaseSection+ConfigureBlock.h"

#import "FMLayoutHeader.h"

@interface FMLayoutCombineSection ()

@property(nonatomic, strong)NSArray *sections;

@end

@implementation FMLayoutCombineSection

- (id)copyWithZone:(NSZone *)zone{
    FMLayoutCombineSection *section = [super copyWithZone:zone];
    NSMutableArray *sections = [NSMutableArray array];
    for (FMLayoutBaseSection *subSection in self.sections) {
        [sections addObject:[subSection copy]];
    }
    section.sections = sections;
    return section;
}

- (NSInteger)itemCount{
    NSInteger count = 0;
    for (FMLayoutBaseSection *section in self.sections) {
        count += section.itemCount;
    }
    return count;
}

+ (instancetype)combineSections:(NSArray<FMLayoutBaseSection *> *)sections{
    FMLayoutCombineSection *section = [[FMLayoutCombineSection alloc] init];
    section.sections = sections;
    return section;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.column = 1;
        __weak typeof(self) weakSelf = self;
        [self setClickCellBlock:^(FMLayoutBaseSection * _Nonnull section, NSInteger item) {
            NSInteger start = 0;
            for (FMLayoutBaseSection *subSection in weakSelf.sections) {
                if (item < subSection.itemCount + start) {
                    if (subSection.clickCellBlock) {
                        subSection.clickCellBlock(subSection, item - start);
                    }
                    break;
                } else {
                    start += subSection.itemCount;
                }
            }
        }];
        [self setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
            NSInteger start = 0;
            for (FMLayoutBaseSection *subSection in weakSelf.sections) {
                if (item < subSection.itemCount + start) {
                    if (subSection.configureCellData) {
                        subSection.configureCellData(subSection, cell,item - start);
                    }
                    break;
                } else {
                    start += subSection.itemCount;
                }
            }
        }];
    }
    return self;
}

- (void)prepareItems{
    [self resetcolumnSizes];
    CGFloat startOffset = self.direction == FMLayoutDirectionVertical ? self.firstItemStartY : self.firstItemStartX;
    CGFloat offset = startOffset;
    NSInteger start = 0;
    for (int i = 0; i < self.sections.count; i++) {
        FMLayoutBaseSection *section = self.sections[i];
        section.header = nil;
        section.footer = nil;
        section.background = nil;
        section.direction = self.direction;
        section.collectionView = self.collectionView;
        section.sectionOffset = offset;
        section.handleType = self.handleType;
        section.changeOffset = self.changeOffset;
        section.indexPath = self.indexPath;
        [section handleLayout];
        offset += section.sectionSize;
        [section.itemsAttribute enumerateObjectsUsingBlock:^(FMCollectionLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.indexPath = [NSIndexPath indexPathForItem:idx + start inSection:self.indexPath.section];
        }];
        section.changeOffset = 0;
        section.handleType = FMLayoutHandleTypeReLayout;
        section.hasHandle = YES;
        start += section.itemCount;
    }
    self.columnSizes[@0] = @(offset - startOffset);
}

- (NSArray *)showLayoutAttributesInRect:(CGRect)rect{
    NSMutableArray *attrs = [NSMutableArray array];
    if ([self intersectsRect:rect]) {
        if (self.headerAttribute) {
            UICollectionViewLayoutAttributes *showHeaderAttr = [self showHeaderLayout];
            if (CGRectIntersectsRect(rect, showHeaderAttr.frame)) {
                [attrs addObject:showHeaderAttr];
            }
        }
        if (self.footerAttribute) {
            if (CGRectIntersectsRect(rect, self.footerAttribute.frame)) {
                [attrs addObject:self.footerAttribute];
            }
        }
        if (self.bgAttribute) {
            if (CGRectIntersectsRect(rect, self.bgAttribute.frame)) {
                [attrs addObject:self.bgAttribute];
            }
        }
        for (FMLayoutBaseSection *section in self.sections) {
            NSArray *subAttrs = [section showLayoutAttributesInRect:rect];
            [attrs addObjectsFromArray:subAttrs];
        }
    } else {
        if (self.header.type == FMLayoutHeaderTypeSuspensionAlways) {
            if (self.headerAttribute) {
                UICollectionViewLayoutAttributes *showHeaderAttr = [self showHeaderLayout];
                if (CGRectIntersectsRect(rect, showHeaderAttr.frame)) {
                    [attrs addObject:showHeaderAttr];
                }
            }
        }
    }
    return attrs;
}

- (UICollectionViewCell *)dequeueReusableCellForIndexPath:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView{
    NSInteger start = 0;
    for (FMLayoutBaseSection *section in self.sections) {
        if (indexPath.item < section.itemCount + start) {
            return [section dequeueReusableCellForIndexPath:indexPath collectionView:collectionView];
        } else {
            start = section.itemCount;
        }
    }
    @throw [NSException exceptionWithName:@"FMLayoutCombineSection instance dequeueReusableCellForIndexPath" reason:@"FMLayoutCombineSection" userInfo:nil];
}

- (void)registerCellsWithCollectionView:(UICollectionView *)collectionView{
    for (FMLayoutBaseSection *section in self.sections) {
        [section registerCellsWithCollectionView:collectionView];
    }
}

- (CGFloat)crossSingleSectionSize{
    CGFloat maxSize = self.direction == FMLayoutDirectionVertical ? self.firstItemStartY : self.firstItemStartX;
    for (FMLayoutBaseSection *section in self.sections) {
        CGFloat sectionSize = [section crossSingleSectionSize];
        if (maxSize < sectionSize) {
            maxSize = sectionSize;
        }
    }
    return maxSize;
}

- (void)exchangeObjectAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex{
    NSMutableArray *get;
    NSMutableArray *inset;
    NSInteger getIndex = 0;
    NSInteger insetIndex = 0;
    NSInteger start = 0;
    for (FMLayoutBaseSection *section in self.sections) {
        if (index < start + section.itemCount) {
            if (!get) {
                get = section.itemDatas;
                getIndex = index - start;
            }
        }
        if (toIndex < start + section.itemCount) {
            if (!inset) {
                inset = section.itemDatas;
                insetIndex = toIndex - start;
            }
        }
        if (get && inset) {
            break;
        }
        start += section.itemCount;
    }
    id getObj = [get objectAtIndex:getIndex];
    id insetObj = [inset objectAtIndex:insetIndex];
    if (get == inset) {
        [get exchangeObjectAtIndex:getIndex withObjectAtIndex:insetIndex];
    } else {
        [get replaceObjectAtIndex:getIndex withObject:insetObj];
        [inset replaceObjectAtIndex:insetIndex withObject:getObj];
    }
}

@end
