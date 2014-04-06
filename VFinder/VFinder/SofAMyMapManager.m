//
//  SofAMyMapManager.m
//  VFinder
//
//  Created by Alfred Huang on 4/6/14.
//  Copyright (c) 2014 Alfred Huang. All rights reserved.
//
// -----------------------------------------------------------------------------------------------------------
// Note: I used the reference codes @ http://www.raywenderlich.com/13160/using-the-google-places-api-with-mapkit
// It's a tutorial of Google API. I transformed the reference codes into the same API used in the previous FW.

//#import <COMSMapManager/COMSMapManager.h>
#import "SofAMyMapManager.h"
#import "SofAMainModel.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define M_MY_QUERY @"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@"

@interface SofAMyMapManager ()
+ (void)dataFetchComplete:(NSData *)responseData;
@end

@implementation SofAMyMapManager

static NSMutableArray* sm_places = nil;
void (^sm_comp) (NSMutableArray*);

+ (void) nearestVenuesForLatLong: (CLLocationCoordinate2D)loc
                    withinRadius: (double) r
                        forQuery: (NSString*) keyword
                       queryType: (NSString*) type
                googleMapsAPIKey: (NSString*) api
                searchCompletion: (void (^) (NSMutableArray*)) complete {
    
    sm_comp = complete;
    NSString *url =
        [NSString stringWithFormat: M_MY_QUERY, loc.latitude, loc.longitude, [NSString stringWithFormat:@"%f", r], type, [SofAMainModel getMyApiKey]];
    
    // Retrieve the results of the URL.
    dispatch_async (kBgQueue, ^{
        // sleep 3 seconds to test cancenl function
        [NSThread sleepForTimeInterval: 3.0];
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
        [self performSelectorOnMainThread:@selector(dataFetchComplete:) withObject:data waitUntilDone:NO];
    });
}

+ (void)dataFetchComplete: (NSData *)responseData {
    
    NSLog (@"dataFetchComplete");
    //parse out the json data
    NSError* error;
    NSDictionary* json =
        [NSJSONSerialization
          JSONObjectWithData:responseData
                     options:kNilOptions
                       error:&error];
    
    // pick up the "results" as a key
    sm_places = [json objectForKey: @"results"];
    
    //Write out the data to the console.
    //NSLog (@"Google Data: %@", sm_places);
    
    sm_comp (sm_places);
}


@end
