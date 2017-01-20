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

@property (strong, nonatomic, nonnull) CoreDataStackHelper *coreDataHelper;

- (nonnull instancetype)initWithEntityName:(nonnull NSString *)entityName coreDataHelper:(nonnull CoreDataStackHelper *)coreDataHelper;
- (void)insertNewEntryWithDate:(nonnull NSDate *)date description:(nullable NSString *)description value:(nonnull NSString *)value category:(nullable Tag *)tag;
- (nonnull Entry *)newEntry;
- (void)discardChanges;
- (BOOL)saveChanges;
- (BOOL)saveEntry:(nonnull Entry *)entry error:(NSError * _Nullable * _Nullable)error;
- (void)deleteModel:(nonnull id)model;
- (BOOL)createTags:(nonnull NSArray *)tags;
- (BOOL)setTagForAllEntriesTo:(nonnull NSString *)tag;
- (BOOL)setOtherTagForAllEntriesWithoutTag;
- (BOOL)setIsAmountNegativeFromSignOfAmount;


#pragma mark - Utility requests
- (nonnull NSFetchRequest *)fetchRequestForAllEntries;

#pragma mark - Summary requests
- (nonnull NSFetchRequest *)fetchRequestForYearlySummary;
- (nonnull NSFetchRequest *)fetchRequestForMonthlySummary;
- (nonnull NSFetchRequest *)fetchRequestForDaylySummary;
- (nonnull NSFetchRequest *)fetchRequestForIndividualEntriesSummary;
/*!
 @discussion category can be either a Tag instance or an NSString instance signifying 'No filter'
 */
- (void)modifyfetchRequest:(nonnull NSFetchRequest <NSFetchRequestResult>*)request toFilterByCategory:(nonnull id)category;

#pragma mark - Line Graph requests
- (nonnull NSFetchRequest <NSFetchRequestResult>*)graphYearlySurplusFetchRequest;
- (nonnull NSFetchRequest <NSFetchRequestResult>*)graphYearlyExpensesFetchRequest;
- (nonnull NSFetchRequest <NSFetchRequestResult>*)graphMonthlySurplusFetchRequestForSectionName:(nonnull NSString *)sectionName;
- (nonnull NSFetchRequest <NSFetchRequestResult>*)graphMonthlyExpensesFetchRequestForSectionName:(nonnull NSString *)sectionName;
- (nonnull NSFetchRequest <NSFetchRequestResult>*)graphDailySurplusFetchRequestForSectionName:(nonnull NSString *)sectionName;
- (nonnull NSFetchRequest <NSFetchRequestResult>*)graphDailyExpensesFetchRequestForSectionName:(nonnull NSString *)sectionName;

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
