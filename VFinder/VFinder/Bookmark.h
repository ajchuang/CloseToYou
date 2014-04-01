//
//  Bookmark.h
//  VFinder
//
//  Created by Alfred Huang on 3/14/14.
//  Copyright (c) 2014 Alfred Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Bookmark : NSManagedObject

@property (nonatomic, retain) NSString * m_name;
@property (nonatomic, retain) NSString * m_vicinity;
@property (nonatomic, retain) NSString * m_icon;
@property (nonatomic, retain) NSString * m_image;

@end
