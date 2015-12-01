//
//  EPStringGenerator.h
//  EasyProperty
//
//  Created by flicker317 on 15/10/14.
//  Copyright (c) 2015年 on github. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPStringGenerator : NSObject

/**
 *  判断是否正在输入缩写
 *
 *  @param currentLineResult [in]当前输入行的内容
 *
 *  @return 匹配成功则返回 YES
 */
+ (BOOL)shouldTrigger:(NSString *)currentLineResult;

/**
 *  判断当前输入是否在类的声明中
 *
 *  @param index [in]光标所处位置
 *  @param text  [in]代码
 *
 *  @return 如果正在类声明区域中, 则返回YES
 */
+ (BOOL)shouldTriggerAtIndex:(NSInteger)index withCode:(NSString *)text;

/**
 *  将输入的缩写转成对应的代码
 *
 *  @param type [in]缩写
 *
 *  @return 转换后的代码
 */
+ (NSString *)insertTextWithType:(NSString *)type;

/**
 *  根据缩写, 返回用代码替换缩写后光标所在的位置
 *
 *  @param type [in]缩写
 *
 *  @return 光标位置
 */
+ (NSInteger)insertIndexWithType:(NSString *)type;

@end
