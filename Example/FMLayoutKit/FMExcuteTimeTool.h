//
//  FMExcuteTimeTool.h
//  FMCollectionLayout_Example
//
//  Created by 周发明 on 2020/6/6.
//  Copyright © 2020 周发明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMExcuteTimeTool : NSObject

+ (void)excuteTime:(void(^)(void))excute;

@end

NS_ASSUME_NONNULL_END
