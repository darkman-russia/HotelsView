//
//  CityLocation.h
//  HotelsView
//
//  Created by Alexander Pozakchine on 31.01.13.
//  Copyright (c) 2013 Alexander Pozakchine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "City.h"

@interface CityLocation : NSObject <MKAnnotation>

//@property (nonatomic, retain) NSString* name;
//@property (nonatomic, retain) NSString* subtitle;
@property (nonatomic, retain) NSString* cityName;
@property (nonatomic, retain) NSString* countryName;
@property (nonatomic, retain) NSString* cityAlias;
@property (nonatomic) NSUInteger hotelsCount;
@property (nonatomic, assign) CLLocationCoordinate2D coord;

-(id) initWithCity:(City*)city;

@end
