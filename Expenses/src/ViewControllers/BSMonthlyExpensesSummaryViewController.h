//
//  BSMonthlyExpensesSummaryViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 23/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSBaseExpensesSummaryViewController.h"

@protocol BSMonthlyExpensesSummaryPresenterEventsProtocol;

@interface BSMonthlyExpensesSummaryViewController : BSBaseExpensesSummaryViewController
// In order to extend the bae protocol, conformed by the uper cla, i create a econd reference to a more pecialied protocol
@property (strong, nonatomic, nullable) id<BSMonthlyExpensesSummaryPresenterEventsProtocol> showMonthlyEntriesPresenter;
@end
