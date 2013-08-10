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
#import "CrUSSScanSeries.h"
#import "CrUSSDataBase.h"
#import "CrUSSImage.h"

@interface CrUSSRadiologyViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UIPageControl *pageControl1;
@property (nonatomic, strong) UIPageControl *pageControl2;
@property (nonatomic, strong) NSMutableArray *crUSSScans;
@property (nonatomic, strong) NSMutableArray *pageViews1;
@property (nonatomic, strong) NSMutableArray *pageViews2;
@property (nonatomic, strong) UIScrollView *scrollView1;
@property (nonatomic, strong) UIScrollView *scrollView2;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UILabel *viewLabel;

@end

@implementation CrUSSRadiologyViewController
{
    NSInteger oldPage;
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
        self.viewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 46.0f, 320.0f, 40.0f)];
        self.viewLabel.adjustsFontSizeToFitWidth = YES;
        self.viewLabel.font = [UIFont boldSystemFontOfSize:23.0f];
        self.viewLabel.backgroundColor = [UIColor blackColor];
        self.viewLabel.textAlignment = UITextAlignmentCenter;
        self.viewLabel.textColor = [UIColor whiteColor];
        self.viewLabel.text = @"";
        [self.view addSubview:self.viewLabel];
        
        // instantiate UIScrollView & UIPageControl
        if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
        {
            self.scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 99.0f, 320.0f, 274.0f)];
            self.scrollView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 400.0f, 320.0f, 60.0f)];
            self.pageControl1 = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, 360.0f, 320.0f, 36.0f)];
            self.pageControl2 = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, 448.0f, 320.0f, 36.0f)];
        }
        else // 3.5 inch Retina
        {
            // code
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
    oldPage = 0;
    
    // remove all the objects to display in the scrollView
    [self.pageViews1 removeAllObjects];
    
    if (!self.crUSSScans)
    {
        self.crUSSScans = [[NSMutableArray alloc] initWithCapacity:5];
    }
    else
    {
        [self.crUSSScans removeAllObjects];
    }
    
    // get scans for gestation
    self.crUSSScans = [CrUSSDataBase getScansForGestation:30];

    // setup pageControls
    NSInteger pageCount = nil;
    CGSize pagesScrollViewSize;
    
    //
    // setup pageControl2
    pageCount = self.crUSSScans.count;
    
    self.pageControl2.currentPage = 0;
    self.pageControl2.numberOfPages = pageCount;
    
    // Set up the array to hold the views for each page
    self.pageViews2 = [[NSMutableArray alloc] initWithCapacity:pageCount];
    
    for (NSInteger i = 0; i < pageCount; ++i)
    {
        [self.pageViews2 addObject:[NSNull null]];
    }
    
    // Set up the content size of scroll view 2
    pagesScrollViewSize = self.scrollView2.frame.size;
    self.scrollView2.contentSize = CGSizeMake(pagesScrollViewSize.width * pageCount, pagesScrollViewSize.height);
    
    // clear self.scrollView contents
    [self.scrollView2.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // Load the initial set of pages that are on screen
    [self loadVisiblePagesForPageControl:self.pageControl2];
    
    //
    // setup pageControl1
    CrUSSScanSeries *scanSeries = self.crUSSScans[self.pageControl2.currentPage];
    
    pageCount = [scanSeries.scans count];
    
    self.pageControl1.currentPage = 0;
    self.pageControl1.numberOfPages = pageCount;
    
    // Set up the array to hold the views for each page
    self.pageViews1 = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < pageCount; ++i)
    {
        [self.pageViews1 addObject:[NSNull null]];
    }
    
    // Set up the content size of the scroll view
    pagesScrollViewSize = self.scrollView1.frame.size;
    self.scrollView1.contentSize = CGSizeMake(pagesScrollViewSize.width * pageCount, pagesScrollViewSize.height);
    
    // clear self.scrollView contents
    [self.scrollView1.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // Load the initial set of pages that are on screen
    [self loadVisiblePagesForPageControl:self.pageControl1];
    
    [self.view addSubview:self.scrollView1];
    [self.view addSubview:self.pageControl1];
    [self.view addSubview:self.scrollView2];
    [self.view addSubview:self.pageControl2];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"CrUSS Radiology" withError:nil];
    
#endif

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

- (void)loadVisiblePagesForPageControl:(UIPageControl *)pageControl
{
    CrUSSScanSeries *scanSeries = self.crUSSScans[self.pageControl2.currentPage];
    
    if ([pageControl isEqual:self.pageControl1])
    {
        // First, determine which page is currently visible
        CGFloat pageWidth = self.scrollView1.frame.size.width;
        NSInteger page = (NSInteger)floor((self.scrollView1.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
        // NSLog(@" ");
        // NSLog(@"page = %i", page);
        
        // Update the page control
        if (page < scanSeries.scans.count)
        {
            self.pageControl1.currentPage = page;
        }
        else if (page == scanSeries.scans.count)
        {
            // user trying to load more images than in database
            page -= 1;
        }
        else
        {
            // user trying to load image -1
            page = 0;
        }
        
        CrUSSImage *image = scanSeries.scans[page];
        
        self.viewLabel.text = image.text;
        
        // Work out which pages we want to load
        NSInteger previousPage = page - 1;
        NSInteger nextPage = page + 1;
        
        // Purge anything before the first page
        for (NSInteger i = 0; i < previousPage; i++)
        {
            [self purgePage:i forPageControl:self.pageControl1];
            // NSLog(@"Purge page");
        }
        for (NSInteger i = previousPage; i <= nextPage; i++)
        {
            [self loadPage:i forPageControl:self.pageControl1];
            // NSLog(@"Load page");
        }
        for (NSInteger i = nextPage + 1; i < [scanSeries.scans count]; i++)
        {
            [self purgePage:i forPageControl:self.pageControl1];
            // NSLog(@"Purge page");
        }
    }
    else if ([pageControl isEqual:self.pageControl2])
    {
        // First, determine which page is currently visible
        CGFloat pageWidth = self.scrollView2.frame.size.width;
        NSInteger page = (NSInteger)floor((self.scrollView2.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
        
        // Update the page control
        self.pageControl2.currentPage = page;
        
        if (page != oldPage)
        {
            oldPage = page;
            [self reloadVisiblePagesAfterChangingSeries];
        }
        
        // Work out which pages we want to load
        NSInteger previousPage = page - 1;
        NSInteger nextPage = page + 1;
        
        // Purge anything before the previous page
        for (NSInteger i = 0; i < previousPage; i++)
        {
            [self purgePage:i forPageControl:self.pageControl2];
        }
        for (NSInteger i = previousPage; i <= nextPage; i++)
        {
            [self loadPage:i forPageControl:self.pageControl2];
        }
        for (NSInteger i = nextPage+1; i < self.crUSSScans.count; i++)
        {
            [self purgePage:i forPageControl:self.pageControl2];
        }
    }
}

- (void)loadPage:(NSInteger)page forPageControl:(UIPageControl *)pageControl
{
    if ([pageControl isEqual:self.pageControl1])
    {
        CrUSSScanSeries *scanSeries = self.crUSSScans[self.pageControl2.currentPage];
        
        if (page < 0 || page >= [scanSeries.scans count])
        {
            // If it's outside the range of what we have to display, then do nothing
            return;
        }
        
        // Load an individual page, first seeing if we've already loaded it
        UIView *pageView = [self.pageViews1 objectAtIndex:page];
        if ((NSNull *)pageView == [NSNull null])
        {
            // NSLog(@"Loading... page %i", page);
            CGRect frame = self.scrollView1.bounds;
            frame.origin.x = frame.size.width * page;
            frame.origin.y = 0.0f;
            
            CrUSSImage *image;
            
            image = [scanSeries.scans objectAtIndex:page];
            
            UIImageView *newPageView = [[UIImageView alloc] initWithImage:image.image];
            newPageView.contentMode = UIViewContentModeScaleAspectFill;
            newPageView.frame = frame;
            [self.scrollView1 addSubview:newPageView];
            [self.pageViews1 replaceObjectAtIndex:page withObject:newPageView];
            
            // set label
            if (self.pageControl1.currentPage == page)
            {
                self.viewLabel.text = image.text;
            }
        }
    }
    else
    {
        if (page < 0 || page >= self.crUSSScans.count)
        {
            // If it's outside the range of what we have to display, then do nothing
            return;
        }
        
        CrUSSScanSeries *scanSeries = self.crUSSScans[page];
        
        // Load an individual page, first seeing if we've already loaded it
        UIView *pageView = [self.pageViews2 objectAtIndex:page];
        if ((NSNull *)pageView == [NSNull null])
        {
            CGRect frame = self.scrollView2.bounds;
            frame.origin.x = frame.size.width * page;
            frame.origin.y = 0.0f;
            
            UIView *newPageView = [[UIView alloc] initWithFrame:frame];
            
            UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
            description.text = scanSeries.description;
            description.backgroundColor = [UIColor blackColor];
            description.textColor = [UIColor whiteColor];
            description.textAlignment = UITextAlignmentCenter;
            description.font = [UIFont boldSystemFontOfSize:23.0f];
            [newPageView addSubview:description];

            [self.scrollView2 addSubview:newPageView];
            [self.pageViews2 replaceObjectAtIndex:page withObject:newPageView];
        }
    }
}

- (void)purgePage:(NSInteger)page forPageControl:(UIPageControl *)pageControl
{
    if ([pageControl isEqual:self.pageControl1])
    {
        CrUSSScanSeries *scanSeries = self.crUSSScans[self.pageControl2.currentPage];
        
        if (page < 0 || page >= scanSeries.scans.count)
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
    else if ([pageControl isEqual:self.pageControl2])
    {
        if (page < 0 || page >= self.crUSSScans.count)
        {
            // If it's outside the range of what we have to display, then do nothing
            return;
        }
        
        // Remove a page from the scroll view and reset the container array
        UIView *pageView = [self.pageViews2 objectAtIndex:page];
        if ((NSNull*)pageView != [NSNull null])
        {
            [pageView removeFromSuperview];
            [self.pageViews2 replaceObjectAtIndex:page withObject:[NSNull null]];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.scrollView1])
    {
        // Load the pages which are now on screen
        [self loadVisiblePagesForPageControl:self.pageControl1];
    }
    else if ([scrollView isEqual:self.scrollView2])
    {
        [self loadVisiblePagesForPageControl:self.pageControl2];
    }
}

- (void)reloadVisiblePagesAfterChangingSeries
{
    [self.pageViews1 removeAllObjects];
    
    CrUSSScanSeries *scanSeries = self.crUSSScans[self.pageControl2.currentPage];
    
    NSInteger pageCount = [scanSeries.scans count];
    
    for (NSInteger i = 0; i < pageCount; ++i)
    {
        [self.pageViews1 addObject:[NSNull null]];
    }
    
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView1.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView1.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    // NSLog(@" ");
    // NSLog(@"page = %i", page);
    
    // Update the page control
    if (page < scanSeries.scans.count)
    {
        self.pageControl1.currentPage = page;
    }
    else if (page == scanSeries.scans.count)
    {
        // user trying to load more images than in database
        page -= 1;
    }
    else
    {
        // user trying to load image -1
        page = 0;
    }
    
    CrUSSImage *image = scanSeries.scans[page];
    
    self.viewLabel.text = image.text;
    
    // Work out which pages we want to load
    NSInteger previousPage = page - 1;
    NSInteger nextPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i = 0; i < previousPage; i++)
    {
        [self purgePage:i forPageControl:self.pageControl1];
        // NSLog(@"Purge page");
    }
    for (NSInteger i = previousPage; i <= nextPage; i++)
    {
        [self loadPage:i forPageControl:self.pageControl1];
        // NSLog(@"Load page");
    }
    for (NSInteger i = nextPage + 1; i < [scanSeries.scans count]; i++)
    {
        [self purgePage:i forPageControl:self.pageControl1];
        // NSLog(@"Purge page");
    }
}

@end
