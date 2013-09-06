//
//  SyncClient.m
//  SimNICU
//
//  Created by Conrad Bosman on 06/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "SyncClient.h"

@implementation SyncClient
{
    NSMutableArray *_availableServers;
}

- (void)startSearchingForServersWithSessionID:(NSString *)sessionID
{
	_availableServers = [NSMutableArray arrayWithCapacity:10];
    
	_session = [[GKSession alloc] initWithSessionID:sessionID displayName:nil sessionMode:GKSessionModeClient];
	_session.delegate = self;
	_session.available = YES;
}

- (NSArray *)availableServers
{
	return _availableServers;
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    #ifdef DEBUG
	NSLog(@"SyncClient: peer %@ changed state %d", peerID, state);
    #endif
    
    switch (state)
	{
            // The client has discovered a new server.
		case GKPeerStateAvailable:
			if (![_availableServers containsObject:peerID])
			{
				[_availableServers addObject:peerID];
				[self.delegate syncClient:self serverBecameAvailable:peerID];
			}
			break;
            
            // The client sees that a server goes away.
		case GKPeerStateUnavailable:
			if ([_availableServers containsObject:peerID])
			{
				[_availableServers removeObject:peerID];
				[self.delegate syncClient:self serverBecameUnavailable:peerID];
			}
			break;
            
		case GKPeerStateConnected:
			break;
            
		case GKPeerStateDisconnected:
			break;
            
		case GKPeerStateConnecting:
			break;
	}
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
    #ifdef DEBUG
	NSLog(@"SyncClient: connection request from peer %@", peerID);
    #endif
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
    #ifdef DEBUG
	NSLog(@"SyncClient: connection with peer %@ failed %@", peerID, error);
    #endif
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
    #ifdef DEBUG
	NSLog(@"SyncClient: session failed %@", error);
    #endif
}

@end
