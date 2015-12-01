//
//  EPStringGenerator.m
//  EasyProperty
//
//  Created by flicker317 on 15/10/14.
//  Copyright (c) 2015年 on github. All rights reserved.
//

#import "EPStringGenerator.h"
#import "NSString+EPTextGetter.h"

@interface EPStringGenerator ()
@property (nonatomic, strong) NSDictionary *propertyForKeywords;
@property (nonatomic, strong) NSArray *propertyList;
@property (nonatomic, strong) NSDictionary *indexForKeywords;

+ (EPStringGenerator *)sharedInstance;
@end

@implementation EPStringGenerator

+ (EPStringGenerator *)sharedInstance {
    static dispatch_once_t onceToken;
    static EPStringGenerator *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EPStringGenerator alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.propertyForKeywords = @{
            @"@s": @"@property (nonatomic, strong) <#type#> *<#value#>;",
            @"@a": @"@property (nonatomic, assign) <#type#> <#value#>;",
            @"@w": @"@property (nonatomic, weak) <#type#> *<#value#>;",
            @"@d": @"@property (nonatomic, weak) id<<#type#>> <#value#>;",
            @"@c": @"@property (nonatomic, copy) <#type#> *<#value#>;",

            @"@rs": @"@property (nonatomic, strong, readonly) <#type#> *<#value#>;",
            @"@ra": @"@property (nonatomic, assign, readonly) <#type#> <#value#>;",
            @"@rw": @"@property (nonatomic, weak, readonly) <#type#> *<#value#>;",
            @"@rc": @"@property (nonatomic, copy, readonly) <#type#> *<#value#>;",

            @"@xs": @"@property (nonatomic, strong, readwrite) <#type#> *<#value#>;",
            @"@xa": @"@property (nonatomic, assign, readwrite) <#type#> <#value#>;",
            @"@xw": @"@property (nonatomic, weak, readwrite) <#type#> *<#value#>;",
            @"@xc": @"@property (nonatomic, copy, readwrite) <#type#> *<#value#>;",

            @"@iw": @"@property (nonatomic, weak) IBOutlet <#type#> *<#value#>"
        };
        self.indexForKeywords = @{
            @"@s": @30,
            @"@a": @30,
            @"@w": @28,
            @"@d": @31,
            @"@c": @28,
            
            @"@rs": @40,
            @"@ra": @40,
            @"@rw": @38,
            @"@rc": @38,
            
            @"@xs": @41,
            @"@xa": @41,
            @"@xw": @39,
            @"@xc": @39,
            
            @"@iw": @37,
        };
        
        NSAssert([self.indexForKeywords.allKeys isEqualToArray:self.propertyForKeywords.allKeys], @"Key 需要匹配");
        
        self.propertyList = self.propertyForKeywords.allKeys;
    }
    return self;
}

- (NSString *)propertyForKeyworks:(NSString *)keywords {
    return [self.propertyForKeywords objectForKey:keywords];
}

- (NSInteger)indexForKeyworks:(NSString *)keywords {
    return [[self.indexForKeywords objectForKey:keywords] integerValue];
}

+ (BOOL)shouldTrigger:(NSString *)currentLineResult {
    if (currentLineResult.length == 0 || currentLineResult.length > 3) {
        return NO;
    }
    return [[EPStringGenerator sharedInstance].propertyList containsObject:currentLineResult];
}

+ (NSString *)insertTextWithType:(NSString *)type {
    return [[EPStringGenerator sharedInstance] propertyForKeyworks:type];
}

+ (NSInteger)insertIndexWithType:(NSString *)type {
    return [[EPStringGenerator sharedInstance] indexForKeyworks:type];
}

+ (BOOL)shouldTriggerAtIndex:(NSInteger)index withCode:(NSString *)text {
    NSRange range = NSMakeRange(0, index - 1);
    while (YES) {
        range = [text rangeOfString:@"\n@" options:NSBackwardsSearch range:range];
        if (range.location == NSNotFound) {
            break;
        }
        NSString *substring = [text substringFromIndex:range.location];
        if ([substring hasPrefix:@"\n@interface"] ||
            [substring hasPrefix:@"\n@protocol"]) {
            return YES;
        }
        if ([substring hasPrefix:@"\n@end"] ||
            [substring hasPrefix:@"\n@implementation"]) {
            return NO;
        }
        range.length = range.location;
        range.location = 0;
    }
    
    return NO;
}

@end
