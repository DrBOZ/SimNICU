//
//  SyncServer.h
//  SimNICU
//
//  Created by Conrad Bosman on 06/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

#define SESSION_ID @"SimNICU"

@interface SyncServer : NSObject <GKSessionDelegate>

@property (nonatomic, assign) int maxClients;
@property (nonatomic, strong, readonly) NSArray *connectedClients;
@property (nonatomic, strong, readonly) GKSession *session;

- (void)startAcceptingConnectionsForSessionID:(NSString *)sessionID;

@end
