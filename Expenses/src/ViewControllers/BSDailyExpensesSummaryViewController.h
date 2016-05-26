//
//  BSPerMonthExpensesSummaryViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 29/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSBaseExpensesSummaryViewController.h"

@interface BSDailyExpensesSummaryViewController : BSBaseExpensesSummaryViewController
// In order to extend the bae protocol, conformed by the uper cla, i create a econd reference to a more pecialied protocol
@property (strong, nonatomic, nullable) id<BSDailyExpensesSummaryPresenterEventsProtocol> showDailyEntriesPresenter;

@end
