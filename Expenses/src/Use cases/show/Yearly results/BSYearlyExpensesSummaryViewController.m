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
#import "Expensit-Swift.h"

@implementation BSYearlyExpensesSummaryViewController



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
    NSString *yearLabelText = itemForYear.title;
    NSString *valueLabeltext = itemForYear.value;

    // Labels
    [cell configure];
    cell.title.text = yearLabelText; // set text
    cell.amountLabel.text = valueLabeltext; // remove
    
    switch (itemForYear.signOfAmount)
    {
        case BSNumberSignTypeZero:
            cell.isPositive = YES;
            break;
        case BSNumberSignTypePositive:
            cell.isPositive = YES;
            break;
        case BSNumberSignTypeNegative:
            cell.isPositive = NO;
            break;
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
    BSYearlySummaryNavigationTransitionManager *yearlyTransitionManager = (BSYearlySummaryNavigationTransitionManager *)self.navigationTransitionManager;
    if ([[segue identifier] isEqualToString:@"showMonthlyEntries"])
    {
        UICollectionViewCell *selectedCell = (UICollectionViewCell*)sender;
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathForCell:selectedCell];
        [yearlyTransitionManager configureMonthlyExpensesViewControllerWithSegue:segue
                                                          nameOfSectionToBeShown:self.sections[selectedIndexPath.section].entries[selectedIndexPath.row].title];
    }
    else if ([[segue identifier] isEqualToString:@"DisplayGraphView"])
    {
        [yearlyTransitionManager configureYearlyExpensesLineGraphViewControllerWithSegue:segue section:@""]; // not ued make nil
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
