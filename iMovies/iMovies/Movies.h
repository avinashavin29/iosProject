//
//  Movies.h
//  iMovies
//
//  Created by Badri on 25/07/14.
//  Copyright (c) 2014 Badri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Movies : NSManagedObject

@property (nonatomic, retain) NSString * movieName;
@property (nonatomic, retain) NSString * movieDesc;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * cast;
@property (nonatomic, retain) NSString * showTimes;
@property (nonatomic, retain) NSString * price;

@end
