//
// Created by 王斌 on 2019-01-22.
// Copyright (c) 2019 Yamazhiki. All rights reserved.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "ModuleSetup.h"
#import "ModuleConfigCollector.h"
#import "ModuleFactory.h"

#if TARGET_OS_IPHONE || TARGET_OS_TV
#define ApplicationClass [UIApplication class]
#elif TARGET_OS_MAC
#define ApplicationClass [NSApplication class]
#endif

#if TARGET_OS_IPHONE || TARGET_OS_TV
#define ApplicationDidFinishLaunchingNotification UIApplicationDidFinishLaunchingNotification
#elif TARGET_OS_MAC
#define ApplicationDidFinishLaunchingNotification NSApplicationDidFinishLaunchingNotification
#endif

@implementation ModuleSetup

+ (void)load {
    //[self swizzleSetDelegateMethodOnApplicationClass];
}

+ (void)swizzleSetDelegateMethodOnApplicationClass {
    SEL sel = @selector(setDelegate:);
    Method method = class_getInstanceMethod(ApplicationClass, sel);

    void (*originalImp)(id, SEL, id) = (void (*)(id, SEL, id)) method_getImplementation(method);

    IMP adjustedImp = imp_implementationWithBlock(^(id instance, id delegate) {
        if (!delegate) {
            originalImp(instance, sel, delegate);
            return;
        }

        ModuleConfigCollector *configCollector = [[ModuleConfigCollector alloc] initWithAppDelegate:delegate];
        [ModuleFactory.defaultFactory combineWithObtainedConfigs:configCollector.retrieveConfig];
        originalImp(instance, sel, delegate);
    });

    method_setImplementation(method, adjustedImp);
}
@end