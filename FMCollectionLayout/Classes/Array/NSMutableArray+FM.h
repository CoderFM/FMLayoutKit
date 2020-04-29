//
//  NSMutableArray+FM.h
//  TestDemo
//
//  Created by 周发明 on 17/7/17.
//  Copyright © 2017年 周发明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMSafetyMutableArray.h"

@interface NSMutableArray (FM)

- (NSMutableArray *)convertSafety;

- (void)listenDidChange:(FMSafetyMutableArrayChangeBlock)changeBlock;
- (void)listenSyncDidChange:(FMSafetyMutableArrayChangeBlock)changeBlock;

- (void)addTargetView:(id)target;

@end
