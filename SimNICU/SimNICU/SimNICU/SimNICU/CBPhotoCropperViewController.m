//
//  CBPhotoCropperViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 12/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBPhotoCropperViewController.h"

@interface CBPhotoCropperViewController ()

- (void)selectPhoto;
- (void)loadPhoto;
- (void)saveAndClose:(id)sender;
- (void)cancelAndClose:(id)sender;
- (BOOL)isRectanglePositionValid:(CGPoint)pos;
- (void)imageMoved:(id)sender withEvent:(UIEvent *)event;
- (void)imageTouch:(id)sender withEvent:(UIEvent *)event;

@end

@implementation CBPhotoCropperViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.minZoomScale = 0.25f;
    self.maxZoomScale = 3.0f;
    
    self.infoMessageTitle = @"In order to crop the photo";
    self.infoMessageBody = @"Use two of your fingers to zoom in and out the photo and drag the"
    @" green window to crop any part of the photo you would like to use.";
    self.photoCropperTitle = @"Crop Photo";
    
    // sets the background to a nice pattern effect
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"photo_cropper_bg"]];
    
    // load scrollView
    self.scrollView = [[UIScrollView alloc] init];
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
    {
        self.scrollView.frame = CGRectMake(0.0f, 0.0f, (appDelegate.window.bounds.size.width), (appDelegate.window.bounds.size.height - 20.0f - 44.0f));
    }
    else
    {
        self.scrollView.frame = CGRectMake(0.0f, 0.0f, (appDelegate.window.bounds.size.height), (appDelegate.window.bounds.size.width - 20.0f - 32.0f));
    }

    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.minimumZoomScale = 0.25f;
    self.scrollView.maximumZoomScale = 3.0f;
    self.scrollView.bouncesZoom = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.bounces = YES;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.multipleTouchEnabled = YES;
    self.scrollView.clearsContextBeforeDrawing = YES;
    self.scrollView.delaysContentTouches = YES;
    self.scrollView.autoresizesSubviews = YES;
    self.scrollView.canCancelContentTouches = YES;
    self.scrollView.delegate = self;
    
    [self.view addSubview:self.scrollView];
	
    // Control buttons
    UIBarButtonItem *imageButton = [CBBarButtonItems customBarButtonWithImageFile:@"crop.png"
                                                                           target:self
                                                                           action:@selector(saveAndClose:)];
    
    // Add button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(selectPhoto)];

    // Flexible space to align custom buttons
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
     
    NSArray *items = [NSArray arrayWithObjects:addButton,flexibleItem, imageButton, flexibleItem, nil];
     
    self.navigationItem.rightBarButtonItems = items;
    
    if (!_showsInfoButton)
    {
        [self.infoButton setHidden:YES];
    }
    
    // add cropping rectangle
    self.cropRectangleButton = [[UIButton alloc] init];
    self.cropRectangleButton.frame = CGRectMake(15.0f, 100.0f, 300.0f, 65.0f);
    [self.cropRectangleButton setImage:[UIImage imageNamed:@"selectionGridRectangle.png"] forState:UIControlStateNormal];
    [self.cropRectangleButton setImage:[UIImage imageNamed:@"selectionGridRectangleOn.png"] forState:UIControlStateHighlighted];
    
    [self.cropRectangleButton addTarget:self action:@selector(imageTouch:withEvent:) forControlEvents:UIControlEventTouchDown];
    
    [self.cropRectangleButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    
    [self.view addSubview:self.cropRectangleButton];
    
    if (self.photo != nil)
    {
        [self loadPhoto];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)
    {
        [self.delegate photoCropperDidCancel:self];
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
    {
        NSLog(@"Portrait");
        self.scrollView.frame = CGRectMake(0.0f, 0.0f, (appDelegate.window.bounds.size.width), (appDelegate.window.bounds.size.height - 20.0f - 44.0f));
        
        self.cropRectangleButton.frame = CGRectMake(15.0f, 100.0f, 300.0f, 65.0f);
    }
    else
    {
        NSLog(@"Landscape");
        self.scrollView.frame = CGRectMake(0.0f, 0.0f, (appDelegate.window.bounds.size.height), (appDelegate.window.bounds.size.width - 20.0f - 32.0f));
        
        self.cropRectangleButton.frame = CGRectMake(15.0f, 100.0f, 300.0f, 65.0f);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)infoButtonTapped:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.infoMessageTitle
                                                 message:self.infoMessageBody
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    
    [alert show];
}


#pragma mark - private methods

- (void)selectPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:picker animated:YES];
}

- (void)loadPhoto
{
    if (self.photo == nil)
    {
        return;
    }
    
    // clear previous image if there is one
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // add to scrollView after setting frame
    CGFloat w = self.photo.size.width;
    CGFloat h = self.photo.size.height;
    CGRect imageViewFrame = CGRectMake(0.0f, 0.0f, roundf(w / 2.0f), roundf(h / 2.0f));
    self.scrollView.contentSize = imageViewFrame.size;
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:imageViewFrame];
    iv.image = self.photo;
    [self.scrollView addSubview:iv];
    self.imageView = iv;
}

- (UIImage *)croppedPhoto
{
    float adjustment = 0.0f;
    
    CGFloat ox = self.scrollView.contentOffset.x;
    CGFloat oy = self.scrollView.contentOffset.y;
    CGFloat zoomScale = self.scrollView.zoomScale;
    CGFloat cx = (ox + self.cropRectangleButton.frame.origin.x + adjustment) * 2.0f / zoomScale;
    CGFloat cy = (oy + self.cropRectangleButton.frame.origin.y + adjustment) * 2.0f / zoomScale;
    CGFloat cw = 600.0f / zoomScale;
    CGFloat ch = 130.0f / zoomScale;
    CGRect cropRect = CGRectMake(cx, cy, cw, ch);
    
    NSLog(@"---------- cropRect: %@", NSStringFromCGRect(cropRect));
    NSLog(@"--- self.photo.size: %@", NSStringFromCGSize(self.photo.size));
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.photo CGImage], cropRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    NSLog(@"------- result.size: %@", NSStringFromCGSize(result.size));
    
    return result;
}

- (void)saveAndClose:(id)sender
{
    NSLog(@"----------- zoomScale: %.04f", self.scrollView.zoomScale);
    NSLog(@"------- contentOffset: %@", NSStringFromCGPoint(self.scrollView.contentOffset));
    NSLog(@"-- contentScaleFactor: %.04f", self.scrollView.contentScaleFactor);
    NSLog(@"--------- contentSize: %@", NSStringFromCGSize(self.scrollView.contentSize));
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoCropper:didCropPhoto:)])
    {
        [self.delegate photoCropper:self didCropPhoto:[self croppedPhoto]];
    }
}

- (void)cancelAndClose:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoCropperDidCancel:)]) {
        [self.delegate photoCropperDidCancel:self];
    }
}

- (BOOL)isRectanglePositionValid:(CGPoint)pos
{
    float adjustment = 0.0f;
    
    CGRect innerRect = CGRectMake((pos.x + adjustment), (pos.y + adjustment), 300.0f, 65.0f);
    return CGRectContainsRect(self.scrollView.frame, innerRect);
}

- (void)imageMoved:(id)sender withEvent:(UIEvent *)event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    
    CGPoint prev = _lastTouchDownPoint;
    _lastTouchDownPoint = point;
    CGFloat diffX = point.x - prev.x;
    CGFloat diffY = point.y - prev.y;
    
    UIControl *button = sender;
    CGRect newFrame = button.frame;
    newFrame.origin.x += diffX;
    newFrame.origin.y += diffY;
    if ([self isRectanglePositionValid:newFrame.origin])
    {
        button.frame = newFrame;
    }
}

- (void)imageTouch:(id)sender withEvent:(UIEvent *)event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    _lastTouchDownPoint = point;
    NSLog(@"imageTouch. point: %@", NSStringFromCGPoint(point));
}

#pragma mark - UIScrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

/*
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    NSLog(@"");
}
 */

#pragma mark - UIImagePickerController delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self loadPhoto];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
