//
//  ServerConnect.m
//  HotelsView
//
//  Created by Alexander Pozakchine on 26.01.13.
//  Copyright (c) 2013 Alexander Pozakchine. All rights reserved.
//

#import "ServerConnect.h"
#import "Constants.h"
#import "City.h"
#import "Hotel.h"

@implementation ServerConnect

@synthesize operationQueue = _operationQueue;
@synthesize cities         = _cities;
@synthesize hotels         = _hotels;

static ServerConnect* sServerConnect = nil;

#pragma mark Singletone methods

+ (ServerConnect*) sharedServerConnect
{
   @synchronized (self)
    {
        if (sServerConnect == nil)
        {
            sServerConnect = [NSAllocateObject([self class], 0, NULL) init];
        }
    return sServerConnect;
    }
}

- (id)init;
{
    if ( ( self = [super init] ) )
    {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 7;
        _cities = [[NSMutableDictionary alloc] init];
        _hotels = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [[self sharedServerConnect] retain];
}

- (id) copyWithZone:(NSZone*)zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (NSUInteger) retainCount
{
    return NSUIntegerMax;
}

- (id) autorelease
{
    return self;
}

- (oneway void) release
{
}

- (void) dealloc
{
    [_cities release];
    [_hotels release];
    [super dealloc];
}

#pragma mark HTTP Request
-(void) fetchHotelsByKeyWord:(NSString *)termString block:(FetchBlock)block
{
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSError *error = nil;
        NSHTTPURLResponse *response = nil;
        NSString* langString = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString* URLString = [NSString stringWithFormat:GET_CITY_BY_KEY_WORD, termString, langString];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:
                [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:120.0f];
       // NSLog(@"%@", URLString);
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response
                                                         error:&error];
        NSArray* JSON = nil;
        
        if ( data != nil )
        {
           JSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
           if ( !JSON )
           {
               NSMutableDictionary* userDetails = [NSMutableDictionary dictionary];
               [userDetails setValue:NSLocalizedString(@"edErrorJSONFormat", @"")
                              forKey:NSLocalizedDescriptionKey];
               error = [NSError errorWithDomain:APP_DOMAIN code:300 userInfo:userDetails];
           }
        }
        else
        {
            NSMutableDictionary* userDetails = [NSMutableDictionary dictionary];
            [userDetails setValue:NSLocalizedString(@"edErrorDataNil", @"")
                           forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:APP_DOMAIN code:200 userInfo:userDetails];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ( error )
                block( nil, error );
            else
                block( JSON, nil );
        }];
    }];
    
    [blockOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [self.operationQueue addOperation:blockOperation];
}

-(void) fetchHotelsByRegion:(float)left top:(float)top right:(float)right
                     bottom:(float)bottom zoom:(NSUInteger)zoom block:(FetchBlock)block
{
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSError *error = nil;
        NSHTTPURLResponse *response = nil;
        
        
        NSString* langString = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString* URLString = [NSString stringWithFormat:GET_CITY_BY_REGION, left, top,
                               right, bottom, langString, zoom];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:
                                    [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:120.0f];
//        NSLog(@"%@", URLString);
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response
                                                         error:&error];
        NSArray* JSON = nil;
        
        if ( data != nil )
        {
            JSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if ( !JSON )
            {
                NSMutableDictionary* userDetails = [NSMutableDictionary dictionary];
                [userDetails setValue:NSLocalizedString(@"edErrorJSONFormat", @"")
                               forKey:NSLocalizedDescriptionKey];
                error = [NSError errorWithDomain:APP_DOMAIN code:300 userInfo:userDetails];
            }
        }
        else
        {
            NSMutableDictionary* userDetails = [NSMutableDictionary dictionary];
            [userDetails setValue:NSLocalizedString(@"edErrorDataNil", @"")
                           forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:APP_DOMAIN code:200 userInfo:userDetails];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ( error )
                block( nil, error );
            else
                block( JSON, nil );
        }];
    }];
    
    [blockOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [self.operationQueue addOperation:blockOperation];
}

-(void) fetchHotelsByKeyCity:(NSString *)termString block:(FetchBlock)block
{
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSError *error = nil;
        NSHTTPURLResponse *response = nil;
        NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
        NSString* langString     = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString* currencyString = [formatter currencyCode];
        NSString* URLString = [NSString stringWithFormat:GET_HOTELS_BY_CITY, termString, langString, currencyString];
//        NSLog(@"%@", URLString);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:
                                                              [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:120.0f];
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response
                                                         error:&error];
        NSDictionary* JSON = nil;
        NSArray*      JSONHotels = nil;
        if ( data != nil )
        {
            JSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if ( !JSON )
            {
                NSMutableDictionary* userDetails = [NSMutableDictionary dictionary];
                [userDetails setValue:NSLocalizedString(@"edErrorJSONFormat", @"")
                               forKey:NSLocalizedDescriptionKey];
                error = [NSError errorWithDomain:APP_DOMAIN code:300 userInfo:userDetails];
            }
            else
            {
                JSONHotels = [[JSON objectForKey:@"Result"] objectForKey:@"Items"];
            }
        }
        else
        {
            NSMutableDictionary* userDetails = [NSMutableDictionary dictionary];
            [userDetails setValue:NSLocalizedString(@"edErrorDataNil", @"")
                           forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:APP_DOMAIN code:200 userInfo:userDetails];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ( error )
                block( nil, error );
            else
                block( JSONHotels, nil );
        }];
    }];
    [blockOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [self.operationQueue addOperation:blockOperation];
}

#pragma mark routing methods

-(void) addCityToDictionary:(NSDictionary*)cityDictionary
{
    NSString* country = [cityDictionary valueForKey:@"countryName"];
    NSMutableArray* cities = [_cities objectForKey:country];
    if ( !cities )
    {
        cities = [[[NSMutableArray alloc] init] autorelease];
    }
    City* city = [[[City alloc] initWithJSON:cityDictionary] autorelease];
    [cities addObject:city];
    [_cities setObject:cities forKey:country];
}

-(void) addHotelToArray:(NSDictionary*)hotelDictionary
{
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
    NSString* currencyString     = [NSString stringWithString:[formatter currencyCode]];
    Hotel* hotel = [[[Hotel alloc] initWithJSON:hotelDictionary currency:currencyString] autorelease];
    [_hotels addObject:hotel];
}

@end
