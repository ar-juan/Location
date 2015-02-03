//
//  LiveTrackManager.m
//  Location
//
//  Created by Arjan on 03/02/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "LiveTrackManager.h"

#define SEND_LOCATION_UPDATE_TO_SERVER_TIME_INTERVAL 120.0

@implementation LiveTrackManager
//Class method to make sure the share model is synch across the app
+ (id)sharedManager
{
    static id shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

-(void)startTracking {
    if ([self backgroundRefreshStatusEnabled]) {
        [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
        self.locationTracker = [[LocationTracker alloc]init];
        [self.locationTracker startLocationTracking];
        
        //Send the best location to server every SEND_LOCATION_UPDATE_TO_SERVER_TIME_INTERVAL seconds
        NSTimeInterval time = SEND_LOCATION_UPDATE_TO_SERVER_TIME_INTERVAL;
        self.sharedModel = [LocationShareModel sharedModel];
        self.sharedModel.locationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:time
                                                                                target:self
                                                                              selector:@selector(updateLocation)
                                                                              userInfo:nil
                                                                               repeats:YES];
    }
}

-(void)stopTracking {
    [self.sharedModel.locationUpdateTimer invalidate];
    self.sharedModel.locationUpdateTimer = nil;
    [self.locationTracker stopLocationTracking];
}

-(void)updateLocation {
    NSLog(@"updateLocation");
    [self.locationTracker updateLocationToServer];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Sending update to server" object:nil];
}


-(bool)backgroundRefreshStatusEnabled {
    UIAlertView * alert;
    
    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        return NO;
        
    } else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disabled."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    } else {
        return YES;
    }
}
@end
