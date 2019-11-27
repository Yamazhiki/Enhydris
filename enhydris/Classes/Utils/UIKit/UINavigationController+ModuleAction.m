//
// Created by 王斌 on 2019-01-17.
// Copyright (c) 2019 Yamazhiki. All rights reserved.
//

#import "UINavigationController+ModuleAction.h"
#import "ModuleProvider.h"


@implementation UINavigationController (ModuleAction)
- (void)push:(Protocol *)moduleType animated:(BOOL)animated {
    id target = [ModuleProvider request:moduleType].object;
    if ([target isKindOfClass:[UIViewController class]]) {
        [self pushViewController:target animated:animated];
    }
}
@end