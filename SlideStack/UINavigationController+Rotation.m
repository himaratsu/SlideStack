//
//  UINavigationController+Rotation.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/21.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "UINavigationController+Rotation.h"

@implementation UINavigationController (Rotation)

- (NSUInteger)supportedInterfaceOrientations{
    
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
    
}



- (BOOL)shouldAutorotate{
    
    return [self.viewControllers.lastObject shouldAutorotate];
    
}



- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
    
}

@end
