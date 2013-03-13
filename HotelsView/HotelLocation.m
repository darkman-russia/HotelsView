//
//  HotelLocation.m
//  HotelsView
//
//  Created by Alexander Pozakchine on 30.01.13.
//  Copyright (c) 2013 Alexander Pozakchine. All rights reserved.
//

#import "HotelLocation.h"
#import "Hotel.h"

@implementation HotelLocation

-(id) initWithOwner:(id)owner
{
    if ( (self = [super init]) )
    {
        _owner = owner;
        NSArray* _ownerAsArray = (NSArray*)_owner;
        Hotel* hotel = [_ownerAsArray objectAtIndex:0];
        if ( [_ownerAsArray count] > 1 )
        {
            self.name  = [NSString stringWithFormat:NSLocalizedString(@"HotelsMarkerTitle", @""), [_ownerAsArray count]];
            self.subtitle = NSLocalizedString(@"ManyItemsSubtitle", @"");
        }
        else
        {
            self.name = hotel.name;
            self.subtitle = hotel.address;
        }
        self.coord = hotel.coordinate2D;
    }
    return self;
}

-(BOOL) isOwnerAHotel
{
    NSArray* _ownerAsArray = (NSArray*)_owner;
    return [_ownerAsArray count] == 1;
}

- (NSString *)title
{
    return _name;
}

- (NSString *)subtitle
{
    return _subtitle;
}

- (CLLocationCoordinate2D)coordinate
{
    return _coord;
}

- (NSArray*) items
{
    return _owner;
}

@end
