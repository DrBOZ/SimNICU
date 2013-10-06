//
//  CBTableViewWebViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 06/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBTableViewController.h"

@interface CBTableViewWebViewController : CBTableViewController

@property (nonatomic, strong) NSArray *webViewSections;

- (id)initWithStyle:(UITableViewStyle)style webViews:(NSArray *)webViews title:(NSString *)title;

@end
