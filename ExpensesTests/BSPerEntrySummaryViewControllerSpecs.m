#import "Kiwi.h"
#import "BSIndividualExpensesSummaryViewController.h"
#import "CoreDataStackHelper.h"
#import "BSCoreDataController.h"
#import "DateTimeHelper.h"
#import "Tag.h"


@interface PerEntryTestHelper : NSObject
+ (NSArray*) entryForDate:(NSString*)dateString fromArray:(NSArray*)results;
@end

@implementation PerEntryTestHelper

+ (NSArray*) entryForDate:(NSString*)dateString fromArray:(NSArray*)results
{
    NSArray *components = [dateString componentsSeparatedByString:@"/"];
    NSDecimalNumber *day = [NSDecimalNumber decimalNumberWithString:components[0]];
    NSDecimalNumber *month = [NSDecimalNumber decimalNumberWithString:components[1]];
    NSDecimalNumber *year = [NSDecimalNumber decimalNumberWithString:components[2]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day = %@ AND month = %@ AND year = %@ ", day,  month, year];
    
    return [results filteredArrayUsingPredicate:predicate];
}

@end


@interface BSIndividualExpensesSummaryViewController ()
- (NSArray *)graphSurplusResults;
@end


SPEC_BEGIN(BSPerEntrySummaryViewControllerSpecs)

__block CoreDataStackHelper *coreDataStackHelper = nil;
__block BSCoreDataController *coreDataController = nil;
__block BSIndividualExpensesSummaryViewController *perEntryViewController = nil;

beforeAll(^{
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"myTestDataBaseEntrySummary" stringByAppendingString:@".sqlite"]];

    coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"myTestDataBaseEntrySummary"];

    
    coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:coreDataStackHelper];
    perEntryViewController = [[BSIndividualExpensesSummaryViewController alloc] init];
    KWMock *collectionMock = [KWMock nullMockForClass:UICollectionView.class];
    [perEntryViewController stub:@selector(collectionView) andReturn:collectionMock];

    perEntryViewController.coreDataStackHelper = coreDataStackHelper;
    perEntryViewController.coreDataController = coreDataController;
    
    
    KWMock *navItemMock = [KWMock nullMockForClass:UINavigationItem.class];
    [navItemMock stub:@selector(rightBarButtonItems) andReturn:@[[KWMock nullMock], [KWMock nullMock]]];
    [perEntryViewController stub:@selector(navigationItem) andReturn:navItemMock];
});

afterAll(^{
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"myTestDataBaseEntrySummary" stringByAppendingString:@".sqlite"]];
});

describe(@"Per entry calculations", ^{
    
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

    
    it(@"testIndividualEntriesCalculations", ^{
        
        [perEntryViewController filterChangedToCategory:nil];
        NSArray *entryResults = perEntryViewController.fetchedResultsController.fetchedObjects;
        [[theValue([entryResults count]) should] equal:theValue(10)];
        
        
        [[theValue([[PerEntryTestHelper entryForDate:@"13/01/2013" fromArray:entryResults] count]) should] equal:theValue(2)];
        [[theValue([[PerEntryTestHelper entryForDate:@"05/03/2013" fromArray:entryResults] count]) should] equal:theValue(2)];
        
        [[theValue([[PerEntryTestHelper entryForDate:@"02/01/2012" fromArray:entryResults] count]) should] equal:theValue(1)];
        [[theValue([[PerEntryTestHelper entryForDate:@"03/03/2012" fromArray:entryResults] count]) should] equal:theValue(2)];
        
        [[theValue([[PerEntryTestHelper entryForDate:@"19/06/2011" fromArray:entryResults] count]) should] equal:theValue(2)];
        [[theValue([[PerEntryTestHelper entryForDate:@"21/12/2011" fromArray:entryResults] count]) should] equal:theValue(1)];
        
        
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
        [perEntryViewController stub:@selector(collectionView) andReturn:collectionMock];
        
        KWMock *navItemMock = [KWMock nullMockForClass:UINavigationItem.class];
        [navItemMock stub:@selector(rightBarButtonItems) andReturn:@[[KWMock nullMock], [KWMock nullMock]]];
        [perEntryViewController stub:@selector(navigationItem) andReturn:navItemMock];

    });
    
    
    it(@"Only take into account entries from the food category", ^{
        [perEntryViewController filterChangedToCategory:foodTag];
        NSArray *dailyResults = perEntryViewController.fetchedResultsController.fetchedObjects;
        
        [[theValue([dailyResults count]) should] equal:theValue(3)];
        [[[dailyResults[0] valueForKey:@"value"] should] equal:@(-50)];
        [[[dailyResults[0] valueForKey:@"tag"] should] equal:foodTag];
        [[[dailyResults[1] valueForKey:@"value"] should] equal:@(-1000)];
        [[[dailyResults[1] valueForKey:@"tag"] should] equal:foodTag];
        [[[dailyResults[2] valueForKey:@"value"] should] equal:@(-30)];
        [[[dailyResults[2] valueForKey:@"tag"] should] equal:foodTag];
    });
    
    it(@"Only take into account entries from the travel category", ^{
        [perEntryViewController filterChangedToCategory:travelTag];
        NSArray *dailyResults = perEntryViewController.fetchedResultsController.fetchedObjects;

        [[theValue([dailyResults count]) should] equal:theValue(2)];
        [[[dailyResults[0] valueForKey:@"value"] should] equal:@(-25)];
        [[[dailyResults[0] valueForKey:@"tag"] should] equal:travelTag];
        [[[dailyResults[1] valueForKey:@"value"] should] equal:@(-100)];
        [[[dailyResults[1] valueForKey:@"tag"] should] equal:travelTag];

    });

    it(@"Only take into account entries from the bills category", ^{
        [perEntryViewController filterChangedToCategory:billsTag];
        NSArray *dailyResults = perEntryViewController.fetchedResultsController.fetchedObjects;
        
        [[theValue([dailyResults count]) should] equal:theValue(1)];
        [[[dailyResults[0] valueForKey:@"value"] should] equal:@(-5.60)];
        [[[dailyResults[0] valueForKey:@"tag"] should] equal:billsTag];
    });

});

SPEC_END