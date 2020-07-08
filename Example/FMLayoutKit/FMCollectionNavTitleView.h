//
//  FMCollectionNavTitleView.h
//  FMCollectionLayout_Example
//
//  Created by 周发明 on 2020/4/9.
//  Copyright © 2020 周发明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FMLayoutKit/FMLayoutKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface FMCollectionNavTitleView : UICollectionReusableView<FMTeslaSuspensionHeightChangeDelegate>
@property(nonatomic, copy)NSArray *titles;
@property(nonatomic, copy)void(^clickBlock)(NSInteger tag);
- (void)selectWithIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
