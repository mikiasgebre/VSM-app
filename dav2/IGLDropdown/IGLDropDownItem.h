//
//  DropDown Menu
//
//  Created by ViNiT. on 8/11/15.
//  Copyright (c) 2015 ViNiT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGLDropDownItem : UIControl

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) id object;
@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong, readonly) UILabel *textLabel;

@property (nonatomic, assign) CGFloat paddingLeft;

- (id)copyWithZone:(NSZone *)zone;

@end
