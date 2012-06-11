#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>


@class PHModel;


@interface PHPreferencesViewController : PSViewController <
  UITableViewDelegate,
  UITableViewDataSource>
{
  PHModel* _model;
  
  UITableView* _tableView;
}


- (id)initForContentSize:(CGSize)size;


@end
