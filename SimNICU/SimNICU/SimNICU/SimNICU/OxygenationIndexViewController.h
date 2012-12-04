//
//  OxygenationIndexViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 11/08/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OxygenationIndexViewController;

@protocol OxygenationIndexViewControllerDelegate <NSObject>

- (void)oxygenationIndexViewController:(OxygenationIndexViewController *)controller didChangePaO2Units:(int)index;

@end

@interface OxygenationIndexViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, unsafe_unretained) id <OxygenationIndexViewControllerDelegate> delegate;
@property (nonatomic, strong) UITextField *meanAirwayPressure;
@property (nonatomic, strong) UITextField *inspiredOxygen;
@property (nonatomic, strong) UISegmentedControl *units;
@property (nonatomic, strong) UILabel *oxygenationIndex;
@property (nonatomic, strong) UITextField *PaO2;
@property (nonatomic, strong) NSString *OIPaO2UnitsIndex;

@end