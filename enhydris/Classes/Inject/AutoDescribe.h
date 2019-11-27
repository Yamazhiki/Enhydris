//
// Created by 王斌 on 2019-03-04.
// Copyright (c) 2019 AsiaInnovations. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AutoDescribe : NSObject
@property(readonly) Class cls;
@property(readonly) Protocol *aProtocol;
@property(readonly) SEL sel;

- (instancetype)initWithString:(NSString *)String;

+ (instancetype)describeWithCls:(Class)cls aProtocol:(Protocol *)aProtocol sel:(SEL)sel;

@end