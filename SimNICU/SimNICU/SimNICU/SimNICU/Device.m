

#import "Device.h"


@implementation Device
@synthesize deviceId, deviceModel, deviceVersion, customId;
@synthesize deviceLatitude, deviceLongitude, deviceConnectionType;	

-(id)init{
    if (self = [super init]) {
		
		
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
	[deviceId release];
    [deviceModel release];
    [deviceLatitude release];
	[deviceLongitude release];
    [deviceConnectionType release];
    [customId release];
 
}


@end
