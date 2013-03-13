//
//  ServerConnect.h
//  HotelsView
//
//  Created by Alexander Pozakchine on 26.01.13.
//  Copyright (c) 2013 Alexander Pozakchine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Hotel;

typedef void (^FetchBlock)(NSArray *items, NSError *error);

@interface ServerConnect : NSObject
{
    NSMutableDictionary* _cities;
    NSMutableArray*      _hotels;
}

@property (strong) NSOperationQueue* operationQueue;
@property (nonatomic, retain) NSMutableDictionary* cities;
@property (nonatomic, retain) NSMutableArray*      hotels;

+ (ServerConnect*) sharedServerConnect;

-(void) fetchHotelsByKeyWord:(NSString*)termString block:(FetchBlock)block;
-(void) fetchHotelsByRegion:(float)left top:(float)top right:(float)right
                     bottom:(float)bottom zoom:(NSUInteger)zoom block:(FetchBlock)block;
-(void) fetchHotelsByKeyCity:(NSString*)termString block:(FetchBlock)block;

-(void) addCityToDictionary:(NSDictionary*)cityDictionary;
-(void) addHotelToArray:(NSDictionary*)hotelDictionary;

@end


