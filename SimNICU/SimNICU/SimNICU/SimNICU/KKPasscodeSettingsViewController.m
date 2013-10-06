//
// Copyright 2011-2012 Kosher Penguin LLC 
// Created by Adar Porat (https://github.com/aporat) on 1/16/2012.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//		http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "PortraitOnlyNavigationController.h"
#import "KKPasscodeSettingsViewController.h"
#import "KKPasscodeViewController.h"
#import "KKPasscodeLock.h"
#import "KKKeychain.h"
#import "AppDelegate.h"

@interface KKPasscodeSettingsViewController()

@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation KKPasscodeSettingsViewController

@synthesize delegate = _delegate;

#pragma mark - UIViewController methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //delegate
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //menu table
        // iOS 7 specifics
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height)) style:UITableViewStyleGrouped];
        }
        else
        {
            self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64.0f)) style:UITableViewStyleGrouped];
            
            self.view.backgroundColor = [UIColor blackColor];
        }
        self.myTableView.rowHeight = 44.0f;
        self.myTableView.dataSource = self;
        self.myTableView.delegate = self;
        self.myTableView.separatorColor = [UIColor grayColor];
        self.myTableView.hidden = NO;
        self.myTableView.bounces = YES;
        self.myTableView.scrollEnabled = YES;
        [self.view addSubview:self.myTableView];
        
        // add TableView background
        [CBTableViewController setBackgroundForTableView:self.myTableView];
        
        /*
#if USE_DIMPLE_BACKGROUND
        
        // set background colour
        if (appDelegate.window.bounds.size.height == 568)
        {
            // 4 inch Retina
            UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_4_PORTRAIT_PNG]];
            [tempImageView setFrame:self.myTableView.frame];
            
            self.myTableView.backgroundView = tempImageView;
        }
        else
        {
            // 3.5 inch Retina
            UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_35_PORTRAIT_PNG]];
            [tempImageView setFrame:self.myTableView.frame];
            
            self.myTableView.backgroundView = tempImageView;
        }
        
#else
        self.myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
#endif
         */
        
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
	self.navigationItem.title = NSLocalizedString(@"Passcode Lock", @"");
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    if (!([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0))
    {
        _eraseDataSwitch = [[UISwitch alloc] init];
        [_eraseDataSwitch addTarget:self action:@selector(eraseDataSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        
        _passcodeLockOn = [[KKKeychain getStringForKey:@"passcode_on"] isEqualToString:@"YES"];
        _eraseDataOn = [[KKKeychain getStringForKey:@"erase_data_on"] isEqualToString:@"YES"];
        _eraseDataSwitch.on = _eraseDataOn;
    }
}

- (void)viewDidUnload
{  
    _eraseDataSwitch = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"PasscodeLockSettings" withError:nil];
    
#endif
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
    {
        _eraseDataSwitch = [[UISwitch alloc] init];
        
        // iOS 7 specifics
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            _eraseDataSwitch.onTintColor = [UIColor redColor];
        }
        
        [_eraseDataSwitch addTarget:self action:@selector(eraseDataSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        
        _passcodeLockOn = [[KKKeychain getStringForKey:@"passcode_on"] isEqualToString:@"YES"];
        _eraseDataOn = [[KKKeychain getStringForKey:@"erase_data_on"] isEqualToString:@"YES"];
        _eraseDataSwitch.on = _eraseDataOn;
    }
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        // do nothing
    }
    else
    {
        self.myTableView.backgroundColor = [UIColor clearColor];
    }
    
    /*
#if USE_DIMPLE_BACKGROUND
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // set background colour
    if (appDelegate.window.bounds.size.height == 568)
    {
        // 4 inch Retina
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_4_PORTRAIT_PNG]];
        [tempImageView setFrame:self.myTableView.frame];
        
        self.myTableView.backgroundView = tempImageView;
    }
    else
    {
        // 3.5 inch Retina
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_35_PORTRAIT_PNG]];
        [tempImageView setFrame:self.myTableView.frame];
        
        self.myTableView.backgroundView = tempImageView;
    }
    
#else
    // self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
#endif
     */
    
}

// Tell the system what we support
- (NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"KKPasscodeSettingsViewController: supportedInterfaceOrientations");
    return UIInterfaceOrientationMaskPortrait;
}

// Tell the system It should autorotate
- (BOOL) shouldAutorotate
{
    NSLog(@"KKPasscodeSettingsViewController: shouldAutorotate");
    return NO;
}

// Tell the system which initial orientation we want to have
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    NSLog(@"KKPasscodeSettingsViewController: preferredInterfaceOrientationForPresentation");
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	NSLog(@"KKPasscodeSettingsViewController: shouldAutorotateToInterfaceOrientation");
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) || (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
    {
		_eraseDataOn = YES;
		[KKKeychain setString:@"YES" forKey:@"erase_data_on"];
	} else {
		_eraseDataOn = NO;
		[KKKeychain setString:@"NO" forKey:@"erase_data_on"];
	}
	[_eraseDataSwitch setOn:_eraseDataOn animated:YES];
}

- (void)eraseDataSwitchChanged:(id)sender 
{
	if (_eraseDataSwitch.on) {
		NSString* title = [NSString stringWithFormat:NSLocalizedString(@"All data in this app will be erased after %d failed passcode attempts.", @""), [[KKPasscodeLock sharedLock] attemptsAllowed]];
		
		UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:NSLocalizedString(@"Enable", @"") otherButtonTitles:nil];
		[sheet showInView:self.view];
	} else {
		_eraseDataOn = NO;
		[KKKeychain setString:@"NO" forKey:@"erase_data_on"];
	}		 
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if ([[KKPasscodeLock sharedLock] eraseOption]) {
		return 3;
	}
	
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if (section == 2)
    {
		return [NSString stringWithFormat:NSLocalizedString(@"Erase all content in the app after %d failed passcode attempts.", @""), [[KKPasscodeLock sharedLock] attemptsAllowed]];;
	} else {
		return @"";
	}
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString *CellIdentifier = @"KKPasscodeSettingsCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
	}
    
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    cell.textLabel.textColor = [UIColor blackColor];
    
	
	if (indexPath.section == 0)
    {
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		if (_passcodeLockOn)
        {
			cell.textLabel.text = NSLocalizedString(@"Turn Passcode Off", @"");
		}
        else
        {
			cell.textLabel.text = NSLocalizedString(@"Turn Passcode On", @"");
		}
	}
    else if (indexPath.section == 1)
    {
		cell.textLabel.text = NSLocalizedString(@"Change Passcode", @"");
		cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (!_passcodeLockOn)
        {
			cell.textLabel.textColor = [UIColor grayColor];
		}
	}
    else if (indexPath.section == 2)
    {
		cell.textLabel.text = NSLocalizedString(@"Erase Data", @"");
		cell.accessoryView = _eraseDataSwitch;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (_passcodeLockOn)
        {
			cell.textLabel.textColor = [UIColor blackColor];
			_eraseDataSwitch.enabled = YES;
		} else
        {
			cell.textLabel.textColor = [UIColor grayColor];
			_eraseDataSwitch.enabled = NO;
		}
	}
	
	return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	// Turn passcode on and off
    if (indexPath.section == 0) {
		KKPasscodeViewController* vc = [[KKPasscodeViewController alloc] initWithNibName:nil 
                                                                                  bundle:nil];
		vc.delegate = self;
		
		if (_passcodeLockOn)
        {
			vc.mode = KKPasscodeModeDisabled;
		}
        else
        {
			vc.mode = KKPasscodeModeSet;
		}
		
        PortraitOnlyNavigationController *nav = [[PortraitOnlyNavigationController alloc] initWithRootViewController:vc];
        
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			nav.modalPresentationStyle = UIModalPresentationFormSheet;
			nav.navigationBar.barStyle = UIBarStyleBlack;
			nav.navigationBar.opaque = NO;
		} else {
			nav.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
			nav.navigationBar.translucent = self.navigationController.navigationBar.translucent;
			nav.navigationBar.opaque = self.navigationController.navigationBar.opaque;
			nav.navigationBar.barStyle = self.navigationController.navigationBar.barStyle;		
		}
		
		[self.navigationController presentModalViewController:nav animated:YES];
		
        // change passcode	
	} else if (indexPath.section == 1 && _passcodeLockOn) {
		KKPasscodeViewController *vc = [[KKPasscodeViewController alloc] initWithNibName:nil bundle:nil];
		vc.delegate = self;
		
		vc.mode = KKPasscodeModeChange;							
		
        PortraitOnlyNavigationController *nav = [[PortraitOnlyNavigationController alloc] initWithRootViewController:vc];
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			nav.modalPresentationStyle = UIModalPresentationFormSheet;
			nav.navigationBar.barStyle = UIBarStyleBlack;
			nav.navigationBar.opaque = NO;
		} else {
			nav.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
			nav.navigationBar.translucent = self.navigationController.navigationBar.translucent;
			nav.navigationBar.opaque = self.navigationController.navigationBar.opaque;
			nav.navigationBar.barStyle = self.navigationController.navigationBar.barStyle;		
		}
		
		[self.navigationController presentModalViewController:nav animated:YES];	
	}
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didSettingsChanged:(KKPasscodeViewController*)viewController 
{
	_passcodeLockOn = [[KKKeychain getStringForKey:@"passcode_on"] isEqualToString:@"YES"];
	_eraseDataOn = [[KKKeychain getStringForKey:@"erase_data_on"] isEqualToString:@"YES"];
	_eraseDataSwitch.on = _eraseDataOn;
    
	[self.myTableView reloadData];
	
	if ([_delegate respondsToSelector:@selector(didSettingsChanged:)]) {
		[_delegate performSelector:@selector(didSettingsChanged:) withObject:self];
	}
	
}

- (void)done
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
    {
        NSLog(@"iOS 5.0 and greater");
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"iOS 4.3");
        [self.parentViewController dismissModalViewControllerAnimated:YES];
    }
}

@end

