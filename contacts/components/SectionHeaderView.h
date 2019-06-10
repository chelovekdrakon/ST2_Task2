//
//  SectionHeaderView.h
//  contacts
//
//  Created by Фёдор Морев on 6/9/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SectionHeaderView;

@protocol SectionHeaderViewDelegate <NSObject>
- (void) onSectionTap:(SectionHeaderView *)view;
@end

@interface SectionHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) id <SectionHeaderViewDelegate> delegate;
@property (assign, nonatomic) NSInteger section;
@end
