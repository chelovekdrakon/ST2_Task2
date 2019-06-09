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
    
    self.sectionsModel = [NSMutableArray new];
    self.sectionsContent = [NSMutableArray new];
    
    self.navigationItem.title = @"Контакты";
    
    UIView *warningView = [self getWarningView];
    self.warningView = warningView;
    
    [self fetchContacts];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:defaultCellReuseId];
    self.tableView.tableFooterView = [UIView new];
}

- (void)fetchContacts {
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
            CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
            NSError *error;
            
            NSMutableDictionary *contacts = [NSMutableDictionary new];
            
            BOOL success = [store enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop) {
                if (error) {
                    NSLog(@"error fetching contacts %@", error);
                } else {
                    NSString *letter = [contact.familyName substringToIndex:1];
                    NSMutableArray *sectionModel = [contacts objectForKey:letter];
                    
                    if (!sectionModel) {
                        sectionModel = [NSMutableArray new];
                        [contacts setObject:sectionModel forKey:letter];
                    }
                    
                    [sectionModel addObject:contact];
                }
            }];
            
            for (NSString *key in contacts) {
                [self.sectionsModel addObject:key];
            }
            
            [self.sectionsModel sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2];
            }];
            
            for (NSString *key in self.sectionsModel) {
                NSMutableArray *sectionContent = [contacts objectForKey:key];
                [self.sectionsContent addObject:sectionContent];
            }
            
            [self.tableView reloadData];
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
    return [self.sectionsModel count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *sectionContent = self.sectionsContent[section];
    return sectionContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"");
    return nil;
}

@end
