//
//  IntubationViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 05/09/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

@class IntubationViewController;

@protocol IntubationViewControllerDelegate <NSObject>

- (void)intubationViewController:(IntubationViewController *)controller didChangeETTRoundUp:(BOOL)selected;

@end

@interface IntubationViewController : UIViewController

@property (nonatomic, unsafe_unretained) id <IntubationViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *endotrachealTubeType;
@property (nonatomic, strong) NSString *gestation;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *roundUp;

@end
