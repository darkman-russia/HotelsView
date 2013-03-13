//
//  ViewController.h
//  HotelsView
//
//  Created by Alexander Pozakchine on 26.01.13.
//  Copyright (c) 2013 Alexander Pozakchine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MKMapView+ZoomLevel.h"

@interface ViewController : UIViewController <UISearchBarDelegate, MKMapViewDelegate>

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *barButtonItem;

- (IBAction)showAreaClick:(id)sender;

@end
