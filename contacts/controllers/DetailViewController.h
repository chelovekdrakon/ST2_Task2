//
//  DetailViewController.h
//  contacts
//
//  Created by Фёдор Морев on 6/11/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray <NSString *> *phoneNumbers;
@property (strong, nonatomic) NSString *labelText;
@property (strong, nonatomic) UIImage *userAvatar;
@end
