//
//  ContactsViewController.m
//  contacts
//
//  Created by Фёдор Морев on 6/9/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import "ContactsViewController.h"
#import <Contacts/Contacts.h>

NSString * const defaultCellReuseId = @"default";

@interface ContactsViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Контакты";
    
    UIView *warningView = [self getWarningView];
    self.warningView = warningView;
    
    [self fetchContacts];
    
    self.model = @[];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:defaultCellReuseId];
    self.tableView.tableFooterView = [UIView new];
}

- (void)fetchContacts {
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            // hello
        } else {
            [self.view addSubview:self.warningView];
        }
    }];
}

#pragma mark - UI Generators

- (UIView *)getWarningView {
    UIView *view = [UIView new];
    view.frame = self.view.frame;
    view.backgroundColor = [UIColor grayColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.text = @"Доступ к списку котакнтов запрещен. \nВойдите в Settings и разрешите доступ.";
    [label sizeToFit];
    label.center = self.view.center;
    [view addSubview:label];
    
    return view;
}

#pragma mark - UITableViewDataSource Protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.model count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionModel = self.model[section];
    return sectionModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"");
    return nil;
}

@end
