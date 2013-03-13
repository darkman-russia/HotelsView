//
//  HotelViewController.h
//  HotelsView
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface HotelViewController : UIViewController <UITableViewDelegate>
{
    NSArray* _items;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;

-(id)initWithItems:(NSString*)nibNameOrNil items:(NSArray*)items;

@end
