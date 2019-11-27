//
// Created by 王斌 on 2019-01-21.
// Copyright (c) 2019 Yamazhiki. All rights reserved.
//

#import "ModuleConfigurationProcessor.h"

@interface ModuleConfigurationProcessor ()
@property(readonly) NSBundle *appBundle;
@end

@implementation ModuleConfigurationProcessor {

}
- (instancetype)initWithAppDelegate:(Class)cls {
    self = [super init];
    if (self) {
        _appBundle = [NSBundle bundleForClass:cls];
    }
    return self;
}


@end