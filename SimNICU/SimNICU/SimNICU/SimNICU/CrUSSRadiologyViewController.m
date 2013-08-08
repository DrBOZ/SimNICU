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
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *crUSSImages;
@property (nonatomic, strong) UIScrollView *scrollView;

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
        // instantiate UIScrollView & UIPageControl
        if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
        {
            self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 99.0f, 320.0f, 274.0f)];
            self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, 360.0f, 320.0f, 36.0f)];
        }
        else // 3.5 inch Retina
        {
            self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 99.0f, 320.0f, 274.0f)];
            self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, 417.0f, 320.0f, 36.0f)];
        }
        
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.scrollEnabled = YES;
        self.scrollView.clipsToBounds = YES;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        self.scrollView.bounces = YES;
        self.scrollView.bouncesZoom = YES;
        self.scrollView.userInteractionEnabled = YES;
        self.scrollView.canCancelContentTouches = YES;
        self.scrollView.delaysContentTouches = YES;
        self.scrollView.opaque = YES;
        self.scrollView.autoresizesSubviews = YES;
        self.scrollView.clearsContextBeforeDrawing = YES;
        self.scrollView.multipleTouchEnabled = YES;
        
        self.pageControl.opaque = YES;
        [self.pageControl addTarget:self action:@selector(pageControlTapped) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.crUSSImages = [[NSMutableArray alloc] initWithCapacity:2];
    
    UIImage *image = [UIImage imageNamed:@"CrUSSOptimumSize.png"];
    
    [self.crUSSImages addObject:image];
    [self.crUSSImages addObject:image];
    
    NSInteger pageCount = self.crUSSImages.count;
    
    NSLog(@"pageCount = %i", pageCount);
    
    // Set up the page control
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    // Set up the array to hold the views for each page
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i)
    {
        [self.pageViews addObject:[NSNull null]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // remove all the objects to display in the scrollView
    [self.pageViews removeAllObjects];
    
    if (!self.crUSSImages)
    {
        self.crUSSImages = [[NSMutableArray alloc] initWithCapacity:2];
    }
    else
    {
        [self.crUSSImages removeAllObjects];
    }
    
    UIImage *image = [UIImage imageNamed:@"CrUSSOptimumSize.png"];
    
    [self.crUSSImages addObject:image];
    [self.crUSSImages addObject:image];
    
    NSInteger pageCount = self.crUSSImages.count;
    
    // Set up the page control
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    // Set up the array to hold the views for each page
    self.pageViews = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < pageCount; ++i)
    {
        [self.pageViews addObject:[NSNull null]];
    }
    
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.crUSSImages.count, pagesScrollViewSize.height);
    
    // clear self.scrollView contents
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // Load the initial set of pages that are on screen
    [self loadVisiblePages];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"CrUSS Radiology" withError:nil];
    
#endif
    
    //[self.view addSubview:self.scrollView];
    // [self.view addSubview:self.pageControl];
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
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
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
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull *)pageView == [NSNull null])
    {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        // frame = CGRectInset(frame, 10.0f, 0.0f);
        
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.crUSSImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFill;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
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
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null])
    {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Load the pages which are now on screen
    [self loadVisiblePages];
}

- (void)pageControlTapped
{
    // Scroll to appropriate page
    
    
    // CGFloat pageWidth = self.scrollView.frame.size.width;
    // NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    /*
    // First, determine which page is currently visible
    
    NSInteger page = self.pageControl.currentPage;
    
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
     */
}

@end
