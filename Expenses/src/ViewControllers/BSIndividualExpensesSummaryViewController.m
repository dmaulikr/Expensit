//
//  BSDailyExpensesSummaryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSIndividualExpensesSummaryViewController.h"
#import "Entry.h"
#import "BSDailySummanryEntryCell.h"
#import "BSDailyEntryHeaderView.h"
#import "BSEntryDetailsFormViewController.h"
#import "DateTimeHelper.h"
#import "BSBaseExpensesSummaryViewController+Protected.h"

@interface BSIndividualExpensesSummaryViewController ()

@end

@implementation BSIndividualExpensesSummaryViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[self.fetchedResultsController sections] count] == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];

    return [sectionInfo numberOfObjects];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Entry *managedObject = (Entry*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    BSDailySummanryEntryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpenseCell" forIndexPath:indexPath];

    // configure the cell
    [cell configure];
    cell.title.text = managedObject.desc;
    cell.amountLabel.text = [[BSCurrencyHelper amountFormatter] stringFromNumber:managedObject.value];
    cell.amount = managedObject.value;
    
    return cell;
}   

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BSDailyEntryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self reuseIdentifierForHeader] forIndexPath:indexPath];

    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    NSArray *components = [sectionInfo.name componentsSeparatedByString:@"/"];
    headerView.titleLabel.text = [NSString stringWithFormat:@"%@ %@ %@", [components objectAtIndex:2],
                                  [DateTimeHelper monthNameForMonthNumber:[NSDecimalNumber decimalNumberWithString:[components objectAtIndex:1]]],
                                  [components objectAtIndex:0]];
    
    return headerView;
    
}


- (NSString *) reuseIdentifierForHeader
{
    return @"BSDailyEntryHeaderView";
}



#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width, 41.0f);
}



#pragma mark - BSCoreDataControllerDelegate

- (NSFetchRequest *)fetchRequest {
    return [self.coreDataController fetchRequestForIndividualEntriesSummary];
}

- (NSString*) sectionNameKeyPath
{
    return @"yearMonthDay";
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showEntriesForDay"])
    {
        BSBaseExpensesSummaryViewController *dailyExpensesViewController = (BSBaseExpensesSummaryViewController*)segue.destinationViewController;
        dailyExpensesViewController.coreDataStackHelper = self.coreDataStackHelper;
    }
    else if ([[segue identifier] isEqualToString:@"editEntryFromEntry"])
    {
        UINavigationController *navController =(UINavigationController*)segue.destinationViewController;
        BSEntryDetailsFormViewController *editEntryViewController = (BSEntryDetailsFormViewController*)[navController topViewController];
        editEntryViewController.appearanceDelegate = ((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager;
        UICollectionViewCell *selectedCell = (UICollectionViewCell *)sender;
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathForCell:selectedCell];
        int sum = 0;
        for (int i=0; i<selectedIndexPath.section; i++)
        {
            id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:i];
            sum += [sectionInfo numberOfObjects];
        }
        
        editEntryViewController.coreDataController = self.coreDataController;
        editEntryViewController.entryModel = self.fetchedResultsController.fetchedObjects[sum + selectedIndexPath.row];
        editEntryViewController.isEditingEntry = YES;
        BSStaticTableAddEntryFormCellActionDataSource *cellActionsDataSource = [[BSStaticTableAddEntryFormCellActionDataSource alloc] initWithCoreDataController:self.coreDataController isEditing:YES];
        editEntryViewController.cellActionDataSource = cellActionsDataSource;
    }
    else
    {
        [super prepareForSegue:segue sender:sender];
    }
    
}

- (void)orientationChanged:(NSNotification *)notification
{
}




@end
