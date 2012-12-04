/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalViewController.h"
#import "KalLogic.h"
#import "KalDataSource.h"
#import "KalDate.h"
#import "KalPrivate.h"

#import "AppDelegate.h"

#define PROFILER 0
#if PROFILER
#include <mach/mach_time.h>
#include <time.h>
#include <math.h>
void mach_absolute_difference(uint64_t end, uint64_t start, struct timespec *tp)
{
    uint64_t difference = end - start;
    static mach_timebase_info_data_t info = {0,0};
    
    if (info.denom == 0)
        mach_timebase_info(&info);
    
    uint64_t elapsednano = difference * (info.numer / info.denom);
    tp->tv_sec = elapsednano * 1e-9;
    tp->tv_nsec = elapsednano - (tp->tv_sec * 1e9);
}
#endif

NSString *const KalDataSourceChangedNotification = @"KalDataSourceChangedNotification";

@interface KalViewController ()

@property (nonatomic) BOOL viewControllerReadyToSendSelectedDate;
@property (nonatomic, readwrite) NSDate *selectedDate;
@property (nonatomic, readwrite) NSDate *initialDate;
@property (nonatomic) BOOL userSwappingMonths;

- (KalView *)calendarView;
- (NSInteger)getDaysDifferenceBetween:(NSDate *)dateA and:(NSDate *)dateB;

@end

@implementation KalViewController

@synthesize viewControllerReadyToSendSelectedDate = _viewControllerReadyToSendSelectedDate;
@synthesize dataSource, delegate, initialDate, selectedDate;
@synthesize userSwappingMonths = _userSwappingMonths;
@synthesize calendarFunction = _calendarFunction;
@synthesize patientToEdit = _patientToEdit;
@synthesize mainDelegate = _mainDelegate;


- (id)initWithSelectedDate:(NSDate *)date
{
    if ((self = [super init]))
    {
        logic = [[KalLogic alloc] initForDate:date];
        self.initialDate = date;
        self.selectedDate = date;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:KalDataSourceChangedNotification object:nil];
    }
    
    return self;
}

- (id)init
{
    return [self initWithSelectedDate:[NSDate date]];
}

- (KalView*)calendarView { return (KalView*)self.view; }

- (void)setDataSource:(id<KalDataSource>)aDataSource
{
    if (dataSource != aDataSource) {
        dataSource = aDataSource;
        tableView.dataSource = dataSource;
    }
}

- (void)setDelegate:(id<UITableViewDelegate>)aDelegate
{
    if (delegate != aDelegate) {
        delegate = aDelegate;
        tableView.delegate = delegate;
    }
}

- (void)clearTable
{
    [dataSource removeAllItems];
    [tableView reloadData];
}

- (void)reloadData
{
    [dataSource presentingDatesFrom:logic.fromDate to:logic.toDate delegate:self];
}

- (void)significantTimeChangeOccurred
{
    [[self calendarView] jumpToSelectedMonth];
    [self reloadData];
}

// -----------------------------------------
#pragma mark KalViewDelegate protocol

- (void)didSelectDate:(KalDate *)date
{
    if ([self.calendarFunction isEqualToString:@"Setting DOB"]) 
    {
        
        if (self.viewControllerReadyToSendSelectedDate) 
        {
            NSDate *selDate  = [date NSDate];
            NSDate *today = [NSDate date];
            
            int daysDifference;
            
            daysDifference = [self getDaysDifferenceBetween:selDate and:today];
            
            NSLog(@"daysDifference = %i", daysDifference);
            
            double diff;
            
            diff = [selDate timeIntervalSinceNow];
            
            NSLog(@"diff = %f", diff);
            
            if (diff > 0)
            {
                NSLog(@"%@", [date NSDate]);
                NSLog(@"%@", [NSDate date]);
                
                
                NSLog(@"Date later then today");
                
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"ERROR!" 
                                          message:@"Selected date is in the future!" 
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
            }
            else 
            {
                self.selectedDate = [date NSDate];
                
                NSDate *from = [[date NSDate] cc_dateByMovingToBeginningOfDay];
                NSDate *to = [[date NSDate] cc_dateByMovingToEndOfDay];
                [self clearTable];
                [dataSource loadItemsFromDate:from toDate:to];
                [tableView reloadData];
                [tableView flashScrollIndicators];
                
                if (self.viewControllerReadyToSendSelectedDate) 
                {
                    if (!self.userSwappingMonths) 
                    {
                        NSLog(@"Pop view controller");
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                
                self.userSwappingMonths = NO;
            }
        }
        else
        {
            self.selectedDate = [date NSDate];
            
            NSDate *from = [[date NSDate] cc_dateByMovingToBeginningOfDay];
            NSDate *to = [[date NSDate] cc_dateByMovingToEndOfDay];
            [self clearTable];
            [dataSource loadItemsFromDate:from toDate:to];
            [tableView reloadData];
            [tableView flashScrollIndicators];
            
            self.userSwappingMonths = NO;
        }
    }
    else if ([self.calendarFunction isEqualToString:@"Setting WorkingWeightDate"])
    {
        if (self.viewControllerReadyToSendSelectedDate) 
        {
            NSDate *selDate  = [date NSDate];
            NSDate *today = [NSDate date];
            
            int daysDifference;
            
            daysDifference = [self getDaysDifferenceBetween:selDate and:today];
            
            NSLog(@"daysDifference = %i", daysDifference);
            
            double diff;
            
            diff = [selDate timeIntervalSinceNow];
            
            NSLog(@"diff = %f", diff);
            
            if (diff > 0)
            {
                NSLog(@"%@", [date NSDate]);
                NSLog(@"%@", [NSDate date]);
                
                
                NSLog(@"Date later then today");
                
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"ERROR!" 
                                          message:@"Selected date is in the future!" 
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
            }
            else 
            {
                self.selectedDate = [date NSDate];
                
                NSDate *from = [[date NSDate] cc_dateByMovingToBeginningOfDay];
                NSDate *to = [[date NSDate] cc_dateByMovingToEndOfDay];
                [self clearTable];
                [dataSource loadItemsFromDate:from toDate:to];
                [tableView reloadData];
                [tableView flashScrollIndicators];
                
                if (self.viewControllerReadyToSendSelectedDate) 
                {
                    if (!self.userSwappingMonths) 
                    {
                        // NSLog(@"Pop view controller");
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                
                self.userSwappingMonths = NO;
            }
        }
    }
    else 
    {
        self.selectedDate = [date NSDate];
        
        NSDate *from = [[date NSDate] cc_dateByMovingToBeginningOfDay];
        NSDate *to = [[date NSDate] cc_dateByMovingToEndOfDay];
        [self clearTable];
        [dataSource loadItemsFromDate:from toDate:to];
        [tableView reloadData];
        [tableView flashScrollIndicators];
        
        self.userSwappingMonths = NO;
     
    }
     
}

- (void)showPreviousMonth
{
    NSLog(@"Showing previous month");
    self.userSwappingMonths = YES;
    
    [self clearTable];
    [logic retreatToPreviousMonth];
    [[self calendarView] slideDown];
    [self reloadData];
}

- (void)showFollowingMonth
{
    NSLog(@"Showing following month");
    self.userSwappingMonths = YES;
    
    [self clearTable];
    [logic advanceToFollowingMonth];
    [[self calendarView] slideUp];
    [self reloadData];
}

// -----------------------------------------
#pragma mark KalDataSourceCallbacks protocol

- (void)loadedDataSource:(id<KalDataSource>)theDataSource;
{
    NSArray *markedDates = [theDataSource markedDatesFrom:logic.fromDate to:logic.toDate];
    NSMutableArray *dates = [markedDates mutableCopy];
    for (int i=0; i<[dates count]; i++)
        [dates replaceObjectAtIndex:i withObject:[KalDate dateFromNSDate:[dates objectAtIndex:i]]];
    
    [[self calendarView] markTilesForDates:dates];
    [self didSelectDate:self.calendarView.selectedDate];
}

// ---------------------------------------
#pragma mark -

- (void)showAndSelectDate:(NSDate *)date
{
    if ([[self calendarView] isSliding])
        return;
    
    [logic moveToMonthForDate:date];
    
#if PROFILER
    uint64_t start, end;
    struct timespec tp;
    start = mach_absolute_time();
#endif
    
    [[self calendarView] jumpToSelectedMonth];
    
#if PROFILER
    end = mach_absolute_time();
    mach_absolute_difference(end, start, &tp);
    printf("[[self calendarView] jumpToSelectedMonth]: %.1f ms\n", tp.tv_nsec / 1e6);
#endif
    
    [[self calendarView] selectDate:[KalDate dateFromNSDate:date]];
    [self reloadData];
    
    NSLog(@"Date selected");
}

- (NSDate *)selectedDate
{
    return [self.calendarView.selectedDate NSDate];
    NSLog(@"SelectedDate");
}


// -----------------------------------------------------------------------------------
#pragma mark UIViewController

- (void)didReceiveMemoryWarning
{
    self.initialDate = self.selectedDate; // must be done before calling super
    [super didReceiveMemoryWarning];
}

- (void)loadView
{
    if ([self.calendarFunction isEqualToString:@"Setting DOB"]) 
    {
        self.title = @"Date of Birth";
    }
    else if ([self.calendarFunction isEqualToString:@"Setting WorkingWeightDate"])
    {
        self.title = @"Working Weight";
    }
    
    if (!self.title)
        self.title = @"Calendar";
    
    KalView *kalView = [[KalView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] delegate:self logic:logic];
    self.view = kalView;
    tableView = kalView.tableView;
    tableView.dataSource = dataSource;
    tableView.delegate = delegate;
    [kalView selectDate:[KalDate dateFromNSDate:self.initialDate]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:self action:@selector(selectToday)];
    
    NSLog(@"calendarFunction = %@", self.calendarFunction);
    self.viewControllerReadyToSendSelectedDate = YES;
    
    [self reloadData];
}

- (void)viewDidUnload
{
    tableView = nil;
    
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) 
    {
        if ([self.calendarFunction isEqualToString:@"Setting DOB"]) 
        {
            NSLog(@" ");
            NSLog(@"Setting DOB");
            
            if (self.patientToEdit)
            {
                self.patientToEdit.birthDate = self.selectedDate;
            }
            else 
            {
                Patient *newPatient = [[Patient alloc] init];
                newPatient.birthDate = self.selectedDate;
                
                [self.mainDelegate KalViewControllerDelegate:self didFinishSelectingPatientDOB:newPatient];
            }
        }
        else if ([self.calendarFunction isEqualToString:@"Setting WorkingWeightDate"])
        {
            NSLog(@" ");
            NSLog(@"Setting WorkingWeightDate");
            
            if (self.patientToEdit)
            {
                NSLog(@" ");
                NSLog(@"self.patientToEdit == YES");
                
                NSLog(@"self.patientToEdit.workingWeightDate = %@", self.selectedDate);
                
                self.patientToEdit.workingWeightDate = self.selectedDate;
                [self.mainDelegate KalViewControllerDelegate:self didFinishSelectingPatientDOB:self.patientToEdit];
            }
            else 
            {
                NSLog(@"self.patientToEdit == NO");
                
                Patient *newPatient = [[Patient alloc] init];
                newPatient.workingWeightDate = self.selectedDate;
                
                [self.mainDelegate KalViewControllerDelegate:self didFinishSelectingPatientDOB:newPatient];
            }
        }
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [tableView flashScrollIndicators];
}

- (NSInteger)getDaysDifferenceBetween:(NSDate *)dateA and:(NSDate *)dateB
{
    if ([dateA isEqualToDate:dateB])
        return 0;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *dateToRound = [dateA earlierDate:dateB];
    int flags = (NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit);
    NSDateComponents * dateComponents = 
    [gregorian components:flags fromDate:dateToRound];

    NSDate * roundedDate = [gregorian dateFromComponents:dateComponents];
    
    NSDate * otherDate = (dateToRound == dateA) ? dateB : dateA ;
    
    NSInteger diff = abs([roundedDate timeIntervalSinceDate:otherDate]);
    
    NSInteger daysDifference = floor(diff/(24 * 60 * 60));
    
    return daysDifference;
}

- (void)selectToday
{
    NSDate *today = [NSDate date];
    NSLog(@"Today's date is %@", today);
    
    [[self calendarView] selectDate:[KalDate dateFromNSDate:today]];
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark -
/*
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KalDataSourceChangedNotification object:nil];
}
 */

@end

