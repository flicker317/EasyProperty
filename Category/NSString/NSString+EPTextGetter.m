//
//  NSString+EPTextGetter.m
//  EasyProperty
//
//  Created by flicker317 on 15/10/14.
//  Copyright (c) 2015年 on github. All rights reserved.
//

#import "NSString+EPTextGetter.h"
#import "EPTextResult.h"

@implementation NSString (EPTextGetter)

- (EPTextResult *)ep_textResultOfCurrentLineCurrentLocation:(NSInteger)location {
    NSInteger curseLocation = location;
    NSRange range = NSMakeRange(0, curseLocation);
    NSRange thisLineRange = [self rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch range:range];
    
    NSString *line = nil;
    if (thisLineRange.location != NSNotFound) {
        NSRange lineRange = NSMakeRange(thisLineRange.location + 1, curseLocation - thisLineRange.location - 1);
        if (lineRange.location < [self length] && NSMaxRange(lineRange) < [self length]) {
            line = [self substringWithRange:lineRange];
            return [[EPTextResult alloc] initWithRange:lineRange string:line];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

@end
