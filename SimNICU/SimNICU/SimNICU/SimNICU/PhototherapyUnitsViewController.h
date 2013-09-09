//
//  PhototherapyUnitsViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 24/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhototherapyUnitsViewController;

@protocol PhototherapyUnitsViewControllerDelegate <NSObject>

- (void)phototherapyUnitsViewController:(PhototherapyUnitsViewController *)controller didFinishSelectingUnits:(NSString *)units;

@end

@interface PhototherapyUnitsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, unsafe_unretained) id <PhototherapyUnitsViewControllerDelegate> delegate;
// @property (nonatomic, strong) NSString *guidelineCountry;
// @property (nonatomic, strong) NSString *bilirubinUnits;

@end