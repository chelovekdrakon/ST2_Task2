//
//  AcessoryView.h
//  contacts
//
//  Created by Фёдор Морев on 6/10/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>

@class AcessoryView;

@protocol AcessoryViewDelegate <NSObject>
- (void)onAcessoryViewTap:(AcessoryView *)view;
@end

@interface AcessoryView : UIImageView
@property (strong, nonatomic) CNContact *contact;
@property (weak, nonatomic) id <AcessoryViewDelegate> delegate;
@end
