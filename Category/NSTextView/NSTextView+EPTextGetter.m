//
//  NSTextView+EPTextGetter.m
//  EasyProperty
//
//  Created by flicker317 on 15/10/14.
//  Copyright (c) 2015年 on github. All rights reserved.
//

#import "NSTextView+EPTextGetter.h"
#import "NSString+EPTextGetter.h"

@implementation NSTextView (EPTextGetter)

- (NSInteger)ep_currentCurseLocation {
    return [[[self selectedRanges] objectAtIndex:0] rangeValue].location;
}

- (EPTextResult *)ep_textResultOfCurrentLine {
    return [self.textStorage.string ep_textResultOfCurrentLineCurrentLocation:[self ep_currentCurseLocation]];
}

@end
