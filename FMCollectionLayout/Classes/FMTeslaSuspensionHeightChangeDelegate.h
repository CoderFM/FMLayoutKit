//
//  FMTeslaSuspensionHeightChangeDelegate.h
//  FMCollectionLayout
//
//  Created by 郑桂华 on 2020/5/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FMTeslaSuspensionHeightChangeDelegate <NSObject>

- (void)teslaSuspensionHeaderShouldShowHeight:(CGFloat)showHeight;

@end

NS_ASSUME_NONNULL_END
