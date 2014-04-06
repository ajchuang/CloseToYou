//
//  SofAMyMapManager.h
//  VFinder
//
//  Created by Alfred Huang on 4/6/14.
//  Copyright (c) 2014 Alfred Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"

@interface SofAMyMapManager : NSObject

+ (void) nearestVenuesForLatLong: (CLLocationCoordinate2D)loc
                    withinRadius: (double) r
                        forQuery: (NSString*) keyword
                       queryType: (NSString*) type
                googleMapsAPIKey: (NSString*) api
                searchCompletion: (void (^) (NSMutableArray*)) complete;

@end
