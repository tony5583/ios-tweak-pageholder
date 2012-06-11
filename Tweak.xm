#import <substrate.h>
#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>


#import "PHModel.h"
#import "PHConfig.h"


static PHModel* model;
static BOOL iconsInitialized = NO;
static BOOL springboardLaunched = NO;


%hook SBUIController


- (void)finishLaunching
{
  %orig;
  springboardLaunched = YES;
}


%end


%hook SBIconModel


- (id)iconState
{
  // only modify the iconList the very first time
  if ( iconsInitialized )
    return %orig;

  iconsInitialized = YES;

  NSDictionary* state = %orig;
  NSMutableArray* iconLists = [state objectForKey:@"iconLists"];
  
  model = [[PHModel alloc] initWithPlist:PREFERENCES];
  if ( ![model isInitialized] )
  {
    [model rebuildWithIconLists:iconLists];
    [model writeToPlist:PREFERENCES];
  }
  
  // remove empty icon lists
  for ( int i = iconLists.count - 1; i >= 0; i-- )
    if ( [[iconLists objectAtIndex:i] count] == 0 )
      [iconLists removeObjectAtIndex:i];

  // re-insert empty icon lists
  for ( int i = 0; i < model.pageCount; i++ )
    if ( [model pageIsBlank:i] )
      [iconLists insertObject:[NSMutableArray array] atIndex:i];
  
  return state;
}


%end


%hook SBIconController


- (void)setIsEditing:(BOOL)editing
{
  BOOL wasEditing = [self isEditing];
  %orig( editing );
  
  /* During initialization, setIsEditing:NO is called a few times,
   * if it transited from YES -> NO then it is user-induced via
   * SpringBoard.
   */
  if ( wasEditing && !editing )
  {
    // rebuild pages representation based on updated iconState
    NSArray* iconLists = [[[%c( SBIconModel ) sharedInstance] iconState] objectForKey:@"iconLists"];
    [model rebuildWithIconLists:iconLists];
    [model writeToPlist:PREFERENCES];
  }
}


%end


%hook SBIconListModel


- (BOOL)isEmpty
{
  // allow all empty icon lists during initialization
  if ( !springboardLaunched )
    return NO;

  BOOL result = %orig;
  
  // icon list is not empty
  if ( !result )
    return NO;

  // icon list is empty, check is we should hold it
  id iconController = [%c( SBIconController ) sharedInstance];
  NSMutableArray* _rootIconLists = MSHookIvar<NSMutableArray*>( iconController, "_rootIconLists" );

  // find index of this instance
  int index;
  for ( int i = 0; i < _rootIconLists.count; i++ )
    if ( self == [[_rootIconLists objectAtIndex:i] model] )
      index = i;

  // hold on to all pages that were initially present
  return ( index < model.pageCount ) ? NO : result;
}


%end