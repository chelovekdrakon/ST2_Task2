//
//  AcessoryView.m
//  contacts
//
//  Created by Фёдор Морев on 6/10/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import "AcessoryView.h"

@interface AcessoryView ()
@property (strong, nonatomic) UITapGestureRecognizer *tapRecongizer;
@end

@implementation AcessoryView

- (id)init {
    self = [super init];
    
    if (self) {
        UIImage *infoImage = [UIImage imageNamed:@"info"];
        self.frame = CGRectMake(0, 0, infoImage.size.width, infoImage.size.height);
        self.image = infoImage;
        
        self.userInteractionEnabled = YES;
        self.tapRecongizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleInfoPress:)];
        [self addGestureRecognizer:self.tapRecongizer];
    }
    
    return self;
}

- (void)handleInfoPress:(UITapGestureRecognizer *)tapRecognizer {
    if ([self.delegate conformsToProtocol:@protocol(AcessoryViewDelegate)]) {
        [self.delegate onAcessoryViewTap:self];
    }
}

@end
