//
//  BSBaseExpensesSummaryViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSCoreDataControllerDelegateProtocol.h"
#import "BSAppDelegate.h"
#import "BSCurrencyHelper.h"
#import "BSCoreDataController.h"
#import "BSStaticTableAddEntryFormCellActionDataSource.h"
#import "BSCategoryFilterViewController.h"

@class CoreDataStackHelper, BSCoreDataController;


@interface BSBaseExpensesSummaryViewController : UICollectionViewController <BSCoreDataControllerDelegateProtocol, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate, UICollectionViewDelegateFlowLayout, BSCategoryFilterDelegate>

@property (strong, nonatomic) UICollectionViewLayout *layout;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) CoreDataStackHelper *coreDataStackHelper;
@property (strong, nonatomic) BSCoreDataController *coreDataController;

/*! When the user is in a particular summary screen and selects a cell, this property is set by
 the previous viewController and used by the nextViewController to scroll to the right section.
 This property exists because in certain screens we don't show all items, for example, we just show
 months that have entries in the daily summary screen.*/
@property (strong, nonatomic) NSString *nameOfSectionToBeShown;

@property (assign, nonatomic) BOOL shouldScrollToSelectedSection;

/*!
 @disscusion When this viewController is inside a navigation controller or another container, it can dissapear and appear again.
 */
@property (assign, nonatomic) BOOL firstTimeViewWillAppear;

/*!
 @disscusion This is mainly used to calculate which section to take into consideration to calculate the data to feed a chart in landscape.
 @returns the name of the section that is predominantely visible, the one that occupies the most space.
 */
- (NSString*) visibleSectionName;//should be protected

@end