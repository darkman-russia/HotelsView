//
//  HotelLocation.h
//  HotelsView
//
//  Created by Alexander Pozakchine on 30.01.13.
//  Copyright (c) 2013 Alexander Pozakchine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HotelLocation : NSObject <MKAnnotation>
{
    id _owner;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coord;

-(id) initWithOwner:(id)owner;
-(BOOL) isOwnerAHotel;
-(NSArray*) items;

@end
