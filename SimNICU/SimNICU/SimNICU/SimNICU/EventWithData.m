//
//  EventWithData.m
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "EventWithData.h"

@implementation EventWithData

- (EventWithData *)initWithType:(NSString *)_type bubbles:(BOOL)_bubbles cancelable:(BOOL)_cancelable dataInit:(EventData *)_dataInit
{
    if ((self = [super initWithType:_type bubbles:_bubbles cancelable:_cancelable]))
    {
        if (!_dataInit)
        {
            self.data = [[EventData alloc] init];
        }
        else
        {
            self.data = _dataInit;
        }
    }
    
    return self;
}

- (EventWithData *)clone
{
    EventWithData *eventWithData = [[EventWithData alloc] initWithType:self.type bubbles:self.bubbles cancelable:self.cancelable dataInit:self.data];
    
    return eventWithData;
}

- (NSString *)toString
{
    // return formatToString("DataEvent", "type", "cancelable", "eventPhase", "dataInit");
    return nil;
}



@end
