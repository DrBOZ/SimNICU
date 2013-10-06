//
//  CBTableViewWebViewCell.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 06/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBTableViewWebViewCell : UITableViewCell

@property (nonatomic, strong) UIWebView *webView;

- (void)loadHMTLPageWithFilename:(NSString *)filename;

@end
