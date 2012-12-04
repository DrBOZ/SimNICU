

#import "User.h"


@implementation User
@synthesize userGuid, userEmail, contactName, contactEmail, contactPhone, defaultAppGuid, isLoggedIn;	

-(id)init{
    if (self = [super init]) {
		
		
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
	[userGuid release];
    [userEmail release];
	[contactName release];
	[contactEmail release];
	[contactPhone release];
	[defaultAppGuid release];
 
}


@end
