//
//  FMSaveMutableArray.m
//  TestDemo
//
//  Created by 周发明 on 17/7/17.
//  Copyright © 2017年 周发明. All rights reserved.
//

#import "FMSafetyMutableArray.h"

@interface FMSafetyMutableArray ()

@property(nonatomic, strong)dispatch_queue_t safetyQueue;

@property(nonatomic, strong)NSMutableArray *inwardArrM;

@property(nonatomic, weak)id target;

@end

@implementation FMSafetyMutableArray

+ (instancetype)arrayWithArray:(NSArray *)array{
    FMSafetyMutableArray *safeArray = [[self alloc] init];
    [safeArray.inwardArrM addObjectsFromArray:array];
    return safeArray;
}

- (void)addTarget:(id)target{
    self.target = target;
    __weak typeof(self) weakSelf =  self;
    self.changeBlock = ^(NSIndexSet *indexes, FMSafetyMutableArrayChangeType type){
        if ([weakSelf.target respondsToSelector:@selector(reloadData)]) {
            [weakSelf.target reloadData];
        }
    };
}

- (void)addObject:(id)anObject{
    if (self.isSync) {
        if (anObject == nil) {
            return;
        }
        [self.inwardArrM addObject:anObject];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:self.inwardArrM.count - 1];
        [self syncChangeBlock:set type:FMSafetyMutableArrayChangeAddType];
        return;
    }
    dispatch_async(self.safetyQueue, ^{
        if (anObject == nil) {
            return;
        }
        [self.inwardArrM addObject:anObject];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:self.inwardArrM.count - 1];
        [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeAddType];
    });
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
    if (self.isSync) {
        if (index > self.inwardArrM.count - 1 || anObject == nil) {
            return;
        }
        [self.inwardArrM insertObject:anObject atIndex:index];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
        [self syncChangeBlock:set type:FMSafetyMutableArrayChangeAddType];
        return;
    }
    dispatch_async(self.safetyQueue, ^{
        if (index > self.inwardArrM.count - 1 || anObject == nil) {
            return;
        }
        [self.inwardArrM insertObject:anObject atIndex:index];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
        [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeAddType];
    });
}

- (void)removeLastObject{
    if (self.isSync) {
        if (self.inwardArrM.count == 0) {
            return;
        }
        [self.inwardArrM removeLastObject];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:self.inwardArrM.count];
        [self syncChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
        return;
    }
    dispatch_async(self.safetyQueue, ^{
        if (self.inwardArrM.count == 0) {
            return;
        }
        [self.inwardArrM removeLastObject];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:self.inwardArrM.count];
        [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
    });
}

- (void)removeObjectAtIndex:(NSUInteger)index{
    if (self.isSync) {
        if (index > self.inwardArrM.count - 1) {
            return;
        }
        [self.inwardArrM removeObjectAtIndex:index];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
        [self syncChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
        return;
    }
    dispatch_async(self.safetyQueue, ^{
        if (index > self.inwardArrM.count - 1) {
            return;
        }
        [self.inwardArrM removeObjectAtIndex:index];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
        [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
    });
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    if (self.isSync) {
        if (index > self.inwardArrM.count - 1 || anObject == nil) {
            return;
        }
        [self.inwardArrM replaceObjectAtIndex:index withObject:anObject];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
        [self syncChangeBlock:set type:FMSafetyMutableArrayChangeReplaceType];
        return;
    }
    dispatch_async(self.safetyQueue, ^{
        if (index > self.inwardArrM.count - 1 || anObject == nil) {
            return;
        }
        [self.inwardArrM replaceObjectAtIndex:index withObject:anObject];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
        [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeReplaceType];
    });
}

- (NSUInteger)count{
    return self.inwardArrM.count;
}

- (id)objectAtIndex:(NSUInteger)index{
    if (index > self.inwardArrM.count - 1) {
        return nil;
    }
    return [self.inwardArrM objectAtIndex:index];
}

- (void)addObjectsFromArray:(NSArray *)otherArray{
    if (self.isSync) {
        [self.inwardArrM addObjectsFromArray:otherArray];
        NSIndexSet *indexs = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.inwardArrM.count - otherArray.count, otherArray.count)];
        [self syncChangeBlock:indexs type:FMSafetyMutableArrayChangeAddType];
        return;
    }
    dispatch_async(self.safetyQueue, ^{
        [self.inwardArrM addObjectsFromArray:otherArray];
        NSIndexSet *indexs = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.inwardArrM.count - otherArray.count, otherArray.count)];
        [self asyncMianChangeBlock:indexs type:FMSafetyMutableArrayChangeAddType];
    });
}

- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2{
    if (self.isSync) {
        if (idx1 >= self.inwardArrM.count || idx2 >= self.inwardArrM.count) {
            return;
        }
        [self.inwardArrM exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        [set addIndex:idx1];
        [set addIndex:idx2];
        [self syncChangeBlock:set type:FMSafetyMutableArrayChangeReplaceType];
        return;
    }
    dispatch_async(self.safetyQueue, ^{
        if (idx1 >= self.inwardArrM.count || idx2 >= self.inwardArrM.count) {
            return;
        }
        [self.inwardArrM exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        [set addIndex:idx1];
        [set addIndex:idx2];
        [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeReplaceType];
    });
}
- (void)removeAllObjects{
    if (self.isSync) {
        if (self.inwardArrM.count == 0) {
            return;
        }
        NSUInteger count = self.inwardArrM.count;
        [self.inwardArrM removeAllObjects];
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, count)];
        [self syncChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
        return;
    }
    dispatch_async(self.safetyQueue, ^{
        if (self.inwardArrM.count == 0) {
            return;
        }
        NSUInteger count = self.inwardArrM.count;
        [self.inwardArrM removeAllObjects];
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, count)];
        [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
    });
}
- (void)removeObject:(id)anObject inRange:(NSRange)range{
    if (self.isSync) {
        if (![self.inwardArrM containsObject:anObject]) {
            return;
        }
        NSInteger index = [self.inwardArrM indexOfObject:anObject];
        if (index < range.location || index > range.location + range.length) {
            return;
        }
        [self.inwardArrM removeObjectAtIndex:index];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
        [self syncChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
        return;
    }
    dispatch_async(self.safetyQueue, ^{
        if (![self.inwardArrM containsObject:anObject]) {
            return;
        }
        NSInteger index = [self.inwardArrM indexOfObject:anObject];
        if (index < range.location || index > range.location + range.length) {
            return;
        }
        [self.inwardArrM removeObjectAtIndex:index];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
        [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
    });
}

- (void)removeObject:(id)anObject{
    if (self.isSync) {
        if (![self.inwardArrM containsObject:anObject]) {
            return;
        }
        NSInteger index = [self.inwardArrM indexOfObject:anObject];
        [self.inwardArrM removeObjectAtIndex:index];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
        [self syncChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
        return;
    }
    dispatch_async(self.safetyQueue, ^{
        if (![self.inwardArrM containsObject:anObject]) {
            return;
        }
        NSInteger index = [self.inwardArrM indexOfObject:anObject];
        [self.inwardArrM removeObjectAtIndex:index];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
        [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
    });
}

- (void)removeObjectsInArray:(NSArray<id> *)otherArray{
    if (otherArray == nil || otherArray.count == 0) {
        return;
    }
    if (self.isSync) {
        for (int i = 0; i < otherArray.count; i++) {
            id obj = otherArray[i];
            if (![self.inwardArrM containsObject:obj]) {
                    continue;
            }
            NSUInteger index = [self.inwardArrM indexOfObject:obj];
            [self.inwardArrM removeObjectAtIndex:index];
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
            [self syncChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
        }
        return;
    }
    dispatch_async(self.safetyQueue, ^{
        for (int i = 0; i < otherArray.count; i++) {
            id obj = otherArray[i];
            if (![self.inwardArrM containsObject:obj]) {
                    continue;
            }
            NSUInteger index = [self.inwardArrM indexOfObject:obj];
            [self.inwardArrM removeObjectAtIndex:index];
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
            [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
        }
    });
}

- (void)removeObjectsInRange:(NSRange)range{
    if (self.isSync) {
        if (range.location >= self.inwardArrM.count) {
            return;
        }
        NSInteger lastLength = self.inwardArrM.count-1-range.location;
        if (lastLength > range.length) {
            lastLength = range.length;
        }
        NSRange lastRange = NSMakeRange(range.location, lastLength);
        [self.inwardArrM removeObjectsInRange:lastRange];
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:lastRange];
        [self syncChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
        return;
    }
    dispatch_async(self.safetyQueue, ^{
        if (range.location >= self.inwardArrM.count) {
            return;
        }
        NSInteger lastLength = self.inwardArrM.count-1-range.location;
        if (lastLength > range.length) {
            lastLength = range.length;
        }
        NSRange lastRange = NSMakeRange(range.location, lastLength);
        [self.inwardArrM removeObjectsInRange:lastRange];
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:lastRange];
        [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
    });
}
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<id> *)otherArray range:(NSRange)otherRange{
    if (self.isSync) {
        if (range.location >= self.inwardArrM.count || otherRange.location >= otherArray.count) {
            return;
        }
        NSInteger lastLength = self.inwardArrM.count-1-range.location;
        if (lastLength > range.length) {
            lastLength = range.length;
        }
        NSRange lastRange = NSMakeRange(range.location, lastLength);
        if (otherArray == nil) {
            [self.inwardArrM removeObjectsInRange:lastRange];
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:lastRange];
            [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
        } else {
            [self.inwardArrM replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
            [self syncChangeBlock:nil type:FMSafetyMutableArrayChangeOtherType];
        }
        return;
    }
    dispatch_async(self.safetyQueue, ^{
        if (range.location >= self.inwardArrM.count || otherRange.location >= otherArray.count) {
            return;
        }
        NSInteger lastLength = self.inwardArrM.count-1-range.location;
        if (lastLength > range.length) {
            lastLength = range.length;
        }
        NSRange lastRange = NSMakeRange(range.location, lastLength);
        if (otherArray == nil) {
            [self.inwardArrM removeObjectsInRange:lastRange];
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:lastRange];
            [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
        } else {
            [self.inwardArrM replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
            [self asyncMianChangeBlock:nil type:FMSafetyMutableArrayChangeOtherType];
        }
    });
}
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<id> *)otherArray{
    if (self.isSync) {
        if (range.location >= self.inwardArrM.count || otherArray == nil || otherArray.count == 0) {
            return;
        }
        NSInteger lastLength = self.inwardArrM.count-1-range.location;
        if (lastLength > range.length) {
            lastLength = range.length;
        }
        NSRange lastRange = NSMakeRange(range.location, lastLength);
        [self.inwardArrM removeObjectsInRange:lastRange];
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:lastRange];
        [self syncChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
        return;
    }
    dispatch_async(self.safetyQueue, ^{
        if (range.location >= self.inwardArrM.count || otherArray == nil || otherArray.count == 0) {
            return;
        }
        NSInteger lastLength = self.inwardArrM.count-1-range.location;
        if (lastLength > range.length) {
            lastLength = range.length;
        }
        NSRange lastRange = NSMakeRange(range.location, lastLength);
        [self.inwardArrM removeObjectsInRange:lastRange];
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:lastRange];
        [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
    });
}
- (void)setArray:(NSArray<id> *)otherArray{
    if (self.isSync) {
        if (otherArray == nil) {
            return;
        }
        [self.inwardArrM removeAllObjects];
        [self.inwardArrM addObjectsFromArray:otherArray];
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.inwardArrM.count)];
        [self syncChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
        return;
    }
    dispatch_async(self.safetyQueue, ^{
        if (otherArray == nil) {
            return;
        }
        [self.inwardArrM removeAllObjects];
        [self.inwardArrM addObjectsFromArray:otherArray];
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.inwardArrM.count)];
        [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
    });
}

- (void)sortUsingFunction:(NSInteger (NS_NOESCAPE *)(id,  id, void * _Nullable))compare context:(nullable void *)context{
    if (self.isSync) {
        [self.inwardArrM sortUsingFunction:compare context:context];
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.inwardArrM.count)];
        [self syncChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
        return;
    }
    dispatch_async(self.safetyQueue, ^{
        [self.inwardArrM sortUsingFunction:compare context:context];
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.inwardArrM.count)];
        [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
    });
}

- (void)sortUsingSelector:(SEL)comparator{
    if (self.isSync) {
        [self.inwardArrM sortUsingSelector:comparator];
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.inwardArrM.count)];
        [self syncChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
        return;
    }
    dispatch_async(self.safetyQueue, ^{
        [self.inwardArrM sortUsingSelector:comparator];
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.inwardArrM.count)];
        [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeDeleteType];
    });
}

- (void)insertObjects:(NSArray<id> *)objects atIndexes:(NSIndexSet *)indexes{
    if (self.isSync) {
        
    }
    dispatch_async(self.safetyQueue, ^{
        __block NSInteger index = 0;
        NSInteger minIndex = MIN(objects.count, indexes.count);
        [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            if (index > minIndex) {
                *stop = YES;
            }
            if (idx <= self.inwardArrM.count) {
                id obj = objects[index];
                [self.inwardArrM insertObject:obj atIndex:idx];
                NSIndexSet *set = [NSIndexSet indexSetWithIndex:idx];
                [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeAddType];
            }
            index += 1;
        }];
    });
}
- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes{
    
    dispatch_async(self.safetyQueue, ^{
        NSMutableIndexSet *sets = [NSMutableIndexSet indexSet];
        [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx < self.inwardArrM.count) {
                [sets addIndex:idx];
            }
        }];
        [self.inwardArrM removeObjectsAtIndexes:sets];
        [self asyncMianChangeBlock:sets type:FMSafetyMutableArrayChangeDeleteType];
    });
}
- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray<id> *)objects{
    __block NSInteger index = 0;
    NSInteger minIndex = MIN(objects.count, indexes.count);
    dispatch_async(self.safetyQueue, ^{
        [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            if (index > minIndex) {
                *stop = YES;
            }
            if (idx < self.inwardArrM.count) {
                id obj = objects[index];
                [self.inwardArrM replaceObjectAtIndex:idx withObject:obj];
                NSIndexSet *set = [NSIndexSet indexSetWithIndex:idx];
                [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeReplaceType];
            }
        }];
    });
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0){
    dispatch_async(self.safetyQueue, ^{
        if (idx >= self.inwardArrM.count){
            return;
        }
        [self.inwardArrM replaceObjectAtIndex:idx withObject:obj];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:idx];
        [self asyncMianChangeBlock:set type:FMSafetyMutableArrayChangeReplaceType];
    });
}

- (void)sortUsingComparator:(NSComparator NS_NOESCAPE)cmptr NS_AVAILABLE(10_6, 4_0){
    dispatch_async(self.safetyQueue, ^{
        [self.inwardArrM sortUsingComparator:cmptr];
        NSIndexSet *sets = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.inwardArrM.count)];
        [self asyncMianChangeBlock:sets type:FMSafetyMutableArrayChangeReplaceType];
    });
}
- (void)sortWithOptions:(NSSortOptions)opts usingComparator:(NSComparator NS_NOESCAPE)cmptr NS_AVAILABLE(10_6, 4_0){
    dispatch_async(self.safetyQueue, ^{
        [self.inwardArrM sortWithOptions:opts usingComparator:cmptr];
        NSIndexSet *sets = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.inwardArrM.count)];
        [self asyncMianChangeBlock:sets type:FMSafetyMutableArrayChangeReplaceType];
    });
}

- (void)asyncMianChangeBlock:(NSIndexSet *)set type:(FMSafetyMutableArrayChangeType)type{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.changeBlock) {
            self.changeBlock(set, type);
        }
    });
}

- (void)syncChangeBlock:(NSIndexSet *)set type:(FMSafetyMutableArrayChangeType)type{
    if (self.changeBlock) {
        self.changeBlock(set, type);
    }
}

- (dispatch_queue_t)safetyQueue{
    if (_safetyQueue == nil) {
        _safetyQueue = dispatch_queue_create("FMSafetyMutableArraySafetyQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _safetyQueue;
}

- (NSMutableArray *)inwardArrM{
    if (_inwardArrM == nil) {
        _inwardArrM = [NSMutableArray array];
    }
    return _inwardArrM;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@", self.inwardArrM];
}

@end
