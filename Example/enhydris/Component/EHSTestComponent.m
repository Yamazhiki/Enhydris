//
// Created by 王斌 on 2019/11/26.
// Copyright (c) 2019 Yamazhiki@outlook.com. All rights reserved.
//

#import <ModuleProvider.h>
#import "EHSTestComponent.h"
#import "EHSTestComponentType.h"


@implementation EHSTestComponent
+ (void)load {
    [ModuleProvider registerComponents:@[
            [ModuleDefinition definitionWithProtocol:@protocol(EHSTestComponentType)
                                       configuration:^NSArray<ModuleConfig *> * {
                                           return @[
                                                   [[ModuleConfig alloc] initWithCls:[self class] isAutoStartUp:YES]];
                                       }]
    ]];
}

- (instancetype)init {
    self = [super init];
    NSLog(@"EHSTestComponent init success");
    return self;
}
@end