//
//  FMLayoutHorizontalSection.h
//  FMCollectionLayout
//
//  Created by 郑桂华 on 2020/4/2.
//

#import <Foundation/Foundation.h>
#import "FMCollectionLayoutAttributes.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMLayoutHorizontalSection : NSObject

@property(nonatomic, strong)NSArray<FMCollectionLayoutAttributes *> *itemsAttribute;
@property(nonatomic, assign)NSInteger singleCount;
@property(nonatomic, assign)NSInteger realLines;
@end

NS_ASSUME_NONNULL_END
