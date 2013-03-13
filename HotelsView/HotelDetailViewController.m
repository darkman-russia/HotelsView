//
//  HotelDetailViewController.m
//  HotelsView
//
//  Created by Alexander Pozakchine on 31.01.13.
//  Copyright (c) 2013 Alexander Pozakchine. All rights reserved.
//

#import "HotelDetailViewController.h"
#import "Hotel.h"

@interface HotelDetailViewController ()

@end

@implementation HotelDetailViewController

- (id)initWithHotel:(NSString *)nibNameOrNil hotel:(Hotel*)hotel
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self)
        _hotel = hotel;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title  = NSLocalizedString(@"HotelsInfoTitle", @"");
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BackTitle", @"")
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(barButtonBackPressed)];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = backButton;
    [backButton release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableViewController
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Hotel* hotel = (Hotel*)_hotel;
    return hotel.name;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 36;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    if ( indexPath.row == 0 )
        CellIdentifier = @"Address";
    else
        CellIdentifier = @"Star";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType  = UITableViewCellAccessoryNone;
        Hotel* hotel = (Hotel*)_hotel;
        if ( indexPath.row == 0 )
        {
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            [cell.textLabel sizeToFit];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = hotel.address;
        }
        else
        {
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 2, 160, 32)];
            imv.image=[UIImage imageNamed:[NSString stringWithFormat:@"star%d.png", hotel.stars]];
            [cell addSubview:imv];
            [imv release];
            //cell.imageView = [UIImage imageNamed:[NSString stringWithFormat:@"star%d.png", hotel.stars]];
        }
    }
    return cell;
}

-(void) barButtonBackPressed
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
