//
//  IntubationViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 05/09/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "Patient.h"

@class IntubationViewController;

@protocol IntubationViewControllerDelegate <NSObject>

- (void)intubationViewController:(IntubationViewController *)controller didChangeETTRoundUp:(BOOL)selected;

@end

@interface IntubationViewController : UIViewController

@property (nonatomic, unsafe_unretained) id <IntubationViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *endotrachealTubeType;
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSString *gestation;
@property (nonatomic, strong) NSString *roundUp;
@property (nonatomic, strong) NSString *weight;

@end
