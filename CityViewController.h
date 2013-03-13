//
//  CityViewController.h
//  HotelsView
//
//  Created by Alexander Pozakchine on 28.01.13.
//  Copyright (c) 2013 Alexander Pozakchine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityViewController : UIViewController <UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
