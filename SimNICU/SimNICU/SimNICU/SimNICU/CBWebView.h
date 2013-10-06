//
//  CBWebView.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 06/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBWebView : UIWebView

@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) NSNumber *heightForRowAtIndexPath;
@property (nonatomic, strong) NSString *resource;
@property (nonatomic, strong) NSString *cellIdentifier;

- (void)loadHMTLPageWithFilename:(NSString *)filename;

@end
