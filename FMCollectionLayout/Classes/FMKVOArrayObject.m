//
//  FMKVOArrayObject.m
//  FMCollectionLayout
//
//  Created by 郑桂华 on 2020/6/5.
//

#import "FMKVOArrayObject.h"

@implementation FMKVOArrayObject

- (void)dealloc{
    NSLog(@"FMKVOArrayObject dealloc");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.targetArray = [NSMutableArray array];
    }
    return self;
}

@end
