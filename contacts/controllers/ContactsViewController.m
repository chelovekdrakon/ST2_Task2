//
//  ContactsViewController.m
//  contacts
//
//  Created by Фёдор Морев on 6/9/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import "ContactsViewController.h"

NSString * const defaultCellReuseId = @"default";

@interface ContactsViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Контакты";
    
    self.model = @[@"1", @"2", @"3", @"4", @"5"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:defaultCellReuseId];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"ContactsViewController appeared");
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"");
    return nil;
}

@end
