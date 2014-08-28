//
//  MintStaticTableCellProtocol.h
//  howtomake
//
//  Created by soleaf on 13. 12. 23..
//  Copyright (c) 2013년 soleaf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MintStaticTableCellProtocol <NSObject>

- (void) makeCellTitle:(NSString *)title otherInfo:(NSDictionary*)info andAccesoryView:(UIView *)accessoryView;
- (void) separatingView:(BOOL)show;
- (void) drawBorderTop:(BOOL)draw;
- (void) drawBorderBottom:(BOOL)draw;

@end
