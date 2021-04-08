//
//  FMLayoutDebugLog.m
//  FMLayoutKit
//
//  Created by 周发明 on 2020/6/17.
//

#import "FMLayoutDebugLog.h"

BOOL FMLayoutDebugLogOpen = NO;

void FMLayoutLog(NSString *format){
#if DEBUG
    if (FMLayoutDebugLogOpen) {
        NSLog(@"%@", format);
    }
#endif
}

void FMLayoutOpenLog(){
    FMLayoutDebugLogOpen = YES;
}

void FMLayoutCloseLog(){
    FMLayoutDebugLogOpen = NO;
}

NSInteger FMLayoutRandomValue(NSInteger start, NSInteger end){
    NSInteger value = (arc4random() % (end - start + 1)) + start;
    return value;
}
