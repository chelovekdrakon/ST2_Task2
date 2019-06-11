//
//  ContactsViewController.m
//  contacts
//
//  Created by Фёдор Морев on 6/9/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import <Contacts/Contacts.h>

#import "ContactsViewController.h"
#import "DetailViewController.h"
#import "SectionHeaderView.h"
#import "AcessoryView.h"

NSString * const defaultCellReuseId = @"default";
NSString * const sectionCellReuseId = @"default";
typedef enum {
    CLOSED = 0,
    OPENED = 1
} SectionState;

@interface ContactsViewController () <UITableViewDelegate, UITableViewDataSource, SectionHeaderViewDelegate, AcessoryViewDelegate>
@property (strong, nonatomic) NSMutableArray *sectionsModelState;
@property (strong, nonatomic) UIImage *openSectionImage;
@property (strong, nonatomic) UIImage *closedSectionImage;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.openSectionImage = [UIImage imageNamed:@"arrow_down"];
    self.closedSectionImage = [UIImage imageNamed:@"arrow_up"];
    
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
            NSMutableArray *otherContacts = [NSMutableArray new];
            
            BOOL success = [store enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop) {
                if (error) {
                    NSLog(@"error fetching contacts %@", error);
                } else {
                    NSString *baseName = contact.familyName.length ? contact.familyName : contact.givenName;
                    NSString *letter = baseName.length ? [baseName substringToIndex:1] : @"#";
                    
                    NSError *error = NULL;
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\b([a-zA-Z]|[ЁёА-я])\\b"
                                                                                           options:NSRegularExpressionCaseInsensitive
                                                                                             error:&error];
                    NSUInteger isAlphabetical = [regex numberOfMatchesInString:letter
                                                      options:0
                                                         range:NSMakeRange(0, 1)];
                    
                    if (isAlphabetical) {
                        NSMutableArray *sectionModel = [contacts objectForKey:letter];
                        
                        if (!sectionModel) {
                            sectionModel = [NSMutableArray new];
                            [contacts setObject:sectionModel forKey:letter];
                        }
                        
                        [sectionModel addObject:contact];
                    } else {
                        [otherContacts addObject:contact];
                    }
                }
            }];
            
            for (NSString *key in contacts) {
                [self.sectionsModel addObject:key];
            }
            
            [self.sectionsModel sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2 options:NSLiteralSearch range:NSMakeRange(0, 1) locale:[NSLocale localeWithLocaleIdentifier:@"RU"]];
            }];
            
            for (NSString *key in self.sectionsModel) {
                NSMutableArray *sectionContent = [contacts objectForKey:key];
                [self.sectionsContent addObject:sectionContent];
                [self.sectionsModelState addObject:@(OPENED)];
            }
            
            [self.sectionsModel addObject:@"#"];
            [self.sectionsContent addObject:otherContacts];
            [self.sectionsModelState addObject:@(OPENED)];
            
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
        headerView.arrowView.image = self.openSectionImage;
    } else {
        [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
        headerView.arrowView.image = self.closedSectionImage;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *sectionContent = self.sectionsContent[indexPath.section];
    CNContact *contact = sectionContent[indexPath.row];
    
    DetailViewController *vc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    NSMutableArray *phoneNumbers = [NSMutableArray new];
    
    for (CNLabeledValue *phoneNumber in contact.phoneNumbers) {
        [phoneNumbers addObject:[[phoneNumber value] stringValue]];
    }
    vc.phoneNumbers = phoneNumbers;
    
    NSString *labelText = [NSString stringWithFormat:@"%@ %@", contact.familyName, contact.givenName];
    
    vc.nameLabel.text = labelText;
    [vc.nameLabel sizeToFit];
    
    if (contact.imageData) {
        vc.imageView.image = [UIImage imageWithData:contact.imageData];
    }
    
    [vc.tableView reloadData];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSMutableArray *sectionContent = self.sectionsContent[indexPath.section];
        [sectionContent removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self.tableView setEditing:NO animated:YES];
    }];
    
    deleteAction.backgroundColor = [UIColor redColor];
    
    return @[deleteAction];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SectionHeaderView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionCellReuseId];
    headerView.delegate = self;
    headerView.section = section;
    
    NSString *text = [NSString stringWithFormat:@"%@ контактов: %@",
                      self.sectionsModel[section],
                      @([self.sectionsContent[section] count])];
    
    headerView.textLabel.text = text;
    
   CGFloat width = self.tableView.frame.size.width;
   CGSize imageSize = self.openSectionImage.size;
   int padding = 10;

   CGRect arrowRect = CGRectMake(width - padding - imageSize.width,
                                      5,
                                      imageSize.width,
                                      imageSize.height);

   UIImageView *arrowView = [[UIImageView alloc] initWithFrame:arrowRect];
   arrowView.image = self.openSectionImage;

    headerView.arrowView = arrowView;
   [headerView addSubview:arrowView];
    
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
    
    AcessoryView *acessoryView = [[AcessoryView alloc] init];
    acessoryView.delegate = self;
    acessoryView.contact = contact;
    
    cell.accessoryView = acessoryView;
    
    return cell;
}

#pragma mark - AcessoryViewDelegate

- (void)onAcessoryViewTap:(AcessoryView *)view {
    NSString *contactName = [NSString stringWithFormat:@"%@ %@", view.contact.givenName, view.contact.familyName];
    NSString *phoneNumber = [NSString stringWithFormat:@"%@", view.contact.phoneNumbers.count ? [view.contact.phoneNumbers[0].value stringValue] : @"-"];
    NSString *message = [NSString stringWithFormat:@"Контакт %@, номер телефона %@", contactName, phoneNumber];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"ОК" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Alert closed!");
    }];
    
    [alertController addAction:alertAction];
    [self.navigationController presentViewController:alertController animated:YES completion:^{
        NSLog(@"Alert presented!");
    }];
}

@end
