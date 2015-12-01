//
//  EPProperty.m
//  EasyProperty
//
//  Created by flicker317 on 15/10/14.
//  Copyright (c) 2015年 on github. All rights reserved.
//

#import "EPProperty.h"
#import "EPTextResult.h"
#import "NSTextView+EPTextGetter.h"
#import "EPStringGenerator.h"

static EPProperty *sharedPlugin;
static NSString *enablePropertyKey = @"EPPropertyEnable";

@interface EPProperty()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic, assign) Class sourceTextViewClass;
@property (nonatomic, assign) BOOL enableProperty;

@end

@implementation EPProperty

+ (void)pluginDidLoad:(NSBundle *)plugin {
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

+ (instancetype)sharedPlugin {
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin {
    if (self = [super init]) {
        self.bundle = plugin;
        self.sourceTextViewClass = NSClassFromString(@"DVTSourceTextView");
        
        // 读取用户配置, 未设置时默认打开
        NSNumber *enable = [[NSUserDefaults standardUserDefaults] objectForKey:enablePropertyKey];
        if (enable) {
            self.enableProperty = enable.boolValue;
        } else {
            self.enableProperty = YES;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching:) name:NSApplicationDidFinishLaunchingNotification object:nil];
        
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textStorageDidChange:)
                                                 name:NSTextDidChangeNotification
                                               object:nil];
    [self addMenuItem];
}

- (void)textStorageDidChange:(NSNotification *)notification {
    id object = [notification object];
    if ([object isKindOfClass:self.sourceTextViewClass] && self.enableProperty) {
        NSTextView *textView = object;
        
        // 判断是否输入了快捷键
        EPTextResult *currentLineResult = [textView ep_textResultOfCurrentLine];
        if (![EPStringGenerator shouldTrigger:currentLineResult.string]) {
            return;
        }
        
        // 判断是否是在类的声明中, 以免影响到其他如 @synthesize 之类的属性
        NSInteger focus = [[textView.selectedRanges firstObject] rangeValue].location;
        NSString *text = [textView.textStorage string];
        if (![EPStringGenerator shouldTriggerAtIndex:focus withCode:text]) {
            return;
        }
        
        NSUInteger length = currentLineResult.string.length;
        NSRange range = NSMakeRange(textView.ep_currentCurseLocation - length, length);
        NSString *replacementString = [EPStringGenerator insertTextWithType:currentLineResult.string];
        NSInteger selectedLocation = [EPStringGenerator insertIndexWithType:currentLineResult.string];
        
        // 支持 undo/redo
        if ([textView shouldChangeTextInRange:range replacementString:replacementString]) {
            [textView replaceCharactersInRange:range withString:replacementString];
            [textView didChangeText];
            
            // 将光标定位到 type, 方便直接输入
            [textView setSelectedRange:NSMakeRange(range.location + selectedLocation, 8)];
        }
    }
}

// 添加菜单选项
- (void)addMenuItem {
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Enable EasyProperty" action:@selector(toggleMenuState:) keyEquivalent:@""];
        [actionMenuItem setTarget:self];
        [actionMenuItem setState:self.enableProperty ? NSOnState : NSOffState];
        
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}

- (void)toggleMenuState:(NSMenuItem *)item {
    self.enableProperty = !self.enableProperty;
    item.state = self.enableProperty ? NSOnState : NSOffState;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(self.enableProperty) forKey:enablePropertyKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end