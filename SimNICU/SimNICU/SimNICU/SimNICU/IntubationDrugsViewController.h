//
//  IntubationDrugsBackgroundViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 13/08/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntubationDrugsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *workingWeight;

@end