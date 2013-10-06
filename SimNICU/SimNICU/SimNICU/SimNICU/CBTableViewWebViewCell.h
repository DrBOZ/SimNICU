//
//  CBTableViewWebViewCell.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 06/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBWebView.h"

@interface CBTableViewWebViewCell : UITableViewCell

@property (nonatomic, strong) CBWebView *webView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier webView:(CBWebView *)webView;

@end
