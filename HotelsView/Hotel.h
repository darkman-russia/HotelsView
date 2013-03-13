//
//  Hotel.h
//  HotelsView
//
//  Created by Alexander Pozakchine on 28.01.13.
//  Copyright (c) 2013 Alexander Pozakchine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Hotel : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* address;
@property (nonatomic, strong) NSString* currency;
@property (nonatomic) float lon;
@property (nonatomic) float lat;
@property (nonatomic) uint stars;
@property (nonatomic) uint price;
@property (nonatomic) CLLocationCoordinate2D coordinate2D;

-(id) initWithJSON:(NSDictionary*)JSONObject currency:(NSString*)currency;

@end
