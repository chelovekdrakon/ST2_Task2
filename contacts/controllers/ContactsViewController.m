//
//  ContactsViewController.m
//  contacts
//
//  Created by Фёдор Морев on 6/9/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import <Contacts/Contacts.h>

#import "ContactsViewController.h"
#import "SectionHeaderView.h"

NSString * const defaultCellReuseId = @"default";
NSString * const sectionCellReuseId = @"default";
typedef enum {
    CLOSED = 0,
    OPENED = 1
} SectionState;

@interface ContactsViewController () <UITableViewDelegate, UITableViewDataSource, SectionHeaderViewProtocol>
@property (strong, nonatomic) NSMutableArray *sectionsModelState;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sectionsModel = [NSMutableArray new];
    self.sectionsContent = [NSMutableArray new];
    self.sectionsModelState = [NSMutableArray new];
    
    self.navigationItem.title = @"Контакты";
    
    UIView *warningView = [self getWarningView];
    self.warningView = warningView;
    
    [self fetchContacts];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:defaultCellReuseId];
    [self.tableView registerClass:[SectionHeaderView class] forHeaderFooterViewReuseIdentifier:sectionCellReuseId];
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
                [self.sectionsModelState addObject:@(OPENED)];
            }
            
            [self.tableView reloadData];
        } else {
            [self.view addSubview:self.warningView];
        }
    }];
}

#pragma mark - SectionHeaderView Protocol

- (void)onSectionTap:(SectionHeaderView *)headerView {
    NSUInteger section = headerView.section;
    
    SectionState state = [self.sectionsModelState[section] intValue];
    SectionState nextState = state == OPENED ? CLOSED : OPENED;
    
    self.sectionsModelState[section] = @(nextState);
    
    NSMutableArray *paths = [NSMutableArray new];
    
    NSMutableArray *sectionContent = self.sectionsContent[section];
    for (int index = 0; index < [sectionContent count]; index++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:section];
        [paths addObject:path];
    }
    
    if (nextState == OPENED) {
        [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
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

#pragma mark - UITableViewDelegate Protocol

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SectionHeaderView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionCellReuseId];
    headerView.delegate = self;
    headerView.section = section;
    
    headerView.textLabel.text = self.sectionsModel[section];
    
    return headerView;
}

#pragma mark - UITableViewDataSource Protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionsModel count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SectionState state = [self.sectionsModelState[section] intValue];
    
    if (state == OPENED) {
        NSMutableArray *sectionContent = self.sectionsContent[section];
        return sectionContent.count;
    } else {
        return 0;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:defaultCellReuseId forIndexPath:indexPath];
    CNContact *contact = self.sectionsContent[indexPath.section][indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];
    
    return cell;
}

@end
