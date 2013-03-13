//
//  HotelViewController.m
//  HotelsView
//

#import "HotelViewController.h"
#import "HotelDetailViewController.h"
#import "Hotel.h"

@interface HotelViewController ()

@end

@implementation HotelViewController

-(id)initWithItems:(NSString*)nibNameOrNil items:(NSArray*)items;
{
    if ( self = [super initWithNibName:nibNameOrNil bundle:nil] )
        _items = [[NSArray alloc] initWithArray:items];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title  = NSLocalizedString(@"HotelsListTitle", @"");
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Hotel* hotel = [_items objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"Cell"];
        cell.accessoryType  = UITableViewCellAccessoryDetailDisclosureButton;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        [cell.textLabel sizeToFit];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = [NSString stringWithFormat:@"%@", hotel.name];
    }
    return cell;
}

- (void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath
{
    Hotel* hotel = [_items objectAtIndex:indexPath.row];
	HotelDetailViewController* hotelDetailViewController = [[HotelDetailViewController alloc] initWithHotel: @"HotelDetailViewController" hotel:hotel];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:hotelDetailViewController];
    [self presentViewController:navigationController animated:YES completion: nil];
}

-(void) barButtonBackPressed
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc
{
    [_items release];
    [_tableView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
