//
//  NSString+EPTextGetter.h
//  EasyProperty
//
//  Created by flicker317 on 15/10/14.
//  Copyright (c) 2015年 on github. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EPTextResult;

@interface NSString (EPTextGetter)

- (EPTextResult *)ep_textResultOfCurrentLineCurrentLocation:(NSInteger)location;

@end
