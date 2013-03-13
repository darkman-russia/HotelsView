//
//  Hotel.m
//  HotelsView
//
//  Created by Alexander Pozakchine on 28.01.13.
//  Copyright (c) 2013 Alexander Pozakchine. All rights reserved.
//

#import "Hotel.h"

@implementation Hotel

-(id) initWithJSON:(NSDictionary*)JSONObject currency:(NSString*)currency
{
    if (self = [super init])
    {
        self.name     = [JSONObject objectForKey:@"Name"];
        self.address  = [JSONObject objectForKey:@"Address"];
        self.currency = currency;
        self.lat      = [[JSONObject objectForKey:@"Latitude"] floatValue];
        self.lon      = [[JSONObject objectForKey:@"Longitude"] floatValue];
        self.stars    = [[JSONObject objectForKey:@"Stars"] unsignedIntegerValue];
        self.price    = [[JSONObject objectForKey:@"HotelPrice"] unsignedIntegerValue];
        self.coordinate2D = CLLocationCoordinate2DMake(self.lat, self.lon);
    }
    return self;
}

@end
