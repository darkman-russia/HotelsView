//
//  MKMapView+ZoomLevel.m
//  HotelsView
//

#import "MKMapView+ZoomLevel.h"

@implementation MKMapView (ZoomLevel)

- (double)getZoomLevel
{
    CLLocationDegrees longitudeDelta = self.region.span.longitudeDelta;
    CGFloat mapWidthInPixels = self.bounds.size.width;
    double zoomScale = longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * mapWidthInPixels);
    double zoomLevel = MAX_GOOGLE_LEVELS - log2( zoomScale );
    if ( zoomLevel < 0 ) zoomLevel = 0;
    //  zoomLevel = round(zoomLevel);
    return zoomLevel;
}

@end
