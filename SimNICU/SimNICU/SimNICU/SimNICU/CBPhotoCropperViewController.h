//
//  CBPhotoCropperViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 12/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum CBPhotoCropperUIMode_ {
    CBPCUIModePresentedAsModalViewController,
    CBPCUIModePushedOnToANavigationController
} CBPhotoCropperUIMode;

// delgate protocol
@class CBPhotoCropperViewController;

@protocol CBPhotoCropperDelegate <NSObject>

@optional

- (void)photoCropper:(CBPhotoCropperViewController *)photoCropper didCropPhoto:(UIImage *)photo;

- (void)photoCropperDidCancel:(CBPhotoCropperViewController *)photoCropper;

@end

@interface CBPhotoCropperViewController : UIViewController <UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    CGPoint _lastTouchDownPoint;
    CBPhotoCropperUIMode _uiMode;
    BOOL _showsInfoButton;
}

@property (nonatomic, strong) UIButton *cropRectangleButton;
@property (nonatomic, unsafe_unretained) id <CBPhotoCropperDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, strong) NSString *photoCropperTitle;
@property (nonatomic, strong) NSString *infoMessageTitle;
@property (nonatomic, strong) NSString *infoMessageBody;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGFloat minZoomScale;
@property (nonatomic, assign) CGFloat maxZoomScale;
@property (nonatomic, strong) UIImage *photo;

- (void)infoButtonTapped:(id)sender;

@end
