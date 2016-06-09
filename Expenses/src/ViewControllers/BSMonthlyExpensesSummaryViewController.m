//
//  BSMonthlyExpensesSummaryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 23/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSMonthlyExpensesSummaryViewController.h"
#import "BSBaseExpensesSummaryViewController+Protected.h"
#import "Entry.h"
#import "BSMonthlySummaryEntryCell.h"
#import "BSDailyEntryHeaderView.h"
#import "DateTimeHelper.h"
#import "BSEntryDetailsFormViewController.h"
#import "BSGraphViewController.h"
#import "LineGraph.h"
#import "BSPieChartViewController.h"
#import "Expensit-Swift.h"

@implementation BSMonthlyExpensesSummaryViewController


#pragma mark - View Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];    
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
    BSDisplayEntry *itemForMonth = self.sections[indexPath.section].entries[indexPath.row];    
    BSMonthlySummaryEntryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpenseCell" forIndexPath:indexPath];
    
    // Determine the text of the labels
    NSString *monthLabelText = itemForMonth.title;
    NSString *valueLabeltext = itemForMonth.value;
    
    // Labels
    [cell configure];
    cell.title.text = monthLabelText;
    cell.amountLabel.text = valueLabeltext;

    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BSDailyEntryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:[self reuseIdentifierForHeader]
                                                                                   forIndexPath:indexPath];
    headerView.titleLabel.text = self.sections[indexPath.section].title;
    BSHeaderButton *headerButton = (BSHeaderButton *)headerView.pieChartButton;
    
    // TODO: Move this to a model in the view or figure out a better way to get the indexPath of the section header the button is in.
    headerButton.month = nil;
    headerButton.year = [NSDecimalNumber decimalNumberWithString:self.sections[indexPath.section].title];

    return headerView;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BSMonthlySummaryNavigationTransitionManager *monthlyTransitionManager = (BSMonthlySummaryNavigationTransitionManager *)self.navigationTransitionManager;

    if ([[segue identifier] isEqualToString:@"showDailyEntriesForMonth"])
    {
//        BSBaseExpensesSummaryViewController *dailyExpensesViewController = (BSBaseExpensesSummaryViewController*)segue.destinationViewController;        
        UICollectionViewCell *selectedCell = (UICollectionViewCell*)sender;
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathForCell:selectedCell];
        BSDisplaySectionData *sectionInfo = self.sections[selectedIndexPath.section];
//
//        // Create the name of the section to go to in the next VC
        NSString *sectionNameToScrollTo = [NSString stringWithFormat:@"%ld/%@", selectedIndexPath.row+1 ,sectionInfo.title]; // there are 12 months (0-11) that's why we add 1. The section name is the year
//        dailyExpensesViewController.nameOfSectionToBeShown = sectionNameToScrollTo;
        
        [monthlyTransitionManager configureDailyExpensesViewControllerWithSegue:segue nameOfSectionToBeShown:sectionNameToScrollTo];



    }
    else if ([[segue identifier] isEqualToString:@"DisplayGraphView"])
    {
        [monthlyTransitionManager configureMonthlyExpensesLineGraphViewControllerWithSegue:segue section:[self visibleSectionName]];
    }
    else if ([[segue identifier] isEqualToString:@"DisplayPieGraphView"])
    {
        BSHeaderButton *button = (BSHeaderButton *)sender;
        NSArray *sections = [self.showMonthlyEntriesPresenter expensesByCategoryForMonth:button.month year:button.year.integerValue];
        BSPieChartViewController *graphViewController = (BSPieChartViewController *)[segue destinationViewController];
        graphViewController.transitioningDelegate = self.animatedBlurEffectTransitioningDelegate;
        graphViewController.modalPresentationStyle = UIModalPresentationCustom;        
        NSArray *categories = [self.showMonthlyEntriesPresenter categoriesForMonth:button.month year:button.year.integerValue];
        graphViewController.categories = [self.showMonthlyEntriesPresenter sortedTagsByPercentageFromSections:categories sections:sections];

        [graphViewController setSections:sections];
    }
    else
    {
        [super prepareForSegue:segue sender:sender];
    }    
}


- (NSString *) reuseIdentifierForHeader
{
    return @"BSDailyEntryHeaderView";
}



#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // We want a section of 4 rows by 3 columns to fill 90% of the screen
    NSInteger numberOfColumns = 3;
    CGFloat numberOfRows = 4;
    CGFloat sectionHeight = self.view.bounds.size.height * 0.90;
    CGFloat cellWidth = (self.view.bounds.size.width / numberOfColumns);
    CGFloat cellHeight = (sectionHeight / numberOfRows);
    return CGSizeMake(cellWidth, cellHeight);
}

@end
