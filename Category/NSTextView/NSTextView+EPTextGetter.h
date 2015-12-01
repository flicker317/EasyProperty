//
//  NSTextView+EPTextGetter.h
//  EasyProperty
//
//  Created by flicker317 on 15/10/14.
//  Copyright (c) 2015年 on github. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class EPTextResult;

@interface NSTextView (EPTextGetter)

- (NSInteger)ep_currentCurseLocation;

- (EPTextResult *)ep_textResultOfCurrentLine;


@end
