//
//  DrugsTableViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 08/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBTableViewController.h"
#import "Patient.h"

@interface DrugsTableViewController : CBTableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSString *workingWeight;
@property (nonatomic, strong) NSNumber *index;

@end
