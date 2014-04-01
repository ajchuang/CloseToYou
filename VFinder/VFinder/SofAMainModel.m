//
//  SofAMainModel.m
//  VFinder
//
//  Created by Alfred Huang on 2014/2/6.
//  Copyright (c) 2014年 Alfred Huang. All rights reserved.
//

#import "SofAMainModel.h"
#import "SofAAnnotation.h"

@interface SofAMainModel ()
// user-input data
@property (nonatomic, strong) NSMutableString* m_userKeywords;
@property (nonatomic, strong) NSMutableString* m_userSearchType;
@property (nonatomic) double m_searchRadius;

// current found items
//@property (nonatomic, strong) NSMutableArray* m_foundVenus;

// current detailed view
@property (nonatomic, strong) NSString *m_name;
@property (nonatomic, strong) NSString *m_vicinity;
@property (nonatomic, strong) NSString *m_reference;
@property (nonatomic, strong) NSString *m_fotoRef;
@property (nonatomic, strong) NSString *m_icon;

// returned results
@property (nonatomic, strong) NSMutableArray* m_results;
@end

@implementation SofAMainModel

/* @lfred: It's a singletone - create the model with this method. */
+ (SofAMainModel*) getMainModel {
    static SofAMainModel* model = nil;
    
    if (model == nil) {
        model = [[SofAMainModel alloc] init];
    }
    
    return model;
}

- (SofAMainModel*) init {
    NSLog (@"!!! SofAMainModel::init !!!");

    self = [super init];
    self.m_userSearchType = [[NSMutableString alloc] init];
    self.m_userKeywords   = [[NSMutableString alloc] init];
    self.m_searchRadius   = 2.0;
    self.m_results        = [NSMutableArray new];
    
    //  self.m_foundVenus     = [NSMutableArray new];

    return self;
}

- (void) dealloc {
    NSLog (@"!!! SofAMainModel::dealloc !!!");
}

- (void) setKeyword: (NSString*) kwd {
    
    if (kwd != nil) {
        NSLog (@"setKeyword: %@", kwd);
        [self.m_userKeywords setString:kwd];
    } else {
        NSLog (@"!!! setKeyword nil pointer !!!");
    }
}

- (NSString*) getKeyword {
    NSLog (@"MainModel - getKeyword: %@", [NSString stringWithString:self.m_userKeywords]);
    return [NSString stringWithString:self.m_userKeywords];
}

- (void) setSearchType: (NSString*) tyd {
    
    if (tyd != nil) {
        NSLog (@"setSearchType: %@", tyd);
        [self.m_userSearchType setString:tyd];
    } else {
        NSLog (@"!!! setSearchType nil pointer !!!");
    }
}

- (NSString*) getSearchType {
    NSLog (@"MainModel - getSearchType %@", [NSString stringWithString: self.m_userSearchType]);
    return [NSString stringWithString: self.m_userSearchType];
}

- (void) setRadius: (double) r {
    self.m_searchRadius = r;
}

- (double) getRadius {
    return self.m_searchRadius;
}

- (void) updateResults: (NSMutableArray*)results {
    [self.m_results removeAllObjects];
    [self.m_results addObjectsFromArray:results];
}

- (NSMutableArray*) getCurrentResults {
    return self.m_results;
}

- (BOOL) setDetailItem: (SofAAnnotation*) annotation {
    
    if ([annotation isKindOfClass: [SofAAnnotation class]] == NO)
        return NO;
    
    self.m_name = [annotation getName];
    self.m_vicinity = [annotation getVicinity];
    self.m_reference = [annotation getReference];
    self.m_icon = [annotation getIcon];
    
    if ([annotation getPhotoRef] != nil)
        self.m_fotoRef = [NSString stringWithString:[annotation getPhotoRef]];
    
    return YES;
}

- (BOOL) setDetailItemByBM: (Bookmark*) bm {
    self.m_name = bm.m_name;
    self.m_vicinity = bm.m_vicinity;
    self.m_reference = nil;
    self.m_icon = bm.m_icon;
    self.m_fotoRef = bm.m_image;
    
    return YES;
}

- (NSString*) getHighlightedName {
    return self.m_name  ;
}

- (NSString*) getHighlightedVicinity {
    return self.m_vicinity;
}

- (NSString*) getHighlightedRef {
    return self.m_reference;
}

- (NSString*) getHighlightedFotoRef {
    return self.m_fotoRef;
}

- (NSString*) getHighlightedIcon {
    return self.m_icon;
}

- (void) clearCurrentViewInfo {
    self.m_name = nil;
    self.m_vicinity = nil;
    self.m_reference = nil;
    self.m_fotoRef = nil;
    self.m_icon = nil;
}

@end
