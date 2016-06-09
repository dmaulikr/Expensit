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
#import "Expensit-Swift.h"

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
    return self.sections[section].numberOfEntries;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BSDisplayEntry *itemForDayMonthYear = self.sections[indexPath.section].entries[indexPath.row];
    BSDailySummanryEntryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpenseCell" forIndexPath:indexPath];
    
    // Determine the text of the labels
    NSString *dayLabelText = itemForDayMonthYear.title;
    NSString *valueLabeltext = itemForDayMonthYear.value;
    
    // configure the cell
    [cell configure];
    cell.title.text = dayLabelText;
    cell.amountLabel.text = valueLabeltext;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BSDailyEntryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self reuseIdentifierForHeader] forIndexPath:indexPath];
    
    NSString *sectionTitle = self.sections[indexPath.section].title;
    headerView.titleLabel.text = [DateTimeHelper monthNameAndYearStringFromMonthNumberAndYear:sectionTitle];
    BSHeaderButton *headerButton = (BSHeaderButton *)headerView.pieChartButton;
    
    // TODO: Move this to a model in the view or figure out a better way to get the indexPath of the section header the button is in.
    NSArray *components = [sectionTitle componentsSeparatedByString:@"/"];
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
        
        UICollectionViewCell *selectedCell = (UICollectionViewCell*)sender;
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathForCell:selectedCell];
        NSString *sectionTitle = self.sections[selectedIndexPath.section].title;        
        dailyExpensesViewController.nameOfSectionToBeShown = [self.showDailyEntriesPresenter sectionNameForSelectedIndexPath:selectedIndexPath sectionTitle:sectionTitle];// sectionNameToScrollTo;
    }
    else if ([[segue identifier] isEqualToString:@"DisplayGraphView"])
    {
        BSDailySummaryNavigationTransitionManager *dailyTransitionManager = (BSDailySummaryNavigationTransitionManager *)self.navigationTransitionManager;
        [dailyTransitionManager configureDailyExpensesLineGraphViewControllerWithSegue:segue section:[self visibleSectionName]];

    }
    else if ([[segue identifier] isEqualToString:@"DisplayPieGraphView"])
    {
        BSHeaderButton *button = (BSHeaderButton *)sender;
        NSArray *sections = [self.showDailyEntriesPresenter expensesByCategoryForMonth:button.month year:button.year.integerValue];
        BSPieChartViewController *graphViewController = (BSPieChartViewController *)[segue destinationViewController];
        graphViewController.transitioningDelegate = self.animatedBlurEffectTransitioningDelegate;
        graphViewController.modalPresentationStyle = UIModalPresentationCustom;
        NSArray *categories = [self.showDailyEntriesPresenter categoriesForMonth:button.month year:button.year.integerValue];
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
