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

@interface BSMonthlyExpensesSummaryViewController ()

@end



@implementation BSMonthlyExpensesSummaryViewController


#pragma mark - View Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showEntriesController = [[BSShowMonthlyEntriesController alloc] init];
    id<BSMonthlyExpensesSummaryPresenterEventsProtocol> mp = [[BSShowMonthlyEntriesPresenter alloc] initWithShowEntriesUserInterface:self
                                                                                                                 showEntriesController:self.showEntriesController];
    
    
    self.showEntriesPresenter = mp;
    self.showMonthlyEntriesPresenter = mp;
    
}



#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.entries count];
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12; // We always show the 12 months, even if the request doesn't have results for each month
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.sections objectAtIndex:indexPath.section];
    NSArray *fetchedObjectsForSection = [sectionInfo objects];
    NSPredicate *itemForMonthPredicate = [NSPredicate predicateWithFormat:@"month = %d", indexPath.row + 1];
    NSDictionary *itemForMonth = [[fetchedObjectsForSection filteredArrayUsingPredicate:itemForMonthPredicate] lastObject];
    
    BSMonthlySummaryEntryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpenseCell" forIndexPath:indexPath];
    
    // Determine the text of the labels
    NSString *monthLabelText = nil;
    NSString *valueLabeltext = nil;
    
    if (itemForMonth)
    {
        monthLabelText = [DateTimeHelper monthNameForMonthNumber:[itemForMonth valueForKey:@"month"]];
        valueLabeltext = [[BSCurrencyHelper amountFormatter] stringFromNumber:[itemForMonth valueForKey:@"monthlySum"]];
    }
    else
    {
        monthLabelText = [DateTimeHelper monthNameForMonthNumber:@(indexPath.row + 1)];
        valueLabeltext = @"";
    }
    
    // Labels
    [cell configure];
    
    cell.title.text = monthLabelText;
    cell.amountLabel.text = valueLabeltext;

    // Text color
    cell.amount = [itemForMonth valueForKey:@"monthlySum"];
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BSDailyEntryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self reuseIdentifierForHeader] forIndexPath:indexPath];
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.sections objectAtIndex:indexPath.section];
    headerView.titleLabel.text = sectionInfo.name;
    BSHeaderButton *headerButton = (BSHeaderButton *)headerView.pieChartButton;
    
    // TODO: Move this to a model in the view or figure out a better way to get the indexPath of the section header the button is in.
    headerButton.month = nil;
    headerButton.year = [NSDecimalNumber decimalNumberWithString:sectionInfo.name];

    return headerView;
    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDailyEntriesForMonth"])
    {
        BSBaseExpensesSummaryViewController *dailyExpensesViewController = (BSBaseExpensesSummaryViewController*)segue.destinationViewController;
        dailyExpensesViewController.coreDataStackHelper = self.coreDataStackHelper;
        UICollectionViewCell *selectedCell = (UICollectionViewCell*)sender;
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathForCell:selectedCell];
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.sections objectAtIndex:selectedIndexPath.section];

        // Create the name of the section to go to in the next VC
        NSString *sectionNameToScrollTo = [NSString stringWithFormat:@"%ld/%@", selectedIndexPath.row+1 ,sectionInfo.name]; // there are 12 months (0-11) that's why we add 1. The section name is the year
        dailyExpensesViewController.nameOfSectionToBeShown = sectionNameToScrollTo;
    }
    else if ([[segue identifier] isEqualToString:@"DisplayGraphView"])
    {
        BSGraphViewController *graphViewController = (BSGraphViewController *)[segue destinationViewController];
        [graphViewController setGraphTitle:[self visibleSectionName]];
        [graphViewController setMoneyIn:[self.showEntriesPresenter dataForGraphFromSuplusResultsForSection:[self visibleSectionName]]];
        [graphViewController setMoneyOut:[self.showEntriesPresenter dataForGraphFromExpensesResultsForSection:[self visibleSectionName]]];
        [graphViewController setXValues:[self.showEntriesPresenter abscissaValues]];
    }
    else if ([[segue identifier] isEqualToString:@"DisplayPieGraphView"])
    {
        BSHeaderButton *button = (BSHeaderButton *)sender;
        //NSArray *sections = [self.coreDataController expensesByCategoryForMonth:button.month inYear:button.year];
        NSArray *sections = [self.showMonthlyEntriesPresenter expensesByCategoryForMonth:button.month.integerValue year:button.year.integerValue];
        BSPieChartViewController *graphViewController = (BSPieChartViewController *)[segue destinationViewController];
        graphViewController.transitioningDelegate = self.animatedBlurEffectTransitioningDelegate;
        graphViewController.modalPresentationStyle = UIModalPresentationCustom;        
//        graphViewController.categories = [self.coreDataController sortedTagsByPercentageFromSections:[self.coreDataController categoriesForMonth:button.month inYear:button.year] sections:sections];
        NSArray *categories = [self.coreDataController categoriesForMonth:button.month inYear:button.year];
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
