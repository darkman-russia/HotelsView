//
//  HotelDetailViewController.h
//  HotelsView
//
//  Created by Alexander Pozakchine on 31.01.13.
//  Copyright (c) 2013 Alexander Pozakchine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hotel.h"

@interface HotelDetailViewController : UIViewController <UITableViewDelegate>
{
    id _hotel;
}
@property (retain, nonatomic) IBOutlet UITableView *tableView;

- (id)initWithHotel:(NSString *)nibNameOrNil hotel:(Hotel*)hotel;

@end
