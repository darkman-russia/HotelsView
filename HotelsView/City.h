//
//  City.h
//  HotelsView
//
//  Created by Alexander Pozakchine on 28.01.13.
//  Copyright (c) 2013 Alexander Pozakchine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property (nonatomic, strong) NSString* ID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* country;
@property (nonatomic, strong) NSString* value;
@property (nonatomic) float lon;
@property (nonatomic) float lat;
@property (nonatomic) uint hotels;
@property (nonatomic) BOOL major;
@property (nonatomic, strong) NSString* alias;

-(id) initWithJSON:(NSDictionary*)JSONObject;

@end
