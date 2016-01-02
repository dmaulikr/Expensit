#import "Kiwi.h"
#import "BSMonthlyExpensesSummaryViewController.h"
#import "CoreDataStackHelper.h"
#import "BSCoreDataController.h"
#import "DateTimeHelper.h"
#import "Tag.h"


@interface TestHelper : NSObject 
+ (NSDictionary*) resultDictionaryForDate:(NSString*)dateString fromArray:(NSArray*)results;
@end

@implementation TestHelper

+ (NSDictionary*) resultDictionaryForDate:(NSString*)dateString fromArray:(NSArray*)results
{
    NSArray *components = [dateString componentsSeparatedByString:@"/"];
    NSDecimalNumber *month = [NSDecimalNumber decimalNumberWithString:components[0]];
    NSDecimalNumber *year = [NSDecimalNumber decimalNumberWithString:components[1]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"month = %@ AND year = %@", month, year];
    
    return [[results filteredArrayUsingPredicate:predicate] lastObject];
}

@end


@interface BSMonthlyExpensesSummaryViewController ()
- (NSArray *)graphSurplusResults;
- (NSArray *)graphExpensesResults;
@end



SPEC_BEGIN(BSMonthlySummaryViewControllerSpecs)

__block CoreDataStackHelper *coreDataStackHelper = nil;
__block BSCoreDataController *coreDataController = nil;
__block BSMonthlyExpensesSummaryViewController *monthlyViewController = nil;

beforeAll(^{
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"myTestDataBase1" stringByAppendingString:@".sqlite"]];
    coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"myTestDataBase1"];

    
    coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:coreDataStackHelper];
    monthlyViewController = [[BSMonthlyExpensesSummaryViewController alloc] init];
    monthlyViewController.coreDataStackHelper = coreDataStackHelper;
    monthlyViewController.coreDataController = coreDataController;
});

afterAll(^{
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"myTestDataBase1" stringByAppendingString:@".sqlite"]];
});

describe(@"Monthly calculations", ^{

    beforeAll(^{
        NSArray *tags = @[@"Clothing"];
        [coreDataController createTags:tags];
        Tag *clothing = [coreDataController tagForName:@"Clothing"];
        
        
        // 2013
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2013"] description:@"Food and drinks" value:@"-20.0" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2013"] description:@"Salary" value:@"100.0" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2013"] description:@"Salary" value:@"9.0" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2013"] description:@"Salary" value:@"-90.0" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2013"] description:@"Salary" value:@"23.0" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Oyster card" value:@"-5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Pizza" value:@"-10" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2013"] description:@"Food and drinks" value:@"4" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2013"] description:@"Food and drinks" value:@"50.0" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2013"] description:@"Food and drinks" value:@"-5.0" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2013"] description:@"Food and drinks" value:@"-12.0" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"17/05/2013"] description:@"Food and drinks" value:@"-20.5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"18/06/2013"] description:@"Food and drinks" value:@"-70.5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2013"] description:@"Food and drinks" value:@"-60.5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2013"] description:@"Food and drinks" value:@"-20.5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"22/08/2013"] description:@"Food and drinks" value:@"-33.5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/09/2013"] description:@"Food and drinks" value:@"-2.5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/10/2013"] description:@"Food and drinks" value:@"-7.8" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2013"] description:@"Food and drinks" value:@"18.0" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2013"] description:@"Food and drinks" value:@"3.0" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2013"] description:@"Food and drinks" value:@"2.0" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2013"] description:@"Food and drinks" value:@"10.0" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2013"] description:@"Food and drinks" value:@"-10.1" category:clothing];
        
        // 2012
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2012"] description:@"Food and drinks" value:@"-20.5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2012"] description:@"Food and drinks" value:@"21.0" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2012"] description:@"Food and drinks" value:@"-7.0" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2012"] description:@"Food and drinks" value:@"-5.0" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2012"] description:@"Food and drinks" value:@"50.5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"11/07/2012"] description:@"Food and drinks" value:@"30" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Food and drinks" value:@"-5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Food and drinks" value:@"7" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"20/07/2012"] description:@"Food and drinks" value:@"-1.5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/07/2012"] description:@"Food and drinks" value:@"-12" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"22/08/2012"] description:@"Food and drinks" value:@"50.5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/09/2012"] description:@"Food and drinks" value:@"-20.5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2012"] description:@"Food and drinks" value:@"260.5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2012"] description:@"Food and drinks" value:@"50.5" category:clothing];
        
        // 2011
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2011"] description:@"Food and drinks" value:@"-20.5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2011"] description:@"Food and drinks" value:@"220.5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2011"] description:@"Food and drinks" value:@"1" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2011"] description:@"Food and drinks" value:@"2" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2011"] description:@"Food and drinks" value:@"-1" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2011"] description:@"Food and drinks" value:@"50.5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"17/05/2011"] description:@"Food and drinks" value:@"-20.5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"18/06/2011"] description:@"Food and drinks" value:@"20.5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"12" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-5" category:clothing];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Food and drinks" value:@"-10" category:clothing];
        
        KWMock *navItemMock = [KWMock nullMockForClass:UINavigationItem.class];
        [navItemMock stub:@selector(rightBarButtonItems) andReturn:@[[KWMock nullMock], [KWMock nullMock]]];
        [monthlyViewController stub:@selector(navigationItem) andReturn:navItemMock];
    });
        
    afterAll(^{
        NSArray *monthlyResults = [coreDataStackHelper.managedObjectContext executeFetchRequest:[coreDataController fetchRequestForAllEntries] error:nil];
        for (NSManagedObject *obj in monthlyResults)
        {
            [coreDataStackHelper.managedObjectContext deleteObject:obj];
            
        }
        [coreDataController saveChanges];
    });
        
    it(@"should provide the sum of all entries grouped by month and year", ^{
        KWMock *collectionMock = [KWMock nullMockForClass:UICollectionView.class];
        [monthlyViewController stub:@selector(collectionView) andReturn:collectionMock];
        
        [monthlyViewController filterChangedToCategory:nil];
        NSArray *monthlyResults = monthlyViewController.fetchedResultsController.fetchedObjects;
        [[theValue([monthlyResults count]) should] equal:theValue(12 + 8 + 8)];
        
        [[[[TestHelper resultDictionaryForDate:@"01/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(-20)];
        [[[[TestHelper resultDictionaryForDate:@"02/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(42)];
        [[[[TestHelper resultDictionaryForDate:@"03/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(-11)];
        [[[[TestHelper resultDictionaryForDate:@"04/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(33)];
        [[[[TestHelper resultDictionaryForDate:@"05/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(-20.5)];
        [[[[TestHelper resultDictionaryForDate:@"06/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(-131)];
        [[[[TestHelper resultDictionaryForDate:@"07/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(-20.5)];
        [[[[TestHelper resultDictionaryForDate:@"08/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(-33.5)];
        [[[[TestHelper resultDictionaryForDate:@"09/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(-2.5)];
        [[[[TestHelper resultDictionaryForDate:@"10/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(-7.8)];
        [[[[TestHelper resultDictionaryForDate:@"11/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(33)];
        [[[[TestHelper resultDictionaryForDate:@"12/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(-10.1)];

        [[[[TestHelper resultDictionaryForDate:@"01/2012" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(-20.5)];
        [[[[TestHelper resultDictionaryForDate:@"03/2012" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(9)];
        [[[[TestHelper resultDictionaryForDate:@"04/2012" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(50.5)];
        [[[[TestHelper resultDictionaryForDate:@"07/2012" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(18.5)];
        [[[[TestHelper resultDictionaryForDate:@"08/2012" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(50.5)];
        [[[[TestHelper resultDictionaryForDate:@"09/2012" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(-20.5)];
        [[[[TestHelper resultDictionaryForDate:@"11/2012" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(260.5)];
        [[[[TestHelper resultDictionaryForDate:@"12/2012" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(50.5)];

        [[[[TestHelper resultDictionaryForDate:@"01/2011" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(-20.5)];
        [[[[TestHelper resultDictionaryForDate:@"02/2011" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(220.5)];
        [[[[TestHelper resultDictionaryForDate:@"03/2011" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(2)];
        [[[[TestHelper resultDictionaryForDate:@"04/2011" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(50.5)];
        [[[[TestHelper resultDictionaryForDate:@"05/2011" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(-20.5)];
        [[[[TestHelper resultDictionaryForDate:@"06/2011" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(32.5)];
        [[[[TestHelper resultDictionaryForDate:@"07/2011" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(-5)];
        [[[[TestHelper resultDictionaryForDate:@"12/2011" fromArray:monthlyResults] valueForKey:@"monthlySum"] should] equal:@(-10)];
    });
    
    it(@"testGraphMonthlySurplusCalculations", ^{
        [monthlyViewController stub:@selector(visibleSectionName) andReturn:@"2013"];
        NSArray *monthlyResults = [monthlyViewController performSelector:@selector(graphSurplusResults)];
        [[theValue([monthlyResults count]) should] equal:theValue(4)];

        // 2013
        [[[monthlyResults[0] valueForKey:@"monthlySum"] should] equal:@(132)];
        [[[monthlyResults[0] valueForKey:@"year"] should] equal:@(2013)];
        [[[monthlyResults[0] valueForKey:@"month"] should] equal:@(2)];

        [[[monthlyResults[1] valueForKey:@"monthlySum"] should] equal:@(4)];
        [[[monthlyResults[1] valueForKey:@"year"] should] equal:@(2013)];
        [[[monthlyResults[1] valueForKey:@"month"] should] equal:@(3)];

        [[[monthlyResults[2] valueForKey:@"monthlySum"] should] equal:@(50)];
        [[[monthlyResults[2] valueForKey:@"year"] should] equal:@(2013)];
        [[[monthlyResults[2] valueForKey:@"month"] should] equal:@(4)];

        [[[monthlyResults[3] valueForKey:@"monthlySum"] should] equal:@(33)];
        [[[monthlyResults[3] valueForKey:@"year"] should] equal:@(2013)];
        [[[monthlyResults[3] valueForKey:@"month"] should] equal:@(11)];


        // 2012
        [monthlyViewController stub:@selector(visibleSectionName) andReturn:@"2012"];
        monthlyResults = [monthlyViewController performSelector:@selector(graphSurplusResults)];
        [[theValue([monthlyResults count]) should] equal:theValue(6)];

        [[[monthlyResults[0] valueForKey:@"monthlySum"] should] equal:@(21)];
        [[[monthlyResults[0] valueForKey:@"year"] should] equal:@(2012)];
        [[[monthlyResults[0] valueForKey:@"month"] should] equal:@(3)];
        
        [[[monthlyResults[1] valueForKey:@"monthlySum"] should] equal:@(50.5)];
        [[[monthlyResults[1] valueForKey:@"year"] should] equal:@(2012)];
        [[[monthlyResults[1] valueForKey:@"month"] should] equal:@(4)];
        
        [[[monthlyResults[2] valueForKey:@"monthlySum"] should] equal:@(37)];
        [[[monthlyResults[2] valueForKey:@"year"] should] equal:@(2012)];
        [[[monthlyResults[2] valueForKey:@"month"] should] equal:@(7)];
        
        [[[monthlyResults[3] valueForKey:@"monthlySum"] should] equal:@(50.5)];
        [[[monthlyResults[3] valueForKey:@"year"] should] equal:@(2012)];
        [[[monthlyResults[3] valueForKey:@"month"] should] equal:@(8)];

        [[[monthlyResults[4] valueForKey:@"monthlySum"] should] equal:@(260.5)];
        [[[monthlyResults[4] valueForKey:@"year"] should] equal:@(2012)];
        [[[monthlyResults[4] valueForKey:@"month"] should] equal:@(11)];
        
        [[[monthlyResults[5] valueForKey:@"monthlySum"] should] equal:@(50.5)];
        [[[monthlyResults[5] valueForKey:@"year"] should] equal:@(2012)];
        [[[monthlyResults[5] valueForKey:@"month"] should] equal:@(12)];

        // 2011
        [monthlyViewController stub:@selector(visibleSectionName) andReturn:@"2011"];
        monthlyResults = [monthlyViewController performSelector:@selector(graphSurplusResults)];
        [[theValue([monthlyResults count]) should] equal:theValue(4)];
        
        [[[monthlyResults[0] valueForKey:@"monthlySum"] should] equal:@(220.5)];
        [[[monthlyResults[0] valueForKey:@"year"] should] equal:@(2011)];
        [[[monthlyResults[0] valueForKey:@"month"] should] equal:@(2)];
        
        [[[monthlyResults[1] valueForKey:@"monthlySum"] should] equal:@(3)];
        [[[monthlyResults[1] valueForKey:@"year"] should] equal:@(2011)];
        [[[monthlyResults[1] valueForKey:@"month"] should] equal:@(3)];
        
        [[[monthlyResults[2] valueForKey:@"monthlySum"] should] equal:@(50.5)];
        [[[monthlyResults[2] valueForKey:@"year"] should] equal:@(2011)];
        [[[monthlyResults[2] valueForKey:@"month"] should] equal:@(4)];
        
        [[[monthlyResults[3] valueForKey:@"monthlySum"] should] equal:@(32.5)];
        [[[monthlyResults[3] valueForKey:@"year"] should] equal:@(2011)];
        [[[monthlyResults[3] valueForKey:@"month"] should] equal:@(6)];
    });

    it(@"testGraphMonthlyExpensesCalculations", ^{
        [monthlyViewController stub:@selector(visibleSectionName) andReturn:@"2013"];
        NSArray *monthlyResults = [monthlyViewController performSelector:@selector(graphExpensesResults)];
        [[theValue([monthlyResults count]) should] equal:theValue(11)];
        
        // 2013
        [[[monthlyResults[0] valueForKey:@"monthlySum"] should] equal:@(-20)];
        [[[monthlyResults[0] valueForKey:@"year"] should] equal:@(2013)];
        [[[monthlyResults[0] valueForKey:@"month"] should] equal:@(1)];
        
        [[[monthlyResults[1] valueForKey:@"monthlySum"] should] equal:@(-90)];
        [[[monthlyResults[1] valueForKey:@"year"] should] equal:@(2013)];
        [[[monthlyResults[1] valueForKey:@"month"] should] equal:@(2)];
        
        [[[monthlyResults[2] valueForKey:@"monthlySum"] should] equal:@(-15)];
        [[[monthlyResults[2] valueForKey:@"year"] should] equal:@(2013)];
        [[[monthlyResults[2] valueForKey:@"month"] should] equal:@(3)];
        
        [[[monthlyResults[3] valueForKey:@"monthlySum"] should] equal:@(-17)];
        [[[monthlyResults[3] valueForKey:@"year"] should] equal:@(2013)];
        [[[monthlyResults[3] valueForKey:@"month"] should] equal:@(4)];

        [[[monthlyResults[4] valueForKey:@"monthlySum"] should] equal:@(-20.5)];
        [[[monthlyResults[4] valueForKey:@"year"] should] equal:@(2013)];
        [[[monthlyResults[4] valueForKey:@"month"] should] equal:@(5)];
        
        [[[monthlyResults[5] valueForKey:@"monthlySum"] should] equal:@(-131)];
        [[[monthlyResults[5] valueForKey:@"year"] should] equal:@(2013)];
        [[[monthlyResults[5] valueForKey:@"month"] should] equal:@(6)];
        
        [[[monthlyResults[6] valueForKey:@"monthlySum"] should] equal:@(-20.5)];
        [[[monthlyResults[6] valueForKey:@"year"] should] equal:@(2013)];
        [[[monthlyResults[6] valueForKey:@"month"] should] equal:@(7)];
        
        [[[monthlyResults[7] valueForKey:@"monthlySum"] should] equal:@(-33.5)];
        [[[monthlyResults[7] valueForKey:@"year"] should] equal:@(2013)];
        [[[monthlyResults[7] valueForKey:@"month"] should] equal:@(8)];

        [[[monthlyResults[8] valueForKey:@"monthlySum"] should] equal:@(-2.5)];
        [[[monthlyResults[8] valueForKey:@"year"] should] equal:@(2013)];
        [[[monthlyResults[8] valueForKey:@"month"] should] equal:@(9)];
        
        [[[monthlyResults[9] valueForKey:@"monthlySum"] should] equal:@(-7.8)];
        [[[monthlyResults[9] valueForKey:@"year"] should] equal:@(2013)];
        [[[monthlyResults[9] valueForKey:@"month"] should] equal:@(10)];
        
        [[[monthlyResults[10] valueForKey:@"monthlySum"] should] equal:@(-10.1)];
        [[[monthlyResults[10] valueForKey:@"year"] should] equal:@(2013)];
        [[[monthlyResults[10] valueForKey:@"month"] should] equal:@(12)];

        
        // 2012
        [monthlyViewController stub:@selector(visibleSectionName) andReturn:@"2012"];
        monthlyResults = [monthlyViewController performSelector:@selector(graphExpensesResults)];
        [[theValue([monthlyResults count]) should] equal:theValue(4)];
        
        [[[monthlyResults[0] valueForKey:@"monthlySum"] should] equal:@(-20.5)];
        [[[monthlyResults[0] valueForKey:@"year"] should] equal:@(2012)];
        [[[monthlyResults[0] valueForKey:@"month"] should] equal:@(1)];
        
        [[[monthlyResults[1] valueForKey:@"monthlySum"] should] equal:@(-12)];
        [[[monthlyResults[1] valueForKey:@"year"] should] equal:@(2012)];
        [[[monthlyResults[1] valueForKey:@"month"] should] equal:@(3)];
        
        [[[monthlyResults[2] valueForKey:@"monthlySum"] should] equal:@(-18.5)];
        [[[monthlyResults[2] valueForKey:@"year"] should] equal:@(2012)];
        [[[monthlyResults[2] valueForKey:@"month"] should] equal:@(7)];
        
        [[[monthlyResults[3] valueForKey:@"monthlySum"] should] equal:@(-20.5)];
        [[[monthlyResults[3] valueForKey:@"year"] should] equal:@(2012)];
        [[[monthlyResults[3] valueForKey:@"month"] should] equal:@(9)];
        
        
        // 2011
        [monthlyViewController stub:@selector(visibleSectionName) andReturn:@"2011"];
        monthlyResults = [monthlyViewController performSelector:@selector(graphExpensesResults)];
        [[theValue([monthlyResults count]) should] equal:theValue(5)];
        
        [[[monthlyResults[0] valueForKey:@"monthlySum"] should] equal:@(-20.5)];
        [[[monthlyResults[0] valueForKey:@"year"] should] equal:@(2011)];
        [[[monthlyResults[0] valueForKey:@"month"] should] equal:@(1)];
        
        [[[monthlyResults[1] valueForKey:@"monthlySum"] should] equal:@(-1)];
        [[[monthlyResults[1] valueForKey:@"year"] should] equal:@(2011)];
        [[[monthlyResults[1] valueForKey:@"month"] should] equal:@(3)];
        
        [[[monthlyResults[2] valueForKey:@"monthlySum"] should] equal:@(-20.5)];
        [[[monthlyResults[2] valueForKey:@"year"] should] equal:@(2011)];
        [[[monthlyResults[2] valueForKey:@"month"] should] equal:@(5)];
        
        [[[monthlyResults[3] valueForKey:@"monthlySum"] should] equal:@(-5)];
        [[[monthlyResults[3] valueForKey:@"year"] should] equal:@(2011)];
        [[[monthlyResults[3] valueForKey:@"month"] should] equal:@(7)];
        
        [[[monthlyResults[4] valueForKey:@"monthlySum"] should] equal:@(-10)];
        [[[monthlyResults[4] valueForKey:@"year"] should] equal:@(2011)];
        [[[monthlyResults[4] valueForKey:@"month"] should] equal:@(12)];

    });

});


describe(@"Category filtering", ^{

    __block Tag* foodTag;
    __block Tag* billsTag;
    __block Tag* travelTag;
    
    beforeAll(^{
        
        NSArray *tags = @[@"Food", @"Bills", @"Travel"];
        [coreDataController createTags:tags];
        foodTag = [coreDataController tagForName:@"Food"];
        billsTag = [coreDataController tagForName:@"Bills"];
        travelTag = [coreDataController tagForName:@"Travel"];

        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-50" category:foodTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"China trip" value:@"-1000" category:travelTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"23/07/2011"] description:@"Food and drinks" value:@"-25" category:foodTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Electricity" value:@"-10" category:billsTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/10/2012"] description:@"Food and drinks" value:@"-5" category:foodTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Rent" value:@"-10" category:billsTag];
        
        KWMock *navItemMock = [KWMock nullMockForClass:UINavigationItem.class];
        [navItemMock stub:@selector(rightBarButtonItems) andReturn:@[[KWMock nullMock], [KWMock nullMock]]];
        [monthlyViewController stub:@selector(navigationItem) andReturn:navItemMock];

    });
    
    afterAll(^{
        NSArray *monthlyResults = [coreDataStackHelper.managedObjectContext executeFetchRequest:[coreDataController fetchRequestForAllEntries] error:nil];
        for (NSManagedObject *obj in monthlyResults)
        {
            [coreDataStackHelper.managedObjectContext deleteObject:obj];
            
        }
        [coreDataController saveChanges];
    });

    
    it(@"Only take into account entries from the specified category", ^{
        KWMock *collectionMock = [KWMock nullMockForClass:UICollectionView.class];
        [monthlyViewController stub:@selector(collectionView) andReturn:collectionMock];

        [monthlyViewController filterChangedToCategory:foodTag];
        NSArray *monthlyResults = monthlyViewController.fetchedResultsController.fetchedObjects;
        
        NSPredicate *predicateJuly = [NSPredicate predicateWithFormat:@"month = %@", (NSNumber *)[NSDecimalNumber decimalNumberWithString:@"7"]];
        NSPredicate *predicateOctober = [NSPredicate predicateWithFormat:@"month = %@", (NSNumber *)[NSDecimalNumber decimalNumberWithString:@"10"]];
        NSArray *resultsJuly =  [[monthlyResults filteredArrayUsingPredicate:predicateJuly] lastObject];
        NSArray *resultsOctober =  [[monthlyResults filteredArrayUsingPredicate:predicateOctober] lastObject];

        [[theValue([monthlyResults count]) should] equal:theValue(2)];
        [[[resultsJuly valueForKey:@"monthlySum"] should] equal:@(-75)];
        [[[resultsOctober valueForKey:@"monthlySum"] should] equal:@(-5)];
    });
});





SPEC_END