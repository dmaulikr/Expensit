#import "Kiwi.h"
#import "BSDailyExpensesSummaryViewController.h"
#import "CoreDataStackHelper.h"
#import "BSCoreDataController.h"
#import "DateTimeHelper.h"
#import "Tag.h"
#import "Expensit-Swift.h"


@interface DailyTestHelper : NSObject
+ (NSDictionary*) resultDictionaryForDate:(NSString*)dateString fromArray:(NSArray*)results;
@end

@implementation DailyTestHelper

+ (NSDictionary*) resultDictionaryForDate:(NSString*)dateString fromArray:(NSArray*)results
{
    NSArray *components = [dateString componentsSeparatedByString:@"/"];
    NSDecimalNumber *day = [NSDecimalNumber decimalNumberWithString:components[0]];
    NSDecimalNumber *month = [NSDecimalNumber decimalNumberWithString:components[1]];
    NSDecimalNumber *year = [NSDecimalNumber decimalNumberWithString:components[2]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day = %@ AND monthYear = %@", day,  [NSString stringWithFormat:@"%@/%@", month, year]];
    
    return [[results filteredArrayUsingPredicate:predicate] lastObject];
}

@end

@interface BSDailyExpensesSummaryViewController ()
- (NSArray *)graphSurplusResults;
- (NSArray *)graphExpensesResults;
@end


SPEC_BEGIN(BSDailySummaryViewControllerSpecs)

__block CoreDataStackHelper *coreDataStackHelper = nil;
__block BSCoreDataController *coreDataController = nil;
__block BSDailyExpensesSummaryViewController *dailyViewController = nil;

beforeAll(^{
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"myTestDataBase" stringByAppendingString:@".sqlite"]];
    coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"myTestDataBase"];

    
    coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:coreDataStackHelper];
    dailyViewController = [[BSDailyExpensesSummaryViewController alloc] init];
    KWMock *collectionMock = [KWMock nullMockForClass:UICollectionView.class];
    [dailyViewController stub:@selector(collectionView) andReturn:collectionMock];

    
    BSShowDailyEntriesController *controller = [[BSShowDailyEntriesController alloc] initWithCoreDataStackHelper:coreDataStackHelper
                                                                                          coreDataController:coreDataController];
    BSShowDailyEntriesPresenter *presenter = [[BSShowDailyEntriesPresenter alloc] initWithShowEntriesUserInterface:dailyViewController showEntriesController:controller];
    dailyViewController.showEntriesController = controller;
    dailyViewController.showEntriesPresenter = presenter;
});

afterAll(^{
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"myTestDataBase" stringByAppendingString:@".sqlite"]];
});


describe(@"Daily calculations", ^{
    
    beforeAll(^{
        NSArray *tags = @[@"Basic"];
        [coreDataController createTags:tags];
        Tag *foodTag = [coreDataController tagForName:@"Basic"];
        
        
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/01/2013"] description:@"Food and drinks" value:@"-20.0" category:foodTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/01/2013"] description:@"Salary" value:@"100.0" category:foodTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Oyster card" value:@"-5" category:foodTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Pizza" value:@"-10" category:foodTag];
        
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2012"] description:@"Food and drinks" value:@"-20.5" category:foodTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"03/03/2012"] description:@"Food and drinks" value:@"21.0" category:foodTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"03/03/2012"] description:@"Food and drinks" value:@"-7.0" category:foodTag];
        
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"12" category:foodTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"-5" category:foodTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Food and drinks" value:@"-10" category:foodTag];
    });
    
    afterAll(^{
        NSArray *monthlyResults = [coreDataStackHelper.managedObjectContext executeFetchRequest:[coreDataController fetchRequestForAllEntries] error:nil];
        for (NSManagedObject *obj in monthlyResults)
        {
            [coreDataStackHelper.managedObjectContext deleteObject:obj];
            
        }
        [coreDataController saveChanges];
    });

    
    it(@"testDailyCalculations", ^{
        KWMock *collectionMock = [KWMock nullMockForClass:UICollectionView.class];
        [dailyViewController stub:@selector(collectionView) andReturn:collectionMock];
        
        KWMock *navItemMock = [KWMock nullMockForClass:UINavigationItem.class];
        [navItemMock stub:@selector(rightBarButtonItems) andReturn:@[[KWMock nullMock], [KWMock nullMock]]];
        [dailyViewController stub:@selector(navigationItem) andReturn:navItemMock];
        
        [dailyViewController filterChangedToCategory:nil];
        NSArray *dailyResults = dailyViewController.showEntriesController._fetchedResultsController.fetchedObjects;
        [[theValue([dailyResults count]) should] equal:theValue(6)];
        
        
        [[[[DailyTestHelper resultDictionaryForDate:@"13/01/2013" fromArray:dailyResults] valueForKey:@"dailySum"] should] equal:@(80)];
        [[[[DailyTestHelper resultDictionaryForDate:@"05/03/2013" fromArray:dailyResults] valueForKey:@"dailySum"] should] equal:@(-15)];

        [[[[DailyTestHelper resultDictionaryForDate:@"02/01/2012" fromArray:dailyResults] valueForKey:@"dailySum"] should] equal:@(-20.5)];
        [[[[DailyTestHelper resultDictionaryForDate:@"03/03/2012" fromArray:dailyResults] valueForKey:@"dailySum"] should] equal:@(14)];

        [[[[DailyTestHelper resultDictionaryForDate:@"19/06/2011" fromArray:dailyResults] valueForKey:@"dailySum"] should] equal:@(7)];
        [[[[DailyTestHelper resultDictionaryForDate:@"21/12/2011" fromArray:dailyResults] valueForKey:@"dailySum"] should] equal:@(-10)];
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
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Fish and Chips" value:@"-1000" category:foodTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Gasoline" value:@"-25" category:travelTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Dinner" value:@"-30" category:foodTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/10/2013"] description:@"Food and drinks" value:@"-5.60" category:billsTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/10/2013"] description:@"Trip" value:@"-100" category:travelTag];
    });
    
    afterAll(^{
        NSArray *monthlyResults = [coreDataStackHelper.managedObjectContext executeFetchRequest:[coreDataController fetchRequestForAllEntries] error:nil];
        for (NSManagedObject *obj in monthlyResults)
        {
            [coreDataStackHelper.managedObjectContext deleteObject:obj];
            
        }
        [coreDataController saveChanges];
    });

    
    beforeEach(^{
        KWMock *collectionMock = [KWMock nullMockForClass:UICollectionView.class];
        [dailyViewController stub:@selector(collectionView) andReturn:collectionMock];
        
        KWMock *navItemMock = [KWMock nullMockForClass:UINavigationItem.class];
        [navItemMock stub:@selector(rightBarButtonItems) andReturn:@[[KWMock nullMock], [KWMock nullMock]]];
        [dailyViewController stub:@selector(navigationItem) andReturn:navItemMock];

    });
    
    
    it(@"Only take into account entries from the food category", ^{
        [dailyViewController filterChangedToCategory:foodTag];
        NSArray *dailyResults = dailyViewController.showEntriesController._fetchedResultsController.fetchedObjects;
        
        NSPredicate *predicate_19_July_2011 = [NSPredicate predicateWithFormat:@"day = %@ AND monthYear = %@", @(19),  [NSString stringWithFormat:@"%@/%@", @(7), @(2011)]];
        NSPredicate *predicate_19_July_2012 = [NSPredicate predicateWithFormat:@"day = %@ AND monthYear = %@", @(19),  [NSString stringWithFormat:@"%@/%@", @(7), @(2012)]];
        NSArray *results_19_July_2011 =  [[dailyResults filteredArrayUsingPredicate:predicate_19_July_2011] lastObject];
        NSArray *results_19_July_2012 =  [[dailyResults filteredArrayUsingPredicate:predicate_19_July_2012] lastObject];

        [[theValue([dailyResults count]) should] equal:theValue(2)];
        [[[results_19_July_2011 valueForKey:@"dailySum"] should] equal:@(-1050)];
        [[[results_19_July_2012 valueForKey:@"dailySum"] should] equal:@(-30)];
    });
    
    it(@"Only take into account entries from the travel category", ^{
        [dailyViewController filterChangedToCategory:travelTag];
        NSArray *dailyResults = dailyViewController.showEntriesController._fetchedResultsController.fetchedObjects;
        
        NSPredicate *predicate_19_July_2011 = [NSPredicate predicateWithFormat:@"day = %@ AND monthYear = %@", @(19),  [NSString stringWithFormat:@"%@/%@", @(7), @(2011)]];
        NSPredicate *predicate_02_Oct_2012 = [NSPredicate predicateWithFormat:@"day = %@ AND monthYear = %@", @(2),  [NSString stringWithFormat:@"%@/%@", @(10), @(2013)]];
        NSArray *results_19_July_2011 =  [[dailyResults filteredArrayUsingPredicate:predicate_19_July_2011] lastObject];
        NSArray *results_02_Oct_2012 =  [[dailyResults filteredArrayUsingPredicate:predicate_02_Oct_2012] lastObject];
        
        [[theValue([dailyResults count]) should] equal:theValue(2)];
        [[[results_19_July_2011 valueForKey:@"dailySum"] should] equal:@(-25)];
        [[[results_02_Oct_2012 valueForKey:@"dailySum"] should] equal:@(-100)];
    });

    it(@"Only take into account entries from the bills category", ^{
        [dailyViewController filterChangedToCategory:billsTag];
        NSArray *dailyResults = dailyViewController.showEntriesController._fetchedResultsController.fetchedObjects;
        
        NSPredicate *predicate_02_Oct_2013 = [NSPredicate predicateWithFormat:@"day = %@ AND monthYear = %@", @(2),  [NSString stringWithFormat:@"%@/%@", @(10), @(2013)]];
        NSArray *results_02_Oct_2013 =  [[dailyResults filteredArrayUsingPredicate:predicate_02_Oct_2013] lastObject];
        
        [[theValue([dailyResults count]) should] equal:theValue(1)];
        [[[results_02_Oct_2013 valueForKey:@"dailySum"] should] equal:@(-5.60)];
    });

});

SPEC_END
