//
//  SectionHeaderView.m
//  contacts
//
//  Created by Фёдор Морев on 6/9/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import "SectionHeaderView.h"

@interface SectionHeaderView()
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@end

@implementation SectionHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.contentView addGestureRecognizer:self.tapRecognizer];
    }
    return self;
}

- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer {
    if ([self.delegate conformsToProtocol:@protocol(SectionHeaderViewProtocol)]) {
        [self.delegate onSectionTap:self];
    }
}
    

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
