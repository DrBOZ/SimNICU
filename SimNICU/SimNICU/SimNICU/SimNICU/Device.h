

#import <Foundation/Foundation.h>


@interface Device : NSObject {
	
	NSString *deviceId;
	NSString *deviceModel;
	NSString *deviceVersion;
	NSString *deviceLatitude;
	NSString *deviceLongitude;
	NSString *deviceConnectionType;	
	NSString *customId;	
	
}

@property (nonatomic, retain) NSString *deviceId;
@property (nonatomic, retain) NSString *deviceModel;
@property (nonatomic, retain) NSString *deviceVersion;
@property (nonatomic, retain) NSString *deviceLatitude;
@property (nonatomic, retain) NSString *deviceLongitude;
@property (nonatomic, retain) NSString *deviceConnectionType;
@property (nonatomic, retain) NSString *customId;


@end
