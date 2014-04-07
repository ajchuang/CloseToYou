//
//  SofAAnnotation.h
//  VFinder
//
//  Created by Alfred Huang on 2014/2/13.
//  Copyright (c) 2014年 Alfred Huang. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SofAAnnotation : MKPointAnnotation

- (void) setPhotoRef: (NSString*) fotoRef ;
- (NSString*) getPhotoRef ;

- (void) setId: (NSString*) sid ;
- (NSString*) getId ;

- (void) setName: (NSString*) nm ;
- (NSString*) getName ;

- (void) setVicinity: (NSString*) vic;
- (NSString*) getVicinity;

- (void) setReference: (NSString*) ref;
- (NSString*) getReference;

- (void) setIcon: (NSString*) icon;
- (NSString*) getIcon;

- (void) setDist: (CLLocationCoordinate2D) org my:(CLLocationCoordinate2D) pos;
- (double) getDist;
- (NSComparisonResult) compare: (SofAAnnotation*) otherObject;
@end
