#import "PHPreferencesViewController.h"


#import "../PHModel.h"
#import "../PHConfig.h"


@implementation PHPreferencesViewController


- (void)saveButtonTap
{
  [_model writeToPlist:PREFERENCES];
  system( "killall -9 SpringBoard" );
}


- (void)reloadPages
{
  [_model release];
  _model = [[PHModel alloc] initWithPlist:PREFERENCES];
  [_tableView reloadData];
}


- (id)initForContentSize:(CGSize)size
{
  if ( [[PSViewController class] instancesRespondToSelector:@selector( initForContentSize: )] )
    self = [super initForContentSize:size];
  else
    self = [super init];
  
  if ( self )
  {
    _model = [[PHModel alloc] initWithPlist:PREFERENCES];
    
    [[self navigationItem] setTitle:@"PageHolder"];
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector( saveButtonTap )];
    [[self navigationItem] setRightBarButtonItem:saveButton];
    [saveButton release];

    CGRect frame = CGRectMake( 0, 0, size.width, size.height );
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.editing = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelectionDuringEditing = YES;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // data may have changed while preferences was in background
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector( reloadPages ) name:UIApplicationDidBecomeActiveNotification object:nil];
  }
  return self;
}


- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [_model release];
  [_tableView release];
  [super dealloc];
}


- (UIView*)view
{
  return _tableView;
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
  if ( indexPath.section == 1 )
  {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray* paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:_model.pageCount inSection:0]];
    [_model addBlankPage];
    [tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
  }
}


- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
  if ( indexPath.section == 0 )
  {
    return ( [_model pageIsBlank:indexPath.row] ) ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
  }
  else if ( indexPath.section == 1 )
  {
    return UITableViewCellEditingStyleInsert;
  }
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
  return 2;
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
  if ( section == 0 )
  {
    return _model.pageCount;
  }
  else if ( section == 1 )
  {
    return 1;
  }
}


- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
  static NSString* cellIdentifier = @"PHPreferencesViewControllerCell";
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if ( !cell )
  {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
  }
  
  if ( indexPath.section == 0 )
  {
    if ( [_model pageIsBlank:indexPath.row] )
    {
      cell.textLabel.text = @"[Blank]";
    }
    else
    {
      cell.textLabel.text = [NSString stringWithFormat:@"Page %d", [_model pageNumber:indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  else if ( indexPath.section == 1 )
  {
    cell.textLabel.text = @"add blank page";
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
  }
  return cell;
}


- (BOOL)tableView:(UITableView*)tableView canMoveRowAtIndexPath:(NSIndexPath*)indexPath
{
  if ( indexPath.section == 0 )
  {
    return [_model pageIsBlank:indexPath.row];
  }
  else if ( indexPath.section == 1 )
  {
    return NO;
  }
}


- (void)tableView:(UITableView*)tableView moveRowAtIndexPath:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath
{
  [_model insertPageAtIndex:fromIndexPath.row beforePageAtIndex:toIndexPath.row];
}


- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
  if ( editingStyle == UITableViewCellEditingStyleDelete )
  {
    [_model removeBlankPageAtIndex:indexPath.row];
    NSArray* paths = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
  }
  else if ( editingStyle == UITableViewCellEditingStyleInsert )
  {
    NSArray* paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:_model.pageCount inSection:0]];
    [_model addBlankPage];
    [tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
  }
}


@end
