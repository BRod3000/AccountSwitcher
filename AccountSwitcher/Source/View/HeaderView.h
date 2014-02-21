//
//  HeaderView.h
//  AccountSwitcher
//
//  Created by Jonah Grant on 2/14/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

@property (nonatomic, readonly) BOOL shouldSwitch;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView profileImage:(UIImage *)profileImage;

@end
