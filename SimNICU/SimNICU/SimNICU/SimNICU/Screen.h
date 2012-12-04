//
//  Screen.h
//  SimNICU
//
//  Created by Conrad Bosman on 24/05/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Screen : NSObject 
{
	NSString *guid;
	NSString *appGuid;
	NSString *appApiKey;
	NSString *parentScreenGuid;
	NSString *menuText;
	NSString *menuIcon;
	int menuIndex;
	NSString *screenType;
	NSString *jsonScreenOptions;
	NSString *customText;
	NSString *dateStampUTC;
	NSString *modifiedUTC;
	NSString *status;
    
    NSString *segueID;

	NSDictionary *screenVars;
}

@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSString *appGuid;
@property (nonatomic, retain) NSString *appApiKey;
@property (nonatomic, retain) NSString *parentScreenGuid;
@property (nonatomic, retain) NSString *menuIcon;
@property (nonatomic) int menuIndex;
@property (nonatomic, retain) NSString *screenType;
@property (nonatomic, retain) NSString *jsonScreenOptions;
@property (nonatomic, retain) NSString *customText;
@property (nonatomic, retain) NSString *dateStampUTC;
@property (nonatomic, retain) NSString *modifiedUTC;
@property (nonatomic, retain) NSString *status;


@property (nonatomic, retain) NSString *menuText;   // iOS 5.1 version
@property (nonatomic, retain) NSString *segueId;

@property (nonatomic, retain) NSDictionary *screenVars;


@end
