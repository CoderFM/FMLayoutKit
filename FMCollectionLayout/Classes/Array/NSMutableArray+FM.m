//
//  NSMutableArray+FM.m
//  TestDemo
//
//  Created by 周发明 on 17/7/17.
//  Copyright © 2017年 周发明. All rights reserved.
//

#import "NSMutableArray+FM.h"
#import <objc/runtime.h>

@implementation NSMutableArray (FM)

- (NSMutableArray *)convertSafety{
    if (![NSStringFromClass(self.class) isEqualToString:NSStringFromClass([FMSafetyMutableArray class])]) {
        return [FMSafetyMutableArray arrayWithArray:self];
    } else {
        return self;
    }
}

- (void)listenDidChange:(FMSafetyMutableArrayChangeBlock)changeBlock{
    FMSafetyMutableArray *arrM = (FMSafetyMutableArray *)self;
    arrM.changeBlock = changeBlock;
}

- (void)listenSyncDidChange:(FMSafetyMutableArrayChangeBlock)changeBlock{
    FMSafetyMutableArray *arrM = (FMSafetyMutableArray *)self;
    arrM.isSync = YES;
    arrM.changeBlock = changeBlock;
}

- (void)addTargetView:(id)target{
    if ([target respondsToSelector:@selector(reloadData)]){
        [self convertSafety];
        if ([self respondsToSelector:@selector(addTarget:)]) {
            [self performSelector:@selector(addTarget:) withObject:target];
        }
    }
}

@end
