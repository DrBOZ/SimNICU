//
//  AgeCalculatorsViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 18/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "PortraitOnlyNavigationController.h"
#import "CrUSSRadiologyViewController.h"
#import "CBTableViewSectionData.h"
#import "CrUSSViewController.h"
#import "CBTableViewRowData.h"

@interface CrUSSRadiologyViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UIPageControl *pageControl1;
@property (nonatomic, strong) UIPageControl *pageControl2;
@property (nonatomic, strong) NSMutableArray *crUSSImages;
@property (nonatomic, strong) NSMutableArray *pageViews1;
@property (nonatomic, strong) NSMutableArray *pageViews2;
@property (nonatomic, strong) UIScrollView *scrollView1;
@property (nonatomic, strong) UIScrollView *scrollView2;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UILabel *viewLabel;

@end

@implementation CrUSSRadiologyViewController
{
    NSMutableArray *tableData;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //delegate
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        self.title = @"Cranial Ultrasound";
        
        self.view.backgroundColor = [UIColor blackColor];
        // self.view.backgroundColor = [UIColor grayColor];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:nil
                                                                                action:nil];
        
        // view label
        self.viewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 46.0f, 320.0f, 21.0f)];
        self.viewLabel.font = [UIFont boldSystemFontOfSize:23.0f];
        self.viewLabel.backgroundColor = [UIColor blackColor];
        self.viewLabel.textAlignment = UITextAlignmentCenter;
        self.viewLabel.textColor = [UIColor whiteColor];
        self.viewLabel.text = @"Frontal lobes";
        [self.view addSubview:self.viewLabel];
        
        // instantiate UIScrollView & UIPageControl
        if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
        {
            self.scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 99.0f, 320.0f, 274.0f)];
            self.scrollView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 476.0f, 320.0f, 21.0f)];
            self.pageControl1 = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, 360.0f, 320.0f, 36.0f)];
            self.pageControl2 = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, 512.0f, 320.0f, 36.0f)];
        }
        else // 3.5 inch Retina
        {
            self.scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 99.0f, 320.0f, 274.0f)];
            self.scrollView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 476.0f, 320.0f, 21.0f)];
            self.pageControl1 = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, 417.0f, 320.0f, 36.0f)];
            self.pageControl2 = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, 512.0f, 320.0f, 36.0f)];
        }
        
        self.scrollView1.delegate = self;
        self.scrollView1.showsHorizontalScrollIndicator = NO;
        self.scrollView1.showsVerticalScrollIndicator = NO;
        self.scrollView1.scrollEnabled = YES;
        self.scrollView1.clipsToBounds = YES;
        self.scrollView1.pagingEnabled = YES;
        self.scrollView1.decelerationRate = UIScrollViewDecelerationRateFast;
        self.scrollView1.bounces = YES;
        self.scrollView1.bouncesZoom = YES;
        self.scrollView1.userInteractionEnabled = YES;
        self.scrollView1.canCancelContentTouches = YES;
        self.scrollView1.delaysContentTouches = YES;
        self.scrollView1.opaque = YES;
        self.scrollView1.autoresizesSubviews = YES;
        self.scrollView1.clearsContextBeforeDrawing = YES;
        self.scrollView1.multipleTouchEnabled = YES;
        
        self.scrollView2.delegate = self;
        self.scrollView2.showsHorizontalScrollIndicator = NO;
        self.scrollView2.showsVerticalScrollIndicator = NO;
        self.scrollView2.scrollEnabled = YES;
        self.scrollView2.clipsToBounds = YES;
        self.scrollView2.pagingEnabled = YES;
        self.scrollView2.decelerationRate = UIScrollViewDecelerationRateFast;
        self.scrollView2.bounces = YES;
        self.scrollView2.bouncesZoom = YES;
        self.scrollView2.userInteractionEnabled = YES;
        self.scrollView2.canCancelContentTouches = YES;
        self.scrollView2.delaysContentTouches = YES;
        self.scrollView2.opaque = YES;
        self.scrollView2.autoresizesSubviews = YES;
        self.scrollView2.clearsContextBeforeDrawing = YES;
        self.scrollView2.multipleTouchEnabled = YES;
        
        self.pageControl1.opaque = YES;
        self.pageControl1.userInteractionEnabled = NO;
        
        self.pageControl2.opaque = YES;
        self.pageControl2.userInteractionEnabled = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // remove all the objects to display in the scrollView
    [self.pageViews1 removeAllObjects];
    
    if (!self.crUSSImages)
    {
        self.crUSSImages = [[NSMutableArray alloc] initWithCapacity:5];
    }
    else
    {
        [self.crUSSImages removeAllObjects];
    }
    
    // load images
    UIImage *image;
    
    image = [UIImage imageNamed:@"01_Frontal_lobes.png"];
    [self.crUSSImages addObject:image];
    
    image = [UIImage imageNamed:@"02_Anterior_horns_of_lateral_ventricles.png"];
    [self.crUSSImages addObject:image];
    
    image = [UIImage imageNamed:@"03_Third_ventricle.png"];
    [self.crUSSImages addObject:image];
    
    image = [UIImage imageNamed:@"04_Trigone.png"];
    [self.crUSSImages addObject:image];
    
    image = [UIImage imageNamed:@"05_Final_coronal.png"];
    [self.crUSSImages addObject:image];
    
    image = [UIImage imageNamed:@"06_Midline_sagittal.png"];
    [self.crUSSImages addObject:image];
    
    NSInteger pageCount = self.crUSSImages.count;
    
    // Set up the page control
    self.pageControl1.currentPage = 0;
    self.pageControl1.numberOfPages = pageCount;
    
    // Set up the array to hold the views for each page
    self.pageViews1 = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < pageCount; ++i)
    {
        [self.pageViews1 addObject:[NSNull null]];
    }
    
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.scrollView1.frame.size;
    self.scrollView1.contentSize = CGSizeMake(pagesScrollViewSize.width * self.crUSSImages.count, pagesScrollViewSize.height);
    
    // clear self.scrollView contents
    [self.scrollView1.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // Load the initial set of pages that are on screen
    [self loadVisiblePages];
    
    [self.view addSubview:self.scrollView1];
    [self.view addSubview:self.pageControl1];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"CrUSS Radiology" withError:nil];
    
#endif
    
    //[self.view addSubview:self.scrollView1];
    // [self.view addSubview:self.pageControl1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -

- (void)loadVisiblePages
{
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView1.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView1.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl1.currentPage = page;
    
    // Work out which pages we want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++)
    {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++)
    {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<self.crUSSImages.count; i++)
    {
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page
{
    if (page < 0 || page >= self.crUSSImages.count)
    {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Load an individual page, first seeing if we've already loaded it
    UIView *pageView = [self.pageViews1 objectAtIndex:page];
    if ((NSNull *)pageView == [NSNull null])
    {
        CGRect frame = self.scrollView1.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        // frame = CGRectInset(frame, 10.0f, 0.0f);
        
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.crUSSImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFill;
        newPageView.frame = frame;
        [self.scrollView1 addSubview:newPageView];
        [self.pageViews1 replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)purgePage:(NSInteger)page
{
    if (page < 0 || page >= self.crUSSImages.count)
    {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews1 objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null])
    {
        [pageView removeFromSuperview];
        [self.pageViews1 replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Load the pages which are now on screen
    [self loadVisiblePages];
}

@end
