#import <UIKit/UIKit.h>


@interface PHModel : NSObject
{
  NSMutableArray* _pages;
}


@property (nonatomic, readonly) int pageCount;


// returns NO if preference file does not exist / has invalid format
- (BOOL)isInitialized;

// adds a blank page at the back
- (void)addBlankPage;

// returns page number of page at pageIndex
- (int)pageNumber:(int)pageIndex;

// returns YES if page at pageIndex is a blank page
- (BOOL)pageIsBlank:(int)pageIndex;

// removes pages at pageIndex if it is a blank page
- (void)removeBlankPageAtIndex:(int)pageIndex;

// updates representation of pages from given iconState
- (void)rebuildWithIconLists:(NSArray*)iconLists;


- (void)insertPageAtIndex:(int)pageIndex1 beforePageAtIndex:(int)pageIndex2;


@end
