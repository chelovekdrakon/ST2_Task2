//
//  DetailViewController.m
//  contacts
//
//  Created by Фёдор Морев on 6/11/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import "DetailViewController.h"

NSString * const cellReuseId = @"phoneNumberCell";

@interface DetailViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseId];
    self.tableView.tableFooterView = [UIView new];
    
    if (self.userAvatar) {
        self.imageView.image = self.userAvatar;
    }
    
    self.nameLabel.text = self.labelText;
    
    [self.nameLabel sizeToFit];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"view did appear");
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.phoneNumbers count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellReuseId forIndexPath:indexPath];
    cell.textLabel.text = self.phoneNumbers[indexPath.row];
    
    return cell;
}

@end
