//
//  Screen.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 24/05/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import "Screen.h"

@implementation Screen
@synthesize	guid, appGuid, appApiKey, parentScreenGuid, menuText, menuIcon, menuIndex, screenType;
@synthesize jsonScreenOptions, customText, dateStampUTC, modifiedUTC, status;

@synthesize segueId = _segueId;
	
-(id)init
{
    if (self = [super init]) 
    {
		
	}
	return self;
}

- (void)dealloc 
{
    [super dealloc];
	[guid release];
	[appGuid release];
	[appApiKey release];
    [parentScreenGuid release];
    [menuText release];
	[menuIcon release];
	[screenType release];
	[jsonScreenOptions release];
	[customText release];
	[dateStampUTC release];
	[modifiedUTC release];
	[status release];
    [self.segueId release];
}

@end
