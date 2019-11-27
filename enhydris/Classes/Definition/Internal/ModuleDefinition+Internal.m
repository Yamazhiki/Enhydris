//
// Created by 王斌 on 2019-01-15.
// Copyright (c) 2019 Yamazhiki. All rights reserved.
//

#import "ModuleDefinition+Internal.h"


@implementation ModuleDefinition (Internal)
- (NSString *)key {
    return NSStringFromProtocol(self.aProtocol);
}
@end