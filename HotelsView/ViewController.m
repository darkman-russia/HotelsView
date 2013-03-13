//
//  ViewController.m
//  HotelsView
//

#import "ViewController.h"
#import "ServerConnect.h"
#import "DejalActivityView.h"
#import "CityViewController.h"
#import "HotelMapViewController.h"
#import "CityLocation.h"
#import "City.h"

@interface ViewController ()

-(void) showCityViewController;
-(void) setAnnotations;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.barButtonItem.title = NSLocalizedString(@"ShowAreaTitle", @"");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_mapView release];
    [_searchBar release];
    [_barButtonItem release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [self setSearchBar:nil];
    [self setBarButtonItem:nil];
    [super viewDidUnload];
}

- (IBAction)showAreaClick:(id)sender
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"LoadingArea", @"")];
    [DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
    
    NSUInteger zoomLevel = round([self.mapView getZoomLevel] / MAX_IOS_LEVEL * MAX_HTTP_LEVEL);
    
    MKCoordinateRegion region = self.mapView.region;
    CLLocationCoordinate2D leftTopPoint = CLLocationCoordinate2DMake(region.center.latitude - region.span.latitudeDelta / 2, region.center.longitude - region.span.longitudeDelta / 2);
    CLLocationCoordinate2D rightBottomPoint = CLLocationCoordinate2DMake(region.center.latitude + region.span.latitudeDelta / 2, region.center.longitude + region.span.longitudeDelta / 2);
    ServerConnect* sharedServerConnect = [ServerConnect sharedServerConnect];
    [sharedServerConnect fetchHotelsByRegion:leftTopPoint.longitude top:leftTopPoint.latitude
                                       right:rightBottomPoint.longitude bottom:rightBottomPoint.latitude
                                        zoom:zoomLevel block:^(NSArray* items, NSError* error)
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
             [[sharedServerConnect cities] removeAllObjects];
             for ( NSDictionary *item in items )
                 [sharedServerConnect addCityToDictionary:item];
         }
         [DejalActivityView currentActivityView].showNetworkActivityIndicator = NO;
         [DejalBezelActivityView removeViewAnimated:YES];
         self.view.userInteractionEnabled = YES;
         [self setAnnotations];
     }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [DejalKeyboardActivityView activityViewWithLabel:NSLocalizedString(@"LoadingCity", @"")];
    [DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
    
    ServerConnect* sharedServerConnect = [ServerConnect sharedServerConnect];
    [sharedServerConnect fetchHotelsByKeyWord:searchBar.text block:^(NSArray* items, NSError* error)
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
              [[sharedServerConnect cities] removeAllObjects];
              for ( NSDictionary *item in items )
              {
                  [sharedServerConnect addCityToDictionary:item];
              }
          }
          [DejalActivityView currentActivityView].showNetworkActivityIndicator = NO;
          [DejalKeyboardActivityView removeViewAnimated:YES];
          self.view.userInteractionEnabled = YES;
          [searchBar resignFirstResponder];
          [self showCityViewController];
      }
    ];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void) setAnnotations
{
    ServerConnect* sharedServerConnect = [ServerConnect sharedServerConnect];
    for (id<MKAnnotation> annotation in _mapView.annotations)
        [_mapView removeAnnotation:annotation];
    
    NSArray* allCountry = [[NSArray alloc] initWithArray:[[sharedServerConnect cities] allKeys]];
    for ( NSString* country in allCountry )
    {
        NSArray* allCity = [[NSArray alloc] initWithArray:[[sharedServerConnect cities] objectForKey:country]];
        for ( City* city in allCity )
        {
            CityLocation* location = [[CityLocation alloc] initWithCity:city];
            [_mapView addAnnotation:location];
            [location release];
        }
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSString *identifier = @"city.png";
    MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:nil];
    if ( [annotation isKindOfClass:[CityLocation class]] )
        if (annotationView == nil)
        {
            CityLocation* loc = (CityLocation*)annotation;
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:nil];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.image = [UIImage imageNamed:identifier];

            UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(16, 20, 34, 18)] autorelease];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.textColor = [UIColor blackColor];
            lbl.textAlignment = UITextAlignmentCenter;
            lbl.text = [NSString stringWithFormat:@"%d", loc.hotelsCount];
            [annotationView addSubview:lbl];
        }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    CityLocation *location = (CityLocation*)view.annotation;
 
	HotelMapViewController* hotelMapViewController = [[HotelMapViewController alloc] initWithNibNameAndCity:@"HotelMapViewController" bundle:nil
                      cityName:location.cityName alias:location.cityAlias];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:hotelMapViewController];
    [self presentViewController:navigationController animated:YES completion: nil];
}


-(void) showCityViewController
{
	CityViewController* cityViewController = [[CityViewController alloc] initWithNibName:@"CityViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cityViewController];
    [self presentViewController:navigationController animated:YES completion: nil];
}

@end
