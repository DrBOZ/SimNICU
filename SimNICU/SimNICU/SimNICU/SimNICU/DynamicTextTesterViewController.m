//
//  DynamicTextTesterViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 07/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DynamicTextTesterViewController.h"

@interface DynamicTextTesterViewController ()

@end

@implementation DynamicTextTesterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *headline = [UILabel new];
    headline.frame = CGRectMake(5.0f, 150.0f, 320.0f, 22.0f);
    headline.text = @"Headline";
    headline.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    [self.view addSubview:headline];
    
    UILabel *subheadline = [UILabel new];
    subheadline.frame = CGRectMake(5.0f, 180.0f, 320.0f, 22.0f);
    subheadline.text = @"Subheadline";
    subheadline.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
    [self.view addSubview:subheadline];
    
    UILabel *caption1 = [UILabel new];
    caption1.frame = CGRectMake(5.0f, 210.0f, 320.0f, 22.0f);
    caption1.text = @"Caption1";
    caption1.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    
    [self.view addSubview:caption1];
    
    UILabel *caption2 = [UILabel new];
    caption2.frame = CGRectMake(5.0f, 240.0f, 320.0f, 22.0f);
    caption2.text = @"Caption2";
    caption2.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    
    [self.view addSubview:caption2];
    
    UILabel *body = [UILabel new];
    body.frame = CGRectMake(5.0f, 270.0f, 320.0f, 22.0f);
    body.text = @"Body";
    body.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    [self.view addSubview:body];
    
    UILabel *footnote = [UILabel new];
    footnote.frame = CGRectMake(5.0f, 300.0f, 320.0f, 22.0f);
    footnote.text = @"Footnote";
    footnote.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    
    [self.view addSubview:footnote];
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
