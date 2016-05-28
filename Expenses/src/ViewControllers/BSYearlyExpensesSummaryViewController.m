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


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectionIndex
{
    BSDisplaySectionData *sectionData = self.sections[sectionIndex];
    return sectionData.numberOfEntries;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    BSDisplayEntry *itemForYear = self.sections[indexPath.section].entries[indexPath.row];
    BSYearlySummaryEntryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpenseCell" forIndexPath:indexPath];
    
    // Determine the text of the labels
    NSString *yearLabelText = yearLabelText = itemForYear.title;
    NSString *valueLabeltext = itemForYear.value;

    // Labels
    [cell configure];
    cell.title.text = yearLabelText; // set text
    cell.amountLabel.text = valueLabeltext; // remove
    
    switch (itemForYear.signOfAmount)
    {
        case BSNumberSignTypeZero:
            cell.isPositive = YES;
        case BSNumberSignTypePositive:
            cell.isPositive = YES;
        case BSNumberSignTypeNegative:
            cell.isPositive = NO;
    }

    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BSDailyEntryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"BSDailyEntryHeaderView" forIndexPath:indexPath];
    headerView.titleLabel.text = self.sections[indexPath.section].title;
    
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
        monthlyExpensesViewController.nameOfSectionToBeShown = self.sections[selectedIndexPath.section].entries[selectedIndexPath.row].title;
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
