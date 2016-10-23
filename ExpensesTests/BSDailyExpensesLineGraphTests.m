//
//  BSDailyExpensesLineGraphTests.m
//  Expenses
//
//  Created by Borja Arias Drake on 16/10/2016.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BSDailyExpensesSummaryViewController.h"
#import "CoreDataStackHelper.h"
#import "BSCoreDataController.h"
#import "DateTimeHelper.h"
#import "OCMock/Headers/OCMock/OCMock.h"
#import "Expensit-Swift.h"

static CoreDataStackHelper *coreDataStackHelper;
static BSCoreDataController *coreDataController;
static NSString *expectedVisibleSectionName;
static BSDailySummaryGraphLineController *controller;

@interface BSDailyExpensesLineGraphTests : XCTestCase
@end


@implementation BSDailyExpensesLineGraphTests

+ (void)setUp
{
    [super setUp];
    
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"myTestDataBaseLineGraphTests" stringByAppendingString:@".sqlite"]];
    
    coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType
                                                                          resourceName:@"Expenses"
                                                                             extension:@"momd"
                                                                   persistentStoreName:@"myTestDataBaseLineGraphTests"];
    coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:coreDataStackHelper];
    controller = [[BSDailySummaryGraphLineController alloc] initWithCoreDataStackHelper:coreDataStackHelper
                                                                          coreDataController:coreDataController];
    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/01/2013"] description:@"Food and drinks" value:@"-20.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/01/2013"] description:@"Salary" value:@"100.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Oyster card" value:@"-5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Pizza" value:@"-10" category:nil];
    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2012"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"03/03/2012"] description:@"Food and drinks" value:@"21.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"03/03/2012"] description:@"Food and drinks" value:@"-7.0" category:nil];
    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"12" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"-5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Food and drinks" value:@"-10" category:nil];
}

+ (void)tearDown {
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"myTestDataBaseLineGraphTests" stringByAppendingString:@".sqlite"]];
}


- (void)testGraphDailySurplusCalculations {
    BSDailySummaryGraphLinePresenter *presenter = [[BSDailySummaryGraphLinePresenter alloc] initWithDailySummaryGraphLineController:controller section:@"1/2013"];

    NSArray <NSNumber*>*dailyReults = [presenter income];
    
    // Jan 2013
    NSArray <NSNumber*>* expectation = @[@0, @0, @0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@100,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0];
    XCTAssert([dailyReults count] == 31);
    XCTAssertTrue([dailyReults[13] integerValue] == 100);
    NSUInteger count = 0;
    for (NSNumber *dailySum in dailyReults) {
        XCTAssertTrue([dailySum integerValue] == [expectation[count] integerValue]);
        count++;
    }

    // March 2013
    presenter.section = @"3/2013";
    dailyReults = [presenter income];
    XCTAssert([dailyReults count] == 31);
    for (NSNumber *dailySum in dailyReults) {
        XCTAssert([dailySum integerValue] == 0);
    }
    
    // Jan 2012
    presenter.section = @"1/2012";
    dailyReults = [presenter income];
    XCTAssert([dailyReults count] == 31);
    for (NSNumber *dailySum in dailyReults) {
        XCTAssert([dailySum integerValue] == 0);
    }
    
    // March 2012
    expectation = @[@0, @0, @0, @21,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0];
    presenter.section = @"3/2012";
    dailyReults = [presenter income];
    XCTAssert([dailyReults count] == 31);
    count = 0;
    for (NSNumber *dailySum in dailyReults) {
        XCTAssertTrue([dailySum integerValue] == [expectation[count] integerValue]);
        count++;
    }

    
    // Jun 2011
    expectation = @[@0, @0, @0, @0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@12,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0];
    presenter.section = @"6/2011";
    dailyReults = [presenter income];
    XCTAssert([dailyReults count] == 30);
    count = 0;
    for (NSNumber *dailySum in dailyReults) {
        XCTAssertTrue([dailySum integerValue] == [expectation[count] integerValue]);
        count++;
    }

    
    // Dec 2011
    presenter.section = @"12/2011";
    dailyReults = [presenter income];
    XCTAssert([dailyReults count] == 31);
    for (NSNumber *dailySum in dailyReults) {
        XCTAssert([dailySum integerValue] == 0);
    }

}

- (void)testGraphDailyExpensesCalculations {
    
    // Jan 2013
    BSDailySummaryGraphLinePresenter *presenter = [[BSDailySummaryGraphLinePresenter alloc] initWithDailySummaryGraphLineController:controller section:@"1/2013"];
    NSArray *dailyReults = [presenter expenses];
    NSArray <NSNumber*>* expectation = @[@0, @0, @0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@(-20),@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0];
    XCTAssert([dailyReults count] == 31);
    NSUInteger count = 0;
    for (NSNumber *dailySum in dailyReults) {
        XCTAssertTrue([dailySum integerValue] == [expectation[count] integerValue]);
        count++;
    }

    // March 2013
    presenter.section = @"3/2013";
    expectation = @[@0, @0, @0,@0,@0,@(-15),@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0];
    dailyReults = [presenter expenses];
    XCTAssert([dailyReults count] == 31);
    count = 0;
    for (NSNumber *dailySum in dailyReults) {
        XCTAssertTrue([dailySum integerValue] == [expectation[count] integerValue]);
        count++;
    }
    
    // Jan 2012
    presenter.section = @"1/2012";
    dailyReults = [presenter expenses];
    expectation = @[@0, @0, @(-20.5),@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0];
    dailyReults = [presenter expenses];
    XCTAssert([dailyReults count] == 31);
    count = 0;
    for (NSNumber *dailySum in dailyReults) {
        XCTAssertTrue([dailySum integerValue] == [expectation[count] integerValue]);
        count++;
    }
    
    // March 2012
    presenter.section = @"3/2012";
    dailyReults = [presenter expenses];
    expectation = @[@0, @0, @0, @(-7), @0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0];
    XCTAssert([dailyReults count] == 31);
    count = 0;
    for (NSNumber *dailySum in dailyReults) {
        XCTAssertTrue([dailySum integerValue] == [expectation[count] integerValue]);
        count++;
    }
    
    // Jun 2011
    presenter.section = @"6/2011";
    dailyReults = [presenter expenses];
    expectation = @[@0, @0, @0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@(-5),@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0];
    XCTAssert([dailyReults count] == 30);
    count = 0;
    for (NSNumber *dailySum in dailyReults) {
        XCTAssertTrue([dailySum integerValue] == [expectation[count] integerValue]);
        count++;
    }
    
    // Dec 2011
    presenter.section = @"12/2011";
    dailyReults = [presenter expenses];
    expectation = @[@0, @0, @0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@(-10),@0,@0,@0,@0,@0,@0,@0,@0,@0];
    XCTAssert([dailyReults count] == 31);
    count = 0;
    for (NSNumber *dailySum in dailyReults) {
        XCTAssertTrue([dailySum integerValue] == [expectation[count] integerValue]);
        count++;
    }
}

@end
