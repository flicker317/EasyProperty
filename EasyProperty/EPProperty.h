//
//  EPProperty.h
//  EasyProperty
//
//  Created by flicker317 on 15/10/14.
//  Copyright (c) 2015年 on github. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface EPProperty : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;

@end