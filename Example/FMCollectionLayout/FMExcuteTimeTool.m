//
//  FMExcuteTimeTool.m
//  FMCollectionLayout_Example
//
//  Created by 郑桂华 on 2020/6/6.
//  Copyright © 2020 周发明. All rights reserved.
//

#import "FMExcuteTimeTool.h"

@implementation FMExcuteTimeTool

+ (void)excuteTime:(void(^)(void))excute{
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    !excute?:excute();
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent() - start;
    NSLog(@"该block执行耗时 %f ms", end *1000.0);
}

@end
