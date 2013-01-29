//
//  UVCUACViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 12/08/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "Patient.h"

@interface UVCUACViewController : UIViewController
{
    BOOL birthWeightInNavBar;
}

@property (nonatomic, retain) NSString *estimatedWeightUsed;
@property (nonatomic, retain) Patient *selectedPatient;

@end