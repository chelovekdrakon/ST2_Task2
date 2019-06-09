//
//  ContactsViewController.h
//  contacts
//
//  Created by Фёдор Морев on 6/9/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UIView *warningView;

@property (strong, nonatomic) NSMutableArray <NSString *> *sectionsModel;
@property (strong, nonatomic) NSMutableArray <NSMutableArray *> *sectionsContent;
@end
