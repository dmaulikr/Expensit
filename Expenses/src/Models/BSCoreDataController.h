//
//  BSCoreDataController.h
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSCoreDataControllerDelegateProtocol.h"
#import "Entry.h"

@class CoreDataStackHelper;

@interface BSCoreDataController : NSObject <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) CoreDataStackHelper *coreDataHelper;
@property (strong, nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (weak, nonatomic)   id <BSCoreDataControllerDelegateProtocol> delegate;

- (id)initWithEntityName:(NSString*)entityName delegate:(id<BSCoreDataControllerDelegateProtocol>)delegate coreDataHelper:(CoreDataStackHelper*)coreDataHelper;
- (void) insertNewEntryWithDate:(NSDate*)date description:(NSString*)description value:(NSString*)value;
- (Entry *) newEntry;
- (BOOL) saveEntry:(Entry *)entry withNegativeAmount:(BOOL)shouldBeNegative error:(NSError **)error;


#pragma mark - Summary requests
- (NSFetchRequest *)fetchRequestForYearlySummary;
- (NSFetchRequest *)fetchRequestForMonthlySummary;
- (NSFetchRequest *)fetchRequestForDaylySummary;
- (NSFetchRequest *)fetchRequestForIndividualEntriesSummary;

#pragma mark - Graph requests
- (NSFetchRequest *) graphYearlySurplusFetchRequest;
- (NSFetchRequest *) graphYearlyExpensesFetchRequest;
- (NSFetchRequest *)graphMonthlySurplusFetchRequestForSectionName:(NSString *)sectionName;
- (NSFetchRequest *)graphMonthlyExpensesFetchRequestForSectionName:(NSString *)sectionName;
- (NSFetchRequest *)graphDailySurplusFetchRequestForSectionName:(NSString *)sectionName;
- (NSFetchRequest *)graphDailyExpensesFetchRequestForSectionName:(NSString *)sectionName;

#pragma mark - Other requests
- (NSFetchRequest *)requestToGetYears;

#pragma mark - Execution of requests
- (NSArray *) resultsForRequest:(NSFetchRequest *)request error:(NSError **)error;

@end
