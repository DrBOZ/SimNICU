

#import <Foundation/Foundation.h>


@interface User : NSObject {

	NSString *userGuid;
	NSString *userEmail;
	NSString *contactName;
	NSString *contactEmail;
	NSString *contactPhone;
	NSString *defaultAppGuid;
	int isLoggedIn;

}

@property (nonatomic, retain) NSString *userGuid;
@property (nonatomic, retain) NSString *userEmail;
@property (nonatomic, retain) NSString *contactName;
@property (nonatomic, retain) NSString *contactEmail;
@property (nonatomic, retain) NSString *contactPhone;
@property (nonatomic, retain) NSString *defaultAppGuid;
@property (nonatomic) int isLoggedIn;


@end
