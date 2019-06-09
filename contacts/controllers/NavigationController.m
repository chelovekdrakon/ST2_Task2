//
//  NavigationController.m
//  contacts
//
//  Created by Фёдор Морев on 6/9/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"NavigationController loaded");
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"NavigationController appeared");
}

@end
