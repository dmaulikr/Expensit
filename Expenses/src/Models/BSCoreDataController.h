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
- (void) insertNewEntryWithDate:(NSDate*)date description:(NSString*)description value:(NSString*)value category:(Tag *)tag;
- (Entry *) newEntry;
- (void)discardChanges;
- (BOOL)saveChanges;
- (BOOL) saveEntry:(Entry *)entry error:(NSError **)error;
- (void)deleteModel:(id)model;
- (BOOL)createTags:(NSArray *)tags;
- (BOOL)setTagForAllEntriesTo:(NSString *)tag;
- (BOOL)setOtherTagForAllEntriesWithoutTag;
- (BOOL)setIsAmountNegativeFromSignOfAmount;


#pragma mark - Utility requests
- (NSFetchRequest *)fetchRequestForAllEntries;

#pragma mark - Summary requests
- (NSFetchRequest *)fetchRequestForYearlySummary;
- (NSFetchRequest *)fetchRequestForMonthlySummary;
- (NSFetchRequest *)fetchRequestForDaylySummary;
- (NSFetchRequest *)fetchRequestForIndividualEntriesSummary;
/*!
 @discussion category can be either a Tag instance or an NSString instance signifying 'No filter'
 */
- (void)modifyfetchRequest:(NSFetchRequest <NSFetchRequestResult>*)request toFilterByCategory:(id)category;

#pragma mark - Line Graph requests
- (NSFetchRequest <NSFetchRequestResult>*)graphYearlySurplusFetchRequest;
- (NSFetchRequest <NSFetchRequestResult>*)graphYearlyExpensesFetchRequest;
- (NSFetchRequest <NSFetchRequestResult>*)graphMonthlySurplusFetchRequestForSectionName:(NSString *)sectionName;
- (NSFetchRequest <NSFetchRequestResult>*)graphMonthlyExpensesFetchRequestForSectionName:(NSString *)sectionName;
- (NSFetchRequest <NSFetchRequestResult>*)graphDailySurplusFetchRequestForSectionName:(NSString *)sectionName;
- (NSFetchRequest <NSFetchRequestResult>*)graphDailyExpensesFetchRequestForSectionName:(NSString *)sectionName;

#pragma mark - Pie Chart Graph requests
- (NSFetchRequest *)expensesByCategoryMonthlyFetchRequest;
- (NSArray *)expensesByCategoryForMonth:(NSNumber *)month inYear:(NSNumber *)year;


#pragma mark - Other requests
- (NSFetchRequest *)requestToGetYears;

#pragma mark - Execution of requests
- (NSArray *) resultsForRequest:(NSFetchRequest *)request error:(NSError **)error;

#pragma mark - Tags

- (Tag *)tagForName:(NSString *)tagName;

/*! @discussion Ordered by name ASC. */
- (NSArray *)allTags;
- (NSArray *)allTagImages;
- (UIImage *)imageForCategory:(Tag *)tag;
- (BOOL)findNoTags:(NSString *)tagName;
- (NSArray *)categoriesForMonth:(nullable NSNumber *)month inYear:(nonnull NSNumber *)year;
- (nullable NSArray *)sortedTagsByPercentageFromSections:(nonnull NSArray *)tags sections:(nullable NSArray *)sections;

@end
