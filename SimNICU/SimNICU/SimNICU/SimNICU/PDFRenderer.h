//
//  PDFRenderer.h
//  SimNICU
//
//  Created by Conrad Bosman on 29/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Patient.h"

@interface PDFRenderer : NSObject

+(void)drawPDF:(NSString*)fileName forPatient:(Patient *)patient;
+(void)drawImage:(UIImage*)image inRect:(CGRect)rect;

@end
