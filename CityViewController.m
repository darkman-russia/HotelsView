//
//  CityViewController.m
//  HotelsView
//
//  Created by Alexander Pozakchine on 28.01.13.
//  Copyright (c) 2013 Alexander Pozakchine. All rights reserved.
//

#import "CityViewController.h"
#import "ServerConnect.h"
#import "City.h"
#import "HotelMapViewController.h"

@interface CityViewController ()

@end

@implementation CityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tableView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title  = NSLocalizedString(@"CityTableTitle", @"");
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BackTitle", @"")
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(barButtonBackPressed)];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = backButton;
    [backButton release];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    ServerConnect* sharedServerConnect = [ServerConnect sharedServerConnect];
    NSArray* keyValues = [[sharedServerConnect cities] allKeys];
    return [keyValues count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ServerConnect* sharedServerConnect = [ServerConnect sharedServerConnect];
    NSArray* keyValues = [[sharedServerConnect cities] allKeys];
    NSString* currentKey = [keyValues objectAtIndex:section];

    return [[[sharedServerConnect cities] objectForKey:currentKey] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ServerConnect* sharedServerConnect = [ServerConnect sharedServerConnect];
    NSArray* keyValues = [[sharedServerConnect cities] allKeys];
    NSString* currentKey = [keyValues objectAtIndex:section];
    
    return currentKey;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServerConnect* sharedServerConnect = [ServerConnect sharedServerConnect];
    NSArray* keyValues = [[sharedServerConnect cities] allKeys];
    NSString* currentKey = [keyValues objectAtIndex:indexPath.section];
    City* city = [[[sharedServerConnect cities] objectForKey:currentKey] objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"Cell"];
        cell.accessoryType  = UITableViewCellAccessoryDetailDisclosureButton;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)", city.name, city.hotels];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        [cell.textLabel sizeToFit];
    }
    return cell;
}

- (void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath
{
    ServerConnect* sharedServerConnect = [ServerConnect sharedServerConnect];
    NSArray* keyValues = [[sharedServerConnect cities] allKeys];
    NSString* currentKey = [keyValues objectAtIndex:indexPath.section];
    City* city = [[[sharedServerConnect cities] objectForKey:currentKey] objectAtIndex:indexPath.row];
    
	HotelMapViewController* hotelMapViewController = [[HotelMapViewController alloc] initWithNibNameAndCity:@"HotelMapViewController" bundle:nil cityName:city.name alias:city.alias];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:hotelMapViewController];
    [self presentViewController:navigationController animated:YES completion: nil];
}

-(void) barButtonBackPressed
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [_navigationBar release];
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNavigationBar:nil];
    [self setTableView:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
}


@end
