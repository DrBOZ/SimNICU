//
//  SimNICUWebView.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 01/12/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

@interface SimNICUWebView : UIWebView

@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) NSNumber *heightForRowAtIndexPath;
@property (nonatomic, strong) NSString *resource;
@property (nonatomic, strong) NSString *cellIdentifier;

@end
