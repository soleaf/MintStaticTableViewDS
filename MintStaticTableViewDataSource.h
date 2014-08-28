//
//  MintStaticTableViewDataSource.h
//  howtomake
//
//  Created by soleaf on 13. 12. 23..
//  Copyright (c) 2013년 soleaf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MintStaticTableCellProtocol.h"
#import "MintStaticTableHeaderCellProtocol.h"

/*
 
 For SettingViewControlers
 One Add Cell, And Need Update Cell use update
 Don't dirty controller source through it.
 
    1. Init
    - init,  alloc을 쓰지 말고 dataSourceOn을 써서 테이블뷰 및 엑션 셀렉터를 받을 타겟으로 연결 그리고 cellIdentifier를 연결해줄것
    - sectionHeaderView는 Optional이기때문에 이를 넣는 factor는 nil로 넘겨도 무관하되 사용할시엔 poroperty중 isUseSectionHeaderView를 YES
    - sectionHeaderView는 MintStatictableHeaderCellProtocol을 지켜서 UItableVIewCell로 구현. 제목만 출력하도록함
    - sectionHdaerViewHeight property로 사이즈를 정해줘야 제대로 나옴.
 
    2. Add
    - UITableViewCell의 구현은 StoryBoard에서 구현해서 자유롭게 규현하되 프로토콜은 MintStaticTableCellProtocol을 사용할 것
    - title및 accessory만 다르고 나머지는 같은 셀들은 addRowTitle... 첫번째를 쓰고 , 추가적인 정보를 받아서 더 커스텀에 필요할 경우 두번째 메서드인 otherInfo에 값을 넘겨서 처리할 것
        --> AccessoryView만 교체하는 것이 기본 AddRow및 Update 메서드인 이유는 설정 테이블에서 주로 오른쪽 엑세서리 뷰만 바뀌는경우가 많기 때문.
 
    3. Update
    - updateAcc... 메서드가 두개이므로 필요한 메서드를 사용해서 업데이트. tableView reload는 알아서 할것.

 */

@interface MintStaticTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property UITableView   *tableView;
@property NSString      *normalCellId;
@property NSString      *sectionHeaderCellId;
@property id            actionTarget;
@property BOOL          isUseSectionHeaerView;
@property CGFloat       sectionHeaderViewHeight;
@property BOOL          isShowLastRowBottomSeparatingLine;

// Init
+ (MintStaticTableViewDataSource *) dataSourceOn:(UITableView*) linkingTableView
                                    actionTarget:(id)target
                                      withCellId:(NSString*) cellId
                          andSectionHeaderCellId:(NSString*) sectionHaederCellId;


// DataSource Make

- (NSInteger) addSectionByName:(NSString*) sectionName; // will return section index
- (NSInteger) addRowTtitle:(NSString *)title
          andAccessoryView:(UIView*) accessoryView
                  selector:(SEL)selecter
                 atSection:(NSInteger)section; // Will Return row index

- (NSInteger) addRowTtitle:(NSString *)title
          andAccessoryView:(UIView*) accessoryView
                 otherInfo:(NSDictionary*) info
                  selector:(SEL)selecter
                 atSection:(NSInteger)section; // Will Return row index

// DataSource Update
- (void) updateAccessory:(UIView*) accessoryView atIndex:(NSIndexPath*)index;
- (void) updateAccessoryView:(UIView*) accessoryView

         otherInfo:(NSDictionary*) info
                     atIndex:(NSIndexPath*)indexPath;



@end
