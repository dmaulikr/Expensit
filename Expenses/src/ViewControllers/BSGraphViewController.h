//
//  BSGraphViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 09/07/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineGraph.h"

@interface BSGraphViewController : UIViewController <LineGraphDataSourceProtocol>
@property (strong, nonatomic) NSArray *moneyIn;
@property (strong, nonatomic) NSArray *moneyOut;
@property (strong, nonatomic) NSArray *xValues;
@property (strong, nonatomic) NSString *graphTitle;
@end
