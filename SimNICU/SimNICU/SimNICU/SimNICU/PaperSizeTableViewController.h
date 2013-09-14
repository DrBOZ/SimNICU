//
//  PaperSizeTableViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 08/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaperSizeTableViewController;

@protocol PaperSizeTableViewControllerDelegate <NSObject>

- (void)paperSizeTableViewController:(PaperSizeTableViewController *)controller didSelectPaperSize:(NSString *)paperSize;

@end

@interface PaperSizeTableViewController : CBTableViewController

@property (nonatomic, weak) id <PaperSizeTableViewControllerDelegate> delegate;

@end
