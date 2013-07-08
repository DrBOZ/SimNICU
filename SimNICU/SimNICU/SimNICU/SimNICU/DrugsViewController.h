//
//  DrugsViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 08/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrugsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSString *workingWeight;
@property (nonatomic, strong) NSNumber *index;

@end
