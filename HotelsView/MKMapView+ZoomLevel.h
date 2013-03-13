//
//  MKMapView+ZoomLevel.h
//  HotelsView
//

#import <MapKit/MapKit.h>

#define MERCATOR_RADIUS 85445659.44705395
#define MAX_GOOGLE_LEVELS 20

#define MAX_IOS_LEVEL 19
#define MAX_HTTP_LEVEL 18

@interface MKMapView (ZoomLevel)

- (double)getZoomLevel;

@end
