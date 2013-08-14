//
//  APGARTabBarController.h
//  SimNICU
//
//  Created by Conrad Bosman on 24/07/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "Patient.h"

@class APGARTabBarController;

@protocol APGARTabBarControllerDelegate <NSObject>

- (void)APGARTabBarController:(APGARTabBarController *)controller didFinishEnteringAPGARValuesForANewPatient:(Patient *)patient;

@optional

- (void)APGARTabBarController:(APGARTabBarController *)controller updateAPGARValuesForTheNewPatient:(Patient *)patient;

@end

@interface APGARTabBarController : UITabBarController

@property (nonatomic, unsafe_unretained) id <APGARTabBarControllerDelegate> delegate2;
@property (nonatomic, unsafe_unretained) id <APGARTabBarControllerDelegate> delegateAppVC;
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) Patient *tempPatient;

@end