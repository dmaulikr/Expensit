//
//  BSPerMonthExpensesSummaryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 29/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSDailyExpensesSummaryViewController.h"
#import "Entry.h"
#import "BSDailyEntryHeaderView.h"
#import "BSDailySummanryEntryCell.h"
#import "DateTimeHelper.h"
#import "BSEntryDetailsFormViewController.h"
#import "BSBaseExpensesSummaryViewController+Protected.h"
#import "BSPieChartViewController.h"
#import "BSHeaderButton.h"

@interface BSDailyExpensesSummaryViewController ()
@end

@implementation BSDailyExpensesSummaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showEntriesController = [[BSShowDailyEntriesController alloc] init];
    id<BSDailyExpensesSummaryPresenterEventsProtocol> mp = [[BSShowDailyEntriesPresenter alloc] initWithShowEntriesUserInterface:self
                                                                                                        showDailyEntriesController:(id<BSShowDailyEntriesControllerProtocol>)self.showEntriesController];
    
    
    self.showEntriesPresenter = mp;
    self.showDailyEntriesPresenter = mp;
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.sections count];
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.sections objectAtIndex:section];
    NSString *monthString = [sectionInfo name];
    NSArray *components = [monthString componentsSeparatedByString:@"/"];
    
    NSRange numberOfDaysInMonth = [DateTimeHelper numberOfDaysInMonth:components[0]]; // todo: move to preenter
    return numberOfDaysInMonth.length;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.sections objectAtIndex:indexPath.section];
    NSArray *fetchedObjectsForSection = [sectionInfo objects];
    NSPredicate *itemForDayPredicate = [NSPredicate predicateWithFormat:@"day = %d AND monthYear = %@", indexPath.row + 1, sectionInfo.name];
    NSDictionary *itemForDayMonthYear = [[fetchedObjectsForSection filteredArrayUsingPredicate:itemForDayPredicate] lastObject];

    BSDailySummanryEntryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpenseCell" forIndexPath:indexPath];
    // Determine the text of the labels
    NSString *monthLabelText = nil;
    NSString *valueLabeltext = nil;

    if (itemForDayMonthYear)
    {
        monthLabelText = [[itemForDayMonthYear valueForKey:@"day"] stringValue];
        valueLabeltext = [[BSCurrencyHelper amountFormatter] stringFromNumber:[itemForDayMonthYear valueForKey:@"dailySum"]];
    }
    else
    {
        monthLabelText = [@(indexPath.row + 1) stringValue];
        valueLabeltext = @"";
    }

    
    // configure the cell
    [cell configure];
    cell.title.text = monthLabelText;
    cell.amountLabel.text = valueLabeltext;
    cell.amount = [itemForDayMonthYear valueForKey:@"dailySum"];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BSDailyEntryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self reuseIdentifierForHeader] forIndexPath:indexPath];
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.sections objectAtIndex:indexPath.section];
    
    headerView.titleLabel.text = [DateTimeHelper monthNameAndYearStringFromMonthNumberAndYear:sectionInfo.name];
    BSHeaderButton *headerButton = (BSHeaderButton *)headerView.pieChartButton;

    
    // TODO: Move this to a model in the view or figure out a better way to get the indexPath of the section header the button is in.
    NSArray *components = [sectionInfo.name componentsSeparatedByString:@"/"];
    NSString *monthString = components[0];
    NSString *yearString = components[1];
    headerButton.month = [NSDecimalNumber decimalNumberWithString:monthString];
    headerButton.year = [NSDecimalNumber decimalNumberWithString:yearString];
    return headerView;
}



#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // We want a section To fill 5/6 of the viewController's view
    NSString *monthNumber = [[self visibleSectionName] componentsSeparatedByString:@"/"][0];
    NSRange numberOfDaysInMonthRange = [DateTimeHelper numberOfDaysInMonth:monthNumber];
    NSInteger numberIfDaysInMonth = numberOfDaysInMonthRange.length;

    NSInteger numberOfColumns = 6;
    CGFloat numberOfRows = (numberIfDaysInMonth / numberOfColumns);
    CGFloat sectionHeight = self.view.bounds.size.height * 0.67;
    CGFloat cellWidth = (self.view.bounds.size.width / numberOfColumns);
    CGFloat cellHeight = (sectionHeight / numberOfRows);
    return CGSizeMake(cellWidth, cellHeight);
}



#pragma mark - BSCoreDataControllerDelegate

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showEntriesForDay"])
    {
        BSBaseExpensesSummaryViewController *dailyExpensesViewController = (BSBaseExpensesSummaryViewController*)segue.destinationViewController;
        dailyExpensesViewController.coreDataStackHelper = self.coreDataStackHelper;
        
        UICollectionViewCell *selectedCell = (UICollectionViewCell*)sender;
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathForCell:selectedCell];
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.sections objectAtIndex:selectedIndexPath.section];
        
        // Create the name of the section to go to in the next VC
        NSString *month = [sectionInfo.name componentsSeparatedByString:@"/"][0];
        NSString *year = [sectionInfo.name componentsSeparatedByString:@"/"][1];
        
        
        NSString *sectionNameToScrollTo = [NSString stringWithFormat:@"%@/%@/%ld", year, month, selectedIndexPath.row + 1];
        dailyExpensesViewController.nameOfSectionToBeShown = sectionNameToScrollTo;
    }
    else if ([[segue identifier] isEqualToString:@"DisplayGraphView"])
    {
        BSGraphViewController *graphViewController = (BSGraphViewController *)[segue destinationViewController];
        [graphViewController setGraphTitle:[DateTimeHelper monthNameAndYearStringFromMonthNumberAndYear:[self visibleSectionName]]];
        [graphViewController setMoneyIn:[self.showDailyEntriesPresenter dataForGraphFromSuplusResultsForSection:[self visibleSectionName]]];
        [graphViewController setMoneyOut:[self.showDailyEntriesPresenter dataForGraphFromExpensesResultsForSection:[self visibleSectionName]]];
        [graphViewController setXValues:[self.showDailyEntriesPresenter arrayDayNumbersInMonthFromVisibleSection:[self visibleSectionName]]];
    }
    else if ([[segue identifier] isEqualToString:@"DisplayPieGraphView"])
    {
        BSHeaderButton *button = (BSHeaderButton *)sender;
        NSArray *sections = [self.showDailyEntriesPresenter expensesByCategoryForMonth:button.month.integerValue year:button.year.integerValue];
        BSPieChartViewController *graphViewController = (BSPieChartViewController *)[segue destinationViewController];
        graphViewController.transitioningDelegate = self.animatedBlurEffectTransitioningDelegate;
        graphViewController.modalPresentationStyle = UIModalPresentationCustom;
        NSArray *categories = [self.showDailyEntriesPresenter categoriesForMonth:button.month.integerValue year:button.year.integerValue];
        graphViewController.categories = [self.showDailyEntriesPresenter sortedTagsByPercentageFromSections:categories sections:sections];
        
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

@end
