//
//  RoundImage.h
//  SimNICU
//
//  Created by Conrad Bosman on 19/05/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoundImage : NSObject

+(UIImage *)makeRoundCornerImage:(UIImage*)img :(int) cornerWidth :(int) cornerHeight;

@end
