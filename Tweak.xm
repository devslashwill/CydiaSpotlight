#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define LOCAL_SEARCH NSLocalizedStringFromTable(@"SEARCH_BAR_PLACEHOLDER", @"SpringBoard", @"")
#define SEARCH_STRING [NSString stringWithFormat:LOCAL_SEARCH, @"Cydia"]

@interface SBSearchModel : NSObject
+ (id)sharedInstance;
- (BOOL)sectionIsWebSearch:(NSInteger)section;
@end

@interface SBSearchTableViewCell : UITableViewCell
@property (retain, nonatomic) NSString *title;
@end

NSInteger cydiaCellIndex = -1;

%hook SBSearchController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[%c(SBSearchModel) sharedInstance] sectionIsWebSearch:section])
    {
        cydiaCellIndex = %orig;
        return cydiaCellIndex + 1;
    }
    
    return %orig;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[%c(SBSearchModel) sharedInstance] sectionIsWebSearch:indexPath.section] && indexPath.row == cydiaCellIndex)
    {
        SBSearchTableViewCell *cell = (SBSearchTableViewCell *)%orig(tableView, [NSIndexPath indexPathForRow:cydiaCellIndex - 1 inSection:indexPath.section]);
        cell.title = SEARCH_STRING;
        return (UITableViewCell *)cell;
    }
    
    return %orig;
}

%end

%hook SBSearchModel

- (NSURL *)launchingURLForWebSearchRow:(NSInteger)row queryString:(NSString *)queryString
{
    if (row == cydiaCellIndex)
        return [NSURL URLWithString:[NSString stringWithFormat:@"cydia://search/%@", [queryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    return %orig;
}

%end