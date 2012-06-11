#import "PHModel.h"


@implementation PHModel



- (id)initWithPlist:(NSString*)plist
{
  self = [super init];
  if ( self )
  {
    _pages = [[NSMutableArray alloc] initWithContentsOfFile:plist];
  }
  return self;
}


- (BOOL)writeToPlist:(NSString*)plist
{
  return [_pages writeToFile:plist atomically:YES];
}


- (void)dealloc
{
  [_pages release];
  [super dealloc];
}


- (BOOL)isInitialized
{
  return ( _pages != nil );
}


- (int)pageCount
{
  return _pages.count;
}


- (void)removeBlankPageAtIndex:(int)pageIndex
{
  if ( [self pageIsBlank:pageIndex] )
    [_pages removeObjectAtIndex:pageIndex];
}


- (void)addBlankPage
{
  [_pages addObject:[NSNumber numberWithInt:0]];
}


- (int)pageNumber:(int)pageIndex
{
  if ( pageIndex >= _pages.count )
    return -1;
  
  return [[_pages objectAtIndex:pageIndex] intValue];
}


- (BOOL)pageIsBlank:(int)pageIndex
{
  if ( pageIndex >= _pages.count )
    return NO;
  
  return ( [[_pages objectAtIndex:pageIndex] intValue] == 0 );
}


- (void)rebuildWithIconLists:(NSArray*)iconLists
{
  if ( !_pages )
    _pages = [[NSMutableArray alloc] init];

  int pageNumber = 1;
  [_pages removeAllObjects];
  for ( NSArray* page in iconLists )
  {
    if ( page.count == 0 )
      [_pages addObject:[NSNumber numberWithInt:0]];
    else
      [_pages addObject:[NSNumber numberWithInt:pageNumber++]];
  }
}


- (void)insertPageAtIndex:(int)pageIndex1 beforePageAtIndex:(int)pageIndex2
{
  if ( pageIndex1 == pageIndex2 )
    return;
  if ( pageIndex1 < 0 || pageIndex1 >= _pages.count )
    return;
  if ( pageIndex2 < 0 || pageIndex2 >= _pages.count )
    return;
  
  id page = [[_pages objectAtIndex:pageIndex1] retain];
  [_pages removeObjectAtIndex:pageIndex1];
  [_pages insertObject:page atIndex:pageIndex2];
  [page release];
}


@end
