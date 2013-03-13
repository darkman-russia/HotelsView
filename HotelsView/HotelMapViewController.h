//
//  HotelMapViewController.h
//  HotelsView
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface HotelMapViewController : UIViewController <MKMapViewDelegate>
{
    NSMutableArray* _hotelMarkers;
    NSString*       _cityName;
    NSString*       _alias;
}

@property (retain, nonatomic) IBOutlet UINavigationBar* navigationBar;
@property (retain, nonatomic) IBOutlet MKMapView* mapView;

-(id)initWithNibNameAndCity:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                   cityName:(NSString *)aCityName alias:(NSString *)aAlias;
@end
