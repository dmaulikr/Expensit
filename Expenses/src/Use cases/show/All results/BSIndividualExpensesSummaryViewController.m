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
#import "Expensit-Swift.h"

@interface BSIndividualExpensesSummaryViewController ()

@end

@implementation BSIndividualExpensesSummaryViewController

#pragma mark - View Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.sections count] == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.sections count];
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sections[section].numberOfEntries;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BSDisplayEntry *entry = self.sections[indexPath.section].entries[indexPath.row];
    BSDailySummanryEntryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpenseCell" forIndexPath:indexPath];

    // configure the cell
    [cell configure];
    cell.title.text = entry.title;
    cell.amountLabel.text = entry.value;
    
    return cell;
}   

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BSDailyEntryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self reuseIdentifierForHeader] forIndexPath:indexPath];

    BSDisplaySectionData *sectionInfo = self.sections[indexPath.section];
    NSArray *components = [sectionInfo.title componentsSeparatedByString:@"/"];
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showEntriesForDay"])
    {

    }
    else if ([[segue identifier] isEqualToString:@"editEntryFromEntry"])
    {
        BSIndividualEntriesSummaryNavigationTransitionManager *individualEntriesTransitionManager = (BSIndividualEntriesSummaryNavigationTransitionManager *)self.navigationTransitionManager;

        
        /*        UINavigationController *navController =(UINavigationController*)segue.destinationViewController;
         BSEntryDetailsFormViewController *editEntryViewController = (BSEntryDetailsFormViewController*)[navController topViewController];
         editEntryViewController.appearanceDelegate = ((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager;
         UICollectionViewCell *selectedCell = (UICollectionViewCell *)sender;
         NSIndexPath *selectedIndexPath = [self.collectionView indexPathForCell:selectedCell];
         int sum = 0;
         for (int i=0; i<selectedIndexPath.section; i++)
         {
         sum += self.sections[i].numberOfEntries;
         }
         
         //editEntryViewController.coreDataController = self.coreDataController;
         editEntryViewController.entryModel = self.entries[sum + selectedIndexPath.row];
         editEntryViewController.isEditingEntry = YES;
         BSStaticTableAddEntryFormCellActionDataSource *cellActionsDataSource = [[BSStaticTableAddEntryFormCellActionDataSource alloc] initWithCoreDataController:nil isEditing:YES];
         editEntryViewController.cellActionDataSource = cellActionsDataSource;*/
        

        
        
//        BSDisplaySectionData *section = self.sections[selectedIndexPath.section];
//        BSDisplayEntry *displayEntry = section.entries[selectedIndexPath.row];
//        //[individualEntriesTransitionManager configureEditEntryViewControllerWithSegue:segue andEntry:displayEntry];
//        [individualEntriesTransitionManager configureEditEntryViewControllerWithSegue:segue selectedIndexPath: selectedIndexPath];
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
