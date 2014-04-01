//
//  SofAMainModel.h
//  VFinder
//
//  Created by Alfred Huang on 2014/2/6.
//  Copyright (c) 2014年 Alfred Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SofAAnnotation.h"
#import "Bookmark.h"

@interface SofAMainModel : NSObject
+ (SofAMainModel*) getMainModel;

- (void) setKeyword: (NSString*) kwd;
- (NSString*) getKeyword;

- (void) setSearchType: (NSString*) typ;
- (NSString*) getSearchType;

- (void) setRadius: (double) r;
- (double) getRadius;

- (void) updateResults: (NSMutableArray*) results;
- (NSMutableArray*) getCurrentResults;

// @selected Venue info
- (BOOL) setDetailItem: (SofAAnnotation*) annotation;
- (BOOL) setDetailItemByBM: (Bookmark*) bm;
- (NSString*) getHighlightedName;
- (NSString*) getHighlightedVicinity;
- (NSString*) getHighlightedRef;
- (NSString*) getHighlightedFotoRef;
- (NSString*) getHighlightedIcon;
- (void) clearCurrentViewInfo;
@end
