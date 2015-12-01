//
//  EPTextResult.m
//  EasyProperty
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

#import "EPTextResult.h"

@implementation EPTextResult

- (instancetype)initWithRange:(NSRange)range string:(NSString *)string {
    if (self = [super init]) {
        _range = range;
        _string = string;
    }
    return self;
}

@end
