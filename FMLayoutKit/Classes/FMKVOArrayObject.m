//
//  FMKVOArrayObject.m
//  FMCollectionLayout
//
//  Created by 周发明 on 2020/6/5.
//

#import "FMKVOArrayObject.h"
#import "FMLayoutDebugLog.h"

@implementation FMKVOArrayObject

- (void)dealloc{
    FMLayoutLog(@"FMKVOArrayObject dealloc");
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
