//
//  SettingsTableViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 04/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Preferences.h"

@interface SettingsTableViewController : UITableViewController

@property (nonatomic, strong) Preferences *preferences;

@end
