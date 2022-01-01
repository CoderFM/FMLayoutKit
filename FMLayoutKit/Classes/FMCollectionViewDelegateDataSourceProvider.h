//
//  FMCollectionViewDelegateDataSourceProvider.h
//  FMLayoutKit
//
//  Created by 郑桂华 on 2021/3/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FMLayoutBaseSection;
@interface FMCollectionViewDelegateDataSourceProvider : NSObject<UICollectionViewDelegate, UICollectionViewDataSource>

///重写了set get 目标指向->layout.sections
@property(nonatomic, strong)NSMutableArray<FMLayoutBaseSection *> *sections;

@end

NS_ASSUME_NONNULL_END
