//
//  HotelMapViewController.m
//  HotelsView
//

#import <MapKit/MapKit.h>
#import "Constants.h"
#import "DejalActivityView.h"
#import "ServerConnect.h"
#import "HotelMapViewController.h"
#import "Hotel.h"
#import "HotelLocation.h"
#import "HotelViewController.h"
#import "HotelDetailViewController.h"

@interface HotelMapViewController ()

-(void)   loadHotelsByCity;
-(void)   setRegion;
-(void)   allocateMarkers;

@end

@implementation HotelMapViewController

-(id)initWithNibNameAndCity:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                   cityName:(NSString *)aCityName alias:(NSString *)aAlias
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _hotelMarkers = [[NSMutableArray alloc] init];
        _cityName = [[NSString stringWithString:aCityName] copy];
        _alias    = [[NSString stringWithString:aAlias] copy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString* barTitle = [NSString stringWithFormat:NSLocalizedString(@"HotelsMapTitle", @""), _cityName];
    
    UILabel* label = [[UILabel alloc] initWithFrame:self.navigationBar.frame];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = barTitle;
    label.adjustsFontSizeToFitWidth = YES;
    self.navigationController.navigationBar.topItem.titleView = label;
    [label release];

    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CloseTitle", @"")
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(barButtonClosePressed)];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = backButton;
    [backButton release];
    [self loadHotelsByCity];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) barButtonClosePressed
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) loadHotelsByCity
{
    self.view.userInteractionEnabled = NO;
    [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"LoadingHotels", @"")];
    [DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
    
    ServerConnect* sharedServerConnect = [ServerConnect sharedServerConnect];
    [sharedServerConnect fetchHotelsByKeyCity:_alias block:^(NSArray* items, NSError* error)
     {
         if ( error != nil )
         {
             NSString* errorMSG = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ErrorTitle", @"")
                                                             message:errorMSG
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"CancelTitle", @"")
                                                   otherButtonTitles:nil];
             [alert show];
             [alert release];
         }
         else if ( items )
         {
             [[sharedServerConnect hotels] removeAllObjects];
             for ( NSDictionary* item in items )
             {
                 [sharedServerConnect addHotelToArray:item];
             }
             [DejalActivityView currentActivityView].showNetworkActivityIndicator = NO;
             [DejalBezelActivityView removeViewAnimated:YES];
             self.view.userInteractionEnabled = YES;
             [self setRegion];
         }
     }
     ];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    HotelLocation* myAnnotation = (HotelLocation*)annotation;
    NSString *identifier = (HotelLocation*)[myAnnotation isOwnerAHotel] ?
                                 @"marker_single.png" : @"marker_many.png";
    if ([annotation isKindOfClass:[HotelLocation class]])
    {
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.image = [UIImage imageNamed:identifier];
        } else
        {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    HotelLocation *location = (HotelLocation*)view.annotation;
    if ( [location.items count] > 1 )
    {
        HotelViewController* hotelViewController = [[HotelViewController alloc] initWithItems:@"HotelViewController" items:[location items]];
      
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:hotelViewController];
        [self presentViewController:navigationController animated:YES completion: nil];
    }
    else
    {
        Hotel* hotel = [location.items objectAtIndex:0];
        HotelDetailViewController* hotelDetailViewController = [[HotelDetailViewController alloc] initWithHotel: @"HotelDetailViewController" hotel:hotel];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:hotelDetailViewController];
        [self presentViewController:navigationController animated:YES completion: nil];
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self allocateMarkers];
}

-(void) setRegion
{
    ServerConnect* sharedServerConnect = [ServerConnect sharedServerConnect];
    int pCount = [[sharedServerConnect hotels] count];
    MKMapPoint points[pCount];
    
    for ( Hotel* hotel in [sharedServerConnect hotels] )
    {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(hotel.lat, hotel.lon);
        int index = [[sharedServerConnect hotels] indexOfObject:hotel];
        points[index] = MKMapPointForCoordinate(coord);
    }
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:pCount] boundingMapRect];
    MKCoordinateRegion fetchedRegion = MKCoordinateRegionForMapRect(mapRect);
    
    //add padding so pins aren't scrunched on the edges
    fetchedRegion.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    fetchedRegion.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    
    //but padding can't be bigger than the world
    if( fetchedRegion.span.latitudeDelta > MAX_DEGREES_ARC )
    {
        fetchedRegion.span.latitudeDelta  = MAX_DEGREES_ARC;
    }
    if( fetchedRegion.span.longitudeDelta > MAX_DEGREES_ARC )
    {
        fetchedRegion.span.longitudeDelta = MAX_DEGREES_ARC;
    }
    
    //and don't zoom in stupid-close on small samples
    if( fetchedRegion.span.latitudeDelta  < MINIMUM_ZOOM_ARC )
    {
        fetchedRegion.span.latitudeDelta  = MINIMUM_ZOOM_ARC;
    }
    if( fetchedRegion.span.longitudeDelta < MINIMUM_ZOOM_ARC )
    {
        fetchedRegion.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    
    if( pCount == 1 )
    {
        fetchedRegion.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        fetchedRegion.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [_mapView setRegion:fetchedRegion animated:YES];
}

-(void) allocateMarkers
{
    ServerConnect* sharedServerConnect = [ServerConnect sharedServerConnect];

    [_hotelMarkers removeAllObjects];
    
    float scaleFactorLatitude  = [[UIScreen mainScreen] bounds].size.width  / MARKER_SIZE;
    float scaleFactorLongitude = [[UIScreen mainScreen] bounds].size.height / MARKER_SIZE;
    
    float latDelta = _mapView.region.span.latitudeDelta  / scaleFactorLatitude;
    float lonDelta = _mapView.region.span.longitudeDelta / scaleFactorLongitude;
    
    for (Hotel* hotel in sharedServerConnect.hotels)
    {
        MKMapPoint hotelPoint = MKMapPointForCoordinate(hotel.coordinate2D);
        if (MKMapRectContainsPoint(_mapView.visibleMapRect, hotelPoint))
        {
                BOOL isAddToExisting = NO;
                for (int i = 0; i < [_hotelMarkers count]; i++ )
                {
                    NSMutableArray* currentMarkers = [_hotelMarkers objectAtIndex:i];
                    Hotel* currentHotel = [currentMarkers objectAtIndex:0];
                    if ( fabs( currentHotel.lat - hotel.lat ) < latDelta &&
                         fabs( currentHotel.lon - hotel.lon ) < lonDelta
                       )
                    {
                        [currentMarkers addObject:hotel];
                        [_hotelMarkers setObject:currentMarkers atIndexedSubscript:i];
                        isAddToExisting = YES;
                        break;
                    }
                }
                if ( !isAddToExisting )
                {
                    NSMutableArray* markers = [[NSMutableArray alloc] init];
                    [markers addObject:hotel];
                    [_hotelMarkers addObject:markers];
                }
        }
    }
    for (id<MKAnnotation> annotation in _mapView.annotations)
        [_mapView removeAnnotation:annotation];
    for (NSArray* marker in _hotelMarkers)
    {
        HotelLocation* location = [[HotelLocation alloc] initWithOwner:marker];
        [_mapView addAnnotation:location];
        [location release];
    }
}

- (void)dealloc
{
    [_hotelMarkers release];
    [_cityName release];
    [_alias release];
    [_navigationBar release];
    [_mapView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}
@end
