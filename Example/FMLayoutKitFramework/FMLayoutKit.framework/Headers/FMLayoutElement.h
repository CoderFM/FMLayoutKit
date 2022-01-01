//
//  FMLayoutElement.h
//  FMLayoutKit
//
//  Created by 周发明 on 2020/4/1.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMLayoutElement : NSObject<NSCopying>

@property(nonatomic, copy)NSString *reuseIdentifier;
@property(nonatomic, assign)BOOL isNib;
@property(nonatomic, weak)Class viewClass;///视图的类

+ (instancetype)elementWithViewClass:(Class)vCalss;
+ (instancetype)elementWithViewClass:(Class)vCalss isNib:(BOOL)isNib;
+ (instancetype)elementWithViewClass:(Class)vCalss isNib:(BOOL)isNib reuseIdentifier:(NSString *)reuseIdentifier;

- (void)registerElementWithCollection:(UICollectionView *)collectionView;

@end

NS_ASSUME_NONNULL_END
