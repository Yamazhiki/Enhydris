//
// Created by 王斌 on 2019-03-04.
// Copyright (c) 2019 AsiaInnovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AutoDescribe;


@interface AutoInjectFactoryProcessor : NSObject
@property(readonly) NSArray<AutoDescribe *> *describes;
@end