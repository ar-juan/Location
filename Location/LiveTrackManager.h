//
//  LiveTrackManager.h
//  Location
//
//  Created by Arjan on 03/02/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationTracker.h"

@interface LiveTrackManager : NSObject
+(id)sharedManager;
-(void)startTracking;
-(void)stopTracking;

@property LocationTracker * locationTracker;
@property (strong, nonatomic) LocationShareModel *sharedModel;
@end
