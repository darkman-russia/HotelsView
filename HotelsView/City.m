//
//  City.m
//  HotelsView
//
//  Created by Alexander Pozakchine on 28.01.13.
//  Copyright (c) 2013 Alexander Pozakchine. All rights reserved.
//

#import "City.h"

@implementation City

@synthesize ID;
@synthesize name;
@synthesize country;
@synthesize value;
@synthesize lon;
@synthesize lat;
@synthesize hotels;
@synthesize major;
@synthesize alias;

-(id) initWithJSON:(NSDictionary*)JSONObject
{
    if (self = [super init])
    {
        self.ID      = [JSONObject objectForKey:@"id"];
        self.name    = [JSONObject objectForKey:@"name"];
        self.country = [JSONObject objectForKey:@"country"];
        self.value   = [JSONObject objectForKey:@"value"];
        self.alias   = [JSONObject objectForKey:@"alias"];
        
        self.lon = [[JSONObject objectForKey:@"lon"] floatValue];
        self.lat = [[JSONObject objectForKey:@"lat"] floatValue];
        
        self.hotels = [[JSONObject objectForKey:@"hotels"] unsignedIntegerValue];
        
        self.major = [[JSONObject objectForKey:@"major"] boolValue];
    }
    return self;
}

@end
