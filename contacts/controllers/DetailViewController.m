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
    
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint
     activateConstraints:@[
                           [self.imageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
                           [self.imageView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:100.f],
                           [self.nameLabel.centerXAnchor constraintEqualToAnchor:self.imageView.centerXAnchor],
                           [self.nameLabel.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:10.f],
                           [self.tableView.topAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:10.f],
                           [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                           [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                           [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
                           ]
     ];
}

#pragma mark - Controller Life Cycle

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"view did appear");
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *phoneNumber = self.phoneNumbers[indexPath.row];
    
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]]];
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
