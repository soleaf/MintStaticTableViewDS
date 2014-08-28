//
//  MintStaticTableViewDataSource.m
//  howtomake
//
//  Created by soleaf on 13. 12. 23..
//  Copyright (c) 2013년 soleaf. All rights reserved.
//

#import "MintStaticTableViewDataSource.h"

static NSString* const CellTitle = @"Title";
static NSString* const CellAccessoryView = @"AcceossryView";
static NSString* const CellSelector = @"Selector";
static NSString* const CellOtherInfo = @"OtherInfo";

@interface MintStaticTableViewDataSource ()
{
    NSMutableArray *dataSource;
    NSMutableArray *dataSourceSectionNames;
}

@end

@implementation MintStaticTableViewDataSource

+ (MintStaticTableViewDataSource *)dataSourceOn:(UITableView *)linkingTableView
                                   actionTarget:(id)target
                                     withCellId:(NSString *)cellId andSectionHeaderCellId:(NSString *)sectionHaederCellId
{
    MintStaticTableViewDataSource *ds = [[MintStaticTableViewDataSource alloc] init];
    ds.tableView = linkingTableView;
    ds.normalCellId = cellId;
    ds.actionTarget = target;
    ds.sectionHeaderCellId = sectionHaederCellId;
    
    return  ds;
}

- (NSInteger)addSectionByName:(NSString *)sectionName
{
    if (!dataSource) dataSource = [[NSMutableArray alloc] init];
    if (!dataSourceSectionNames) dataSourceSectionNames = [[NSMutableArray alloc] init];
    
    [dataSourceSectionNames addObject:sectionName];
    [dataSource addObject:[[NSMutableArray alloc] init]];
    
    return dataSourceSectionNames.count-1;
}

- (NSInteger)addRowTtitle:(NSString *)title andAccessoryView:(UIView *)accessoryView
                 selector:(SEL)selecter atSection:(NSInteger)section
{
    NSMutableDictionary *item = [[NSMutableDictionary alloc]  init];
    [item setObject:title forKey:CellTitle];
    if(accessoryView)
        [item setObject:accessoryView forKey:CellAccessoryView];
    if (selecter)
        [item setObject:NSStringFromSelector(selecter) forKey:CellSelector];

    NSMutableArray *sectionArray = [dataSource objectAtIndex:section];
    [sectionArray addObject:item];
    
    return sectionArray.count-1;
}

- (NSInteger)addRowTtitle:(NSString *)title andAccessoryView:(UIView *)accessoryView otherInfo:(NSDictionary *)info selector:(SEL)selecter atSection:(NSInteger)section
{
    NSMutableDictionary *item = [[NSMutableDictionary alloc]  init];
    [item setObject:title forKey:CellTitle];
    if(accessoryView)
        [item setObject:accessoryView forKey:CellAccessoryView];
    if (selecter)
        [item setObject:NSStringFromSelector(selecter) forKey:CellSelector];
    if (info)
        [item setObject:info forKey:CellOtherInfo];
    
    NSMutableArray *sectionArray = [dataSource objectAtIndex:section];
    [sectionArray addObject:item];
    
    return sectionArray.count-1;
}

- (void)updateAccessory:(UIView *)accessoryView atIndex:(NSIndexPath *)index
{
    NSMutableDictionary *item = [[dataSource objectAtIndex:index.section] objectAtIndex:index.row];
    [item setObject:accessoryView forKey:CellAccessoryView];
}

- (void)updateAccessoryView:(UIView *)accessoryView otherInfo:(NSDictionary *)info atIndex:(NSIndexPath *)indexPath
{
    NSMutableDictionary *item = [[dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if(accessoryView)
        [item setObject:accessoryView forKey:CellAccessoryView];
    if (info)
        [item setObject:info forKey:CellOtherInfo];
}


#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dataSource objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = self.normalCellId;
    UITableViewCell<MintStaticTableCellProtocol> *cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *item = [[dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    BOOL isLast = (indexPath.row == [[dataSource objectAtIndex:indexPath.section] count]-1);
    
    [cell drawBorderTop:(indexPath.row == 0)];
    [cell drawBorderBottom:isLast];
    [cell separatingView:(!isLast && ([[dataSource objectAtIndex:indexPath.section]count] > 1)) || self.isShowLastRowBottomSeparatingLine];
    
    [cell makeCellTitle:[item objectForKey:CellTitle] otherInfo:[item objectForKey:CellOtherInfo]
        andAccesoryView:[item objectForKey:CellAccessoryView]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (!self.isUseSectionHeaerView) return nil;
    
    UITableViewCell<MintStaticTableHeaderCellProtocol>
    *headerCell = [self.tableView dequeueReusableCellWithIdentifier:self.sectionHeaderCellId forIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    [headerCell makeCellTitle:[dataSourceSectionNames objectAtIndex:section]];
    
    return headerCell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.isUseSectionHeaerView ? self.sectionHeaderViewHeight : 0;
}

#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [[dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([item objectForKey:CellSelector]){
        SEL selector = NSSelectorFromString([item objectForKey:CellSelector]);
        
        // Ignore Warning
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        [self.actionTarget performSelector:selector withObject:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 30;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


@end
