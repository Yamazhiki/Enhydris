//
// Created by 王斌 on 2019-03-04.
// Copyright (c) 2019 AsiaInnovations. All rights reserved.
//

#import <objc/runtime.h>
#import "AutoInjectFactoryProcessor.h"
#import "PropertyProcessor.h"
#import "AutoDescribe.h"

@interface AutoInjectFactoryProcessor ()
@property(readonly) Class cls;
@end


@implementation AutoInjectFactoryProcessor {

}

- (instancetype)initWithClass:(Class)clz {
    self = [super init];
    if (self) {
        _cls = clz;
    }
    return self;
}

- (NSArray<AutoDescribe *> *)describes {
    return [PropertyProcessor describesForClass:self.cls];
}


@end