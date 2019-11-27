//
// Created by 王斌 on 2019-03-04.
// Copyright (c) 2019 AsiaInnovations. All rights reserved.
//

#import "AutoDescribe.h"


@implementation AutoDescribe {

}
- (instancetype)initWithCls:(Class)cls aProtocol:(Protocol *)aProtocol sel:(SEL)sel {
    self = [super init];
    if (self) {
        _cls = cls;
        _aProtocol = aProtocol;
        _sel = sel;
    }

    return self;
}

- (instancetype)initWithString:(NSString *)String {
    return nil;
}

+ (instancetype)describeWithCls:(Class)cls aProtocol:(Protocol *)aProtocol sel:(SEL)sel {
    return [[self alloc] initWithCls:cls aProtocol:aProtocol sel:sel];
}

@end