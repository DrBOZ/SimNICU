//
//  PhototherapyGuidelineCountryViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 26/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhototherapyGuidelineCountryViewController;

@protocol PhototherapyGuidelineCountryViewControllerDelegate <NSObject>

- (void)phototherapyGuidelineCountryViewController:(PhototherapyGuidelineCountryViewController *)controller didFinishSelectingGuidelineCountry:(NSString *)guidelineCountry;

@end

@interface PhototherapyGuidelineCountryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, unsafe_unretained) id <PhototherapyGuidelineCountryViewControllerDelegate> delegate;
// @property (nonatomic, strong) NSString *guidelineCountry;

@end