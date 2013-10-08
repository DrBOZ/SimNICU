//
//  DrugInfoSimpleTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 10/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DrugInfoSimpleTableViewController.h"
#import "SimNICUWebView.h"
#import "DrugDatabase.h"
#import "DrugCategory.h"
#import "DrugSection.h"
#import "AppDelegate.h"
#import "DrugInfo.h"
#import "Drug.h"

@interface DrugInfoSimpleTableViewController ()

@property (nonatomic, strong) NSMutableArray *drugSections;
@property (nonatomic, strong) DrugCategory *drugCategory;
@property (nonatomic, strong) Drug *drug;

@end

@implementation DrugInfoSimpleTableViewController
{
    NSMutableArray *webViewSections;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.selectedDrug;
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // cycle through drug database and find current drugCategory
    DrugCategory *drugCategory;
    
    for (drugCategory in appDelegate.drugDatabase.drugCategories)
    {
        if ([drugCategory.name isEqualToString:@"Drugs"]) // will have to substitue this later
        {
            Drug *drug;
            
            // find selected drug
            for(drug in drugCategory.drugs)
            {
                if ([drug.name isEqualToString:self.selectedDrug])
                {
                    self.drug = drug;
                }
            }
        }
    }
    
    // Setup section array
    webViewSections = [[NSMutableArray alloc] initWithCapacity:[self.drug.info count]];
    
    NSMutableArray *webViewRows;
    SimNICUWebView *webView;
    DrugInfo *info;
    
    // cycle through all the sections in self.drug.info
    for (info in self.drug.info)
    {
        webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
        webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake([info.inset floatValue], 0.0f, 300.0f, [info.heightForRow floatValue])];
        webView.header = info.header;
        webView.resource = info.htmlFile;
        webView.cellIdentifier = info.header;
        webView.heightForRowAtIndexPath = info.heightForRow;
        [self formatAndLoadSimNICUWebView:webView];
        [webViewRows addObject:webView];
        
        [webViewSections addObject:webViewRows];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [webViewSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [webViewSections[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[webViewSections[section] objectAtIndex:0] header];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 44.0f;
    
    if (section == 0)
    {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.1)
        {
            height = 66.0f;
        }
        else
        {
            height = 55.0f;
        }
    }
    
    // return height;
    return 22.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[webViewSections[indexPath.section] objectAtIndex:indexPath.row] heightForRowAtIndexPath] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [[webViewSections[indexPath.section] objectAtIndex:indexPath.row] cellIdentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    [cell addSubview:[webViewSections[indexPath.section] objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (SimNICUWebView *)formatAndLoadSimNICUWebView:(SimNICUWebView *)webView
{
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    webView.scalesPageToFit = NO;
    
    if ([webView respondsToSelector:@selector(scrollView)]) {
        webView.scrollView.scrollEnabled = NO;
    }
    else
    {
        for (id subview in webView.subviews)
            if ([[subview class] isSubclassOfClass: [UIScrollView class]])
                ((UIScrollView *)subview).scrollEnabled = NO;
    }
    
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    NSURL *htmlURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:webView.resource ofType:@"html"] isDirectory:NO];
    NSMutableURLRequest *URLReq = [NSMutableURLRequest requestWithURL:htmlURL];
    [URLReq setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [webView loadRequest:URLReq];
    
    return webView;
}


@end
