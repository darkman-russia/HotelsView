//
//  CityLocation.m
//  HotelsView
//
//  Created by Alexander Pozakchine on 31.01.13.
//  Copyright (c) 2013 Alexander Pozakchine. All rights reserved.
//

#import "CityLocation.h"

@implementation CityLocation

-(id) initWithCity:(City*)city
{
    if ( (self = [super init]) )
    {
        self.cityName = city.name;
        self.cityAlias = city.alias;
        self.countryName = city.country;
        self.hotelsCount = city.hotels;
        self.coord = CLLocationCoordinate2DMake(city.lat, city.lon);
    }
    return self;
}

- (NSString *)title
{
    return [NSString stringWithFormat:@"%@, %@", _countryName, _cityName];
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat:NSLocalizedString(@"HotelsMarkerTitle", @""), _hotelsCount];
}

- (CLLocationCoordinate2D)coordinate
{
    return _coord;
}

@end
