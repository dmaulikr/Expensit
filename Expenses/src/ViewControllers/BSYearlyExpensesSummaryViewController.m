//
//  BSYearlyExpensesSummaryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 06/07/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSYearlyExpensesSummaryViewController.h"
#import "Entry.h"
#import "BSYearlySummaryEntryCell.h"
#import "BSDailyEntryHeaderView.h"
#import "DateTimeHelper.h"
#import "BSEntryDetailsFormViewController.h"
#import "BSBaseExpensesSummaryViewController+Protected.h"
#import "BSMonthlyExpensesSummaryViewController.h"
#import "CoreDataStackHelper.h"


@implementation BSYearlyExpensesSummaryViewController



#pragma mark - View Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showEntriesController = [[BSShowYearlyEntriesController alloc] init];
    self.showEntriesPresenter = [[BSShowYearlyEntriesPresenter alloc] initWithShowEntriesUserInterface:self
                                                                                 showEntriesController:self.showEntriesController];
}



#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.sections count];
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.entries count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    NSDictionary *itemForMonth = self.entries[indexPath.row];
    
    BSYearlySummaryEntryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpenseCell" forIndexPath:indexPath];
    
    // Determine the text of the labels
    NSString *monthLabelText = nil;
    NSString *valueLabeltext = nil;
    
    if (itemForMonth)
    {
        monthLabelText = [[itemForMonth valueForKey:@"year"] stringValue];
        valueLabeltext = [[BSCurrencyHelper amountFormatter] stringFromNumber:[itemForMonth valueForKey:@"yearlySum"]];
    }
    
    // Labels
    [cell configure];
    cell.title.text = monthLabelText;
    cell.amountLabel.text = valueLabeltext;
    
    // Text color
    cell.amount = [itemForMonth valueForKey:@"yearlySum"];
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BSDailyEntryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"BSDailyEntryHeaderView" forIndexPath:indexPath];
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.sections objectAtIndex:indexPath.section];
    headerView.titleLabel.text = sectionInfo.name;
    
    return headerView;
}



#pragma mark - segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showMonthlyEntries"])
    {
        BSBaseExpensesSummaryViewController *monthlyExpensesViewController = (BSBaseExpensesSummaryViewController*)segue.destinationViewController;
        UICollectionViewCell *selectedCell = (UICollectionViewCell*)sender;
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathForCell:selectedCell];

        NSString *results = [NSString stringWithFormat:@"%@", [self.entries[selectedIndexPath.row] valueForKey:@"year"]];
        monthlyExpensesViewController.nameOfSectionToBeShown = results;//[selectedIndexPath.row][@"year"];
    }
    else if ([[segue identifier] isEqualToString:@"DisplayGraphView"])
    {
        BSGraphViewController *graphViewController = (BSGraphViewController *)[segue destinationViewController];
        [graphViewController setMoneyIn:[self.showEntriesPresenter dataForGraphFromSuplusResultsForSection:@"not-ued-make-nil"]];
        [graphViewController setMoneyOut:[self.showEntriesPresenter dataForGraphFromExpensesResultsForSection:@"not-ued-make-nil"]];
        [graphViewController setXValues:[self.showEntriesPresenter abscissaValues]];
    }
    else
    {
        [super prepareForSegue:segue sender:sender];
    }
}



#pragma mark - From super class

- (BOOL)shouldScrollToSelectedSection
{
    return NO;
}

@end
