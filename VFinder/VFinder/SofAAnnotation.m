//
//  SofAAnnotation.m
//  VFinder
//
//  Created by Alfred Huang on 2014/2/13.
//  Copyright (c) 2014年 Alfred Huang. All rights reserved.
//

#import "SofAAnnotation.h"
@interface SofAAnnotation ()
@property (strong, nonatomic) NSString *m_id;
@property (strong, nonatomic) NSString *m_photoRef;
@property (strong, nonatomic) NSString *m_name;
@property (strong, nonatomic) NSString *m_vicinity;
@property (strong, nonatomic) NSString *m_reference;
@property (strong, nonatomic) NSString *m_icon;
@property (nonatomic) double m_dist;
@end

@implementation SofAAnnotation

- (SofAAnnotation*) init {
    self = [super init];
    self.m_id = nil;
    self.m_name = nil;
    self.m_photoRef = nil;
    self.m_vicinity = nil;
    return self;
}

- (void) setPhotoRef: (NSString*) fotoRef {
    self.m_photoRef = [NSString stringWithString: fotoRef];
}

- (NSString*) getPhotoRef {
    return self.m_photoRef;
}

- (void) setId: (NSString*) sid {
    self.m_id = [NSString stringWithString: sid];
}

- (NSString*) getId {
    return self.m_id;
}

- (void) setName: (NSString*) nm {
    self.m_name = [NSString stringWithString: nm];
}

- (NSString*) getName {
    return self.m_name;
}

- (void) setVicinity: (NSString*) vic {
    self.m_vicinity = [NSString stringWithString: vic];
}

- (NSString*) getVicinity {
    return self.m_vicinity;
}

- (void) setReference: (NSString*) ref {
    self.m_reference = [NSString stringWithString:ref];
}

- (NSString*) getReference {
    return self.m_reference;
}

- (void) setIcon: (NSString*) icon {
    self.m_icon = [NSString stringWithString:icon];
}

- (NSString*) getIcon {
    return self.m_icon;
}

- (void) setDist: (CLLocationCoordinate2D) org my:(CLLocationCoordinate2D) pos {
    
    self.m_dist =
        (org.latitude  - pos.latitude)  * (org.latitude  - pos.latitude) +
        (org.longitude - org.longitude) * (org.longitude - org.longitude);
}

- (double) getDist {
    return self.m_dist;
}

- (NSComparisonResult) compare: (SofAAnnotation*) otherObject {
    
    if (self.m_dist > otherObject.m_dist)
        return NSOrderedDescending;
    else if (self.m_dist < otherObject.m_dist)
        return NSOrderedAscending;
    else
        return NSOrderedSame;
}



@end
