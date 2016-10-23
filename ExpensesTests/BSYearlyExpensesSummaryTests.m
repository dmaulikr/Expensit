//
//  BSYearlyExpensesSummaryTests.m
//  Expenses
//
//  Created by Borja Arias Drake on 27/09/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BSYearlyExpensesSummaryViewController.h"
#import "CoreDataStackHelper.h"
#import "BSCoreDataController.h"
#import "DateTimeHelper.h"
#import "Tag.h"
#import "OCMock/Headers/OCMock/OCMock.h"
#import "Expensit-Swift.h"



static CoreDataStackHelper *coreDataStackHelper;
static BSCoreDataController *coreDataController;
static BSYearlyExpensesSummaryViewController *yearlyViewController;
static BSShowYearlyEntriesController *controller;
static BSShowYearlyEntriesPresenter *presenter;


@interface BSYearlyExpensesSummaryTests : XCTestCase
@end

@implementation BSYearlyExpensesSummaryTests

- (void)setUp
{
    [super setUp];
    
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"BSYESummaryTestsDataBase" stringByAppendingString:@".sqlite"]];
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"BSYESummaryTestsDataBase" stringByAppendingString:@".sqlite-shm"]];
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"BSYESummaryTestsDataBase" stringByAppendingString:@".sqlite-wal"]];


    coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"BSYESummaryTestsDataBase"];
    
    coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:coreDataStackHelper];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    yearlyViewController = [storyboard instantiateViewControllerWithIdentifier:@"BSYearlyExpensesSummaryViewController"];

    
    yearlyViewController.collectionView = nil;
    yearlyViewController.collectionView = nil;

    controller = [[BSShowYearlyEntriesController alloc] initWithCoreDataStackHelper:coreDataStackHelper
                                                                                          coreDataController:coreDataController];
    presenter = [[BSShowYearlyEntriesPresenter alloc] initWithShowEntriesUserInterface:yearlyViewController
                                                                                         showEntriesController:controller];
    yearlyViewController.showEntriesController = controller;
    yearlyViewController.showEntriesPresenter = presenter;

    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2013"] description:@"Food and drinks" value:@"-20.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2013"] description:@"Salary" value:@"100.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Oyster card" value:@"-5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Pizza" value:@"-10" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2013"] description:@"Food and drinks" value:@"4" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2013"] description:@"Food and drinks" value:@"50.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"17/05/2013"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"18/06/2013"] description:@"Food and drinks" value:@"-70.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2013"] description:@"Food and drinks" value:@"-60.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2013"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"22/08/2013"] description:@"Food and drinks" value:@"-33.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/09/2013"] description:@"Food and drinks" value:@"-2.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/10/2013"] description:@"Food and drinks" value:@"-7.8" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2013"] description:@"Food and drinks" value:@"100.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2013"] description:@"Food and drinks" value:@"-10.1" category:nil];
    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2012"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2012"] description:@"Food and drinks" value:@"21.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2012"] description:@"Food and drinks" value:@"-7.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2012"] description:@"Food and drinks" value:@"-5.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2012"] description:@"Food and drinks" value:@"50.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"11/07/2012"] description:@"Food and drinks" value:@"30" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Food and drinks" value:@"-5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Food and drinks" value:@"7" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"20/07/2012"] description:@"Food and drinks" value:@"-1.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/07/2012"] description:@"Food and drinks" value:@"-12" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"22/08/2012"] description:@"Food and drinks" value:@"50.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/09/2012"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2012"] description:@"Food and drinks" value:@"260.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2012"] description:@"Food and drinks" value:@"50.5" category:nil];
    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2011"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2011"] description:@"Food and drinks" value:@"220.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2011"] description:@"Food and drinks" value:@"1" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2011"] description:@"Food and drinks" value:@"2" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2011"] description:@"Food and drinks" value:@"-1" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2011"] description:@"Food and drinks" value:@"50.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"17/05/2011"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"18/06/2011"] description:@"Food and drinks" value:@"20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"12" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Food and drinks" value:@"-10" category:nil];
}

- (void)tearDown
{
    coreDataStackHelper = nil;
    yearlyViewController = nil;
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"BSYESummaryTestsDataBase" stringByAppendingString:@".sqlite"]];
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"BSYESummaryTestsDataBase" stringByAppendingString:@".sqlite-shm"]];
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"BSYESummaryTestsDataBase" stringByAppendingString:@".sqlite-wal"]];

    [super tearDown];
}

#pragma mark - Tests

- (void) test_yearly_calculations_With_no_filter
{
    [yearlyViewController.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^( NSArray * _Nullable sections) {
        XCTAssertTrue(sections.count == 1);
        BSDisplaySectionData *sectionData = sections.firstObject;
        XCTAssertTrue(sectionData.entries.count == 3);
        
        BSDisplayEntry * e1 = sectionData.entries[0];
        BSDisplayEntry * e2 = sectionData.entries[1];
        BSDisplayEntry * e3 = sectionData.entries[2];
        
        XCTAssertTrue([e1.title isEqual:@"2013"]);
        XCTAssertTrue([e1.value isEqual:@"-$6.90"]);
        XCTAssertTrue([e2.title isEqual:@"2012"]);
        XCTAssertTrue([e2.value isEqual:@"$398.50"]);
        XCTAssertTrue([e3.title isEqual:@"2011"]);
        XCTAssertTrue([e3.value isEqual:@"$249.50"]);
    }];
}

- (void) test_yearly_calculations_With_filter
{
    NSArray *tags = @[@"Food", @"Bills", @"Travel"];
    [coreDataController createTags:tags];
    Tag* foodTag = [coreDataController tagForName:@"Food"];
    Tag* billsTag = [coreDataController tagForName:@"Bills"];
    Tag* travelTag = [coreDataController tagForName:@"Travel"];
    
    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-50" category:foodTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"China trip" value:@"-1000" category:travelTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-25" category:foodTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Electricity" value:@"-10" category:billsTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Rent" value:@"-10" category:billsTag];    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Food and drinks" value:@"-5" category:foodTag];
    

    
    [yearlyViewController filterChangedToCategory:foodTag];
    
    // Thi preenter i not the ame intance i created at the top of the file
    [yearlyViewController.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^( NSArray * _Nullable sections) {
        XCTAssertTrue(sections.count == 1);
        BSDisplaySectionData *sectionData = sections.firstObject;
        XCTAssertTrue(sectionData.entries.count == 2);

        BSDisplayEntry * e1 = sectionData.entries[0];
        BSDisplayEntry * e2 = sectionData.entries[1];

        XCTAssertTrue([e1.title isEqual:@"2012"]);
        XCTAssertTrue([e1.value isEqual:@"-$5.00"]);
        XCTAssertTrue([e2.title isEqual:@"2011"]);
        XCTAssertTrue([e2.value isEqual:@"-$75.00"]);
    }];
}

- (void) testGraphYearlySurplusCalculations
{
    
    BSYearlySummaryGraphLineController *controller = [[BSYearlySummaryGraphLineController alloc] initWithCoreDataStackHelper:coreDataStackHelper coreDataController:coreDataController];
    
    BSYearlySummaryGraphLinePresenter *presenter = [[BSYearlySummaryGraphLinePresenter alloc] initWithYearlySummaryGraphLineController:controller section:@"2011"];
    
    NSArray <NSNumber*>*yearlyResults = [presenter income];
    NSArray <NSString*>*abscissaValues = [presenter abscissaValues];
    
    
    NSArray <NSNumber*>* surplusExpectation = @[@(306.5), @(470), @(254)];
    NSArray <NSNumber*>* abscissaValuesExpectation = @[@"2011", @"2012", @"2013"];
    XCTAssert([surplusExpectation count] == 3);
    XCTAssert([abscissaValuesExpectation count] == 3);
    NSUInteger count = 0;
    for (NSNumber *yearlySum in yearlyResults) {
        XCTAssertTrue([yearlySum integerValue] == [surplusExpectation[count] integerValue]);
        XCTAssertTrue([abscissaValues[count] isEqual:abscissaValuesExpectation[count]]);
        count++;
    }
}


- (void) testGraphYearlyExpensesCalculations
{
    
    BSYearlySummaryGraphLineController *controller = [[BSYearlySummaryGraphLineController alloc] initWithCoreDataStackHelper:coreDataStackHelper coreDataController:coreDataController];
    
    BSYearlySummaryGraphLinePresenter *presenter = [[BSYearlySummaryGraphLinePresenter alloc] initWithYearlySummaryGraphLineController:controller section:@"2011"];
    
    NSArray <NSNumber*>*yearlyResults = [presenter expenses];
    NSArray <NSString*>*abscissaValues = [presenter abscissaValues];
    
    
    NSArray <NSNumber*>* surplusExpectation = @[@(-57), @(-71.5), @(-260.9)];
    NSArray <NSNumber*>* abscissaValuesExpectation = @[@"2011", @"2012", @"2013"];
    XCTAssert([surplusExpectation count] == 3);
    XCTAssert([abscissaValuesExpectation count] == 3);
    NSUInteger count = 0;
    for (NSNumber *yearlySum in yearlyResults) {
        XCTAssertTrue([yearlySum integerValue] == [surplusExpectation[count] integerValue]);
        XCTAssertTrue([abscissaValues[count] isEqual:abscissaValuesExpectation[count]]);
        count++;
    }
}

@end
