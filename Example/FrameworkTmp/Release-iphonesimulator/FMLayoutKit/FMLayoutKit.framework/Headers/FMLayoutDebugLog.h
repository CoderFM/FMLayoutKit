//
//  FMLayoutDebugLog.h
//  FMLayoutKit
//
//  Created by 周发明 on 2020/6/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern void FMLayoutLog(NSString *format);
extern void FMLayoutOpenLog(void);
extern void FMLayoutCloseLog(void);
extern NSInteger FMLayoutRandomValue(NSInteger start, NSInteger end);

NS_ASSUME_NONNULL_END
