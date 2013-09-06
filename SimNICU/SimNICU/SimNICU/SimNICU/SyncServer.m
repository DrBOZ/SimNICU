//
//  SyncServer.m
//  SimNICU
//
//  Created by Conrad Bosman on 06/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "SyncServer.h"

@implementation SyncServer
{
    NSMutableArray *_connectedClients;
}

- (void)startAcceptingConnectionsForSessionID:(NSString *)sessionID
{
    _connectedClients = [NSMutableArray arrayWithCapacity:self.maxClients];
    
    _session = [[GKSession alloc] initWithSessionID:sessionID displayName:nil sessionMode:GKSessionModeServer];
    _session.delegate = self;
    _session.available = YES;
}

- (NSArray *)connectedClients
{
    return _connectedClients;
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    #ifdef DEBUG
    NSLog(@"SyncServer: peer %@ changed state %d", peerID, state);
    #endif
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
    #ifdef DEBUG
    NSLog(@"SyncServer: connection request from peer %@", peerID);
    #endif
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
    #ifdef DEBUG
	NSLog(@"SyncServer: connection with peer %@ failed %@", peerID, error);
    #endif
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
    #ifdef DEBUG
	NSLog(@"SyncServer: session failed %@", error);
    #endif
}

@end
