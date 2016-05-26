//
//  BSBaseExpensesSummaryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSBaseExpensesSummaryViewController.h"
#import "CoreDataStackHelper.h"
#import "BSBaseExpenseCell.h"
#import "DateTimeHelper.h"
#import "BSGraphViewController.h"
#import "BSBaseExpensesSummaryViewController+Protected.h"
#import "BSCoreDataController.h"
#import "BSEntryDetailsFormViewController.h"
#import "BSCategoryFilterViewController.h"
#import "BSNavigationControllerViewController.h"
#import "BSVisualEffects.h"
#import "BSModalSelectorViewTransitioningDelegate.h"
#import "BSAnimatedBlurEffectTransitioningDelegate.h"


static Tag *tagBeingFilterBy = nil;

@interface BSBaseExpensesSummaryViewController ()
@property (nonatomic, assign) BOOL isShowingLandscapeView;
@property (nonatomic, strong) BSModalSelectorViewTransitioningDelegate *categoryFilterViewTransitioningDelegate;
@end

@implementation BSBaseExpensesSummaryViewController


#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstTimeViewWillAppear = YES;
    
    // Prepare for Landscape
    self.isShowingLandscapeView = NO;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

    // NavBar buttons
    UIBarButtonItem *filterButton = self.navigationItem.rightBarButtonItems[1];
    
    // Request image for category filter
    [self.showEntriesPresenter viewIsReadyToDisplayImageForCategory:nil];
    
    UIBarButtonItem *addButton = self.navigationItem.rightBarButtonItems[0];
    self.navigationItem.rightBarButtonItems = @[addButton, filterButton];
    
    // Category filter view controller transitioning delegate
    self.categoryFilterViewTransitioningDelegate = [[BSModalSelectorViewTransitioningDelegate alloc] init];
    self.animatedBlurEffectTransitioningDelegate = [[BSAnimatedBlurEffectTransitioningDelegate alloc] init];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Request data
    [self.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^(NSArray * _Nullable entries, NSArray * _Nullable sections) {
        self.entries = entries;
        self.sections = sections;
        [self.collectionView reloadData];
        
        // Apply filter before calculating section to go to
        [self filterChangedToCategory:tagBeingFilterBy takingScreenshot:NO];
        
        // Scroll to selected section
        [self scrollToSelectedSection];
    }];

}


- (void)scrollToSelectedSection
{
    if (self.shouldScrollToSelectedSection && self.firstTimeViewWillAppear)
    {
        self.firstTimeViewWillAppear = NO;
        NSArray *sectionNames = [self.entries valueForKeyPath:[self.showEntriesPresenter sectionNameKeyPath]];
        NSMutableArray* uniqueSectionNames = [[NSMutableArray alloc] init];
        for(id sectionName in sectionNames)
        {
            if(![uniqueSectionNames containsObject:sectionName])
            {
                [uniqueSectionNames addObject:[NSString stringWithFormat:@"%@", sectionName]];
            }
        }
        NSArray *filteredArray = [uniqueSectionNames filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self = %@", self.nameOfSectionToBeShown]];
        NSInteger sectionToScrollTo = [uniqueSectionNames indexOfObject:[filteredArray lastObject]];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sectionToScrollTo];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        UIView *header = (UIView *)[self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[self reuseIdentifierForHeader] forIndexPath:indexPath];
        CGPoint offset = self.collectionView.contentOffset;
        offset.y -= header.frame.size.height;
        self.collectionView.contentOffset = offset;
    }
}



#pragma mark - NavBar button actions

- (void)filterButtonTapped
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    BSCategoryFilterViewController *categoryFilterViewController = (BSCategoryFilterViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"categoryFilterViewController"];
    
    categoryFilterViewController.transitioningDelegate = self.categoryFilterViewTransitioningDelegate;
    categoryFilterViewController.modalPresentationStyle = UIModalPresentationCustom;
    categoryFilterViewController.delegate = self;
    categoryFilterViewController.selectedTag = tagBeingFilterBy;
    NSDictionary *info = [self.showEntriesPresenter tagInfo];
    categoryFilterViewController.categories = info[@"tags"];
    categoryFilterViewController.categoryImages = info[@"images"];
    
    [self presentViewController:categoryFilterViewController animated:YES completion:nil];
}


- (void)addButtonTappedWithPresentationCompletedBlock:(void (^ __nullable)(void))completion
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    UINavigationController *navController = (UINavigationController *)[storyBoard instantiateViewControllerWithIdentifier:@"addEntryNavigationController"];
    
    
    BSStaticTableAddEntryFormCellActionDataSource *cellActionsDataSource = [[BSStaticTableAddEntryFormCellActionDataSource alloc] initWithCoreDataController:self.coreDataController isEditing:NO];
    BSEntryDetailsFormViewController *addEntryVC = (BSEntryDetailsFormViewController*)navController.topViewController;
    addEntryVC.isEditingEntry = NO;
    addEntryVC.entryModel = [self.coreDataController newEntry];
    addEntryVC.cellActionDataSource = cellActionsDataSource;
    addEntryVC.coreDataController = self.coreDataController;
    addEntryVC.appearanceDelegate = ((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager;
    
    [self presentViewController:navController animated:YES completion:completion];
}



#pragma mark - Landscape Presentation

- (void)orientationChanged:(NSNotification *)notification
{
    if (self == [[self navigationController] topViewController]) {
        UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
        if (UIDeviceOrientationIsLandscape(deviceOrientation) && !self.isShowingLandscapeView)
        {
            [self performSegueWithIdentifier:@"DisplayGraphView" sender:self];
            self.isShowingLandscapeView = YES;
        }
        else if (UIDeviceOrientationIsPortrait(deviceOrientation) && self.isShowingLandscapeView )
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            self.isShowingLandscapeView = NO;
        }
    }
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}



#pragma mark - segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAddEntryForm"])
    {
        UINavigationController *navigationController = (UINavigationController *)[segue destinationViewController];
        BSStaticTableAddEntryFormCellActionDataSource *cellActionsDataSource = [[BSStaticTableAddEntryFormCellActionDataSource alloc] initWithCoreDataController:self.coreDataController isEditing:NO];
        BSEntryDetailsFormViewController *addEntryVC = (BSEntryDetailsFormViewController*)navigationController.topViewController;
        addEntryVC.isEditingEntry = NO;
        addEntryVC.entryModel = [self.coreDataController newEntry];
        addEntryVC.cellActionDataSource = cellActionsDataSource;
        addEntryVC.coreDataController = self.coreDataController;
        addEntryVC.appearanceDelegate = ((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager;
        
    }
    else if ([[segue identifier] isEqualToString:@"showFilter"])
    {
        BSCategoryFilterViewController *categoryFilterViewController = (BSCategoryFilterViewController *)[segue destinationViewController];
        
        categoryFilterViewController.transitioningDelegate = self.categoryFilterViewTransitioningDelegate;
        categoryFilterViewController.modalPresentationStyle = UIModalPresentationCustom;
        categoryFilterViewController.delegate = self;
        categoryFilterViewController.selectedTag = tagBeingFilterBy;
        NSDictionary *info = [self.showEntriesPresenter tagInfo];
        categoryFilterViewController.categories = info[@"tags"];
        categoryFilterViewController.categoryImages = info[@"images"];
    }
}



#pragma mark - UICollectionView

- (IBAction) cancelAddEntry:(UIStoryboardSegue*)segue
{
    
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BSBaseExpenseCell *cell = (BSBaseExpenseCell*)[collectionView cellForItemAtIndexPath:indexPath];
    return (cell.amountLabel.text && (cell.amountLabel.text.length > 0));
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (NSString*) visibleSectionName
{
    //TODO: IN case of a TIE, choose the section with the newest date
    NSArray *visibleCells = [self.collectionView visibleCells];
    NSMutableDictionary *occurences = [NSMutableDictionary dictionary];
    for (UICollectionViewCell *cell in visibleCells)
    {
        NSNumber *sectionNumber = [NSNumber numberWithInteger:[self.collectionView indexPathForCell:cell].section];
        NSNumber * count = occurences[sectionNumber];
        if (count)
        {
            count = [NSNumber numberWithInt:[count intValue] + 1];
        }
        else
        {
            count = @1;
        }
        
        occurences[sectionNumber] = count;
    }
    
    
    // Find the max in the ocurrences dictionary
    NSNumber *sectionWithMostVisibleCells = nil;
    for (id key in [occurences allKeys])
    {
        if (sectionWithMostVisibleCells)
        {
            NSComparisonResult comparisonResult = [occurences[key] compare:occurences[sectionWithMostVisibleCells]];
            if ((comparisonResult == NSOrderedDescending) || (comparisonResult == NSOrderedSame)) // To un-tie. This makes some asumptions, like that the cells are ordered ascending, and that we are presenting the calendar ascending.. 2012 at the top... 2013 if you scroll down
            {
                sectionWithMostVisibleCells = key;
            }
        }
        else
        {
            // first iteration, set current key to be the maximum
            sectionWithMostVisibleCells = key;
        }
    }
    
    id <NSFetchedResultsSectionInfo> sectionInfo = nil;
    
    if ([self.sections count] > 0)
    {
        sectionInfo = [self.sections objectAtIndex:[sectionWithMostVisibleCells intValue]];
    }

    return sectionInfo.name;
}


- (NSString*) reuseIdentifierForHeader
{
    @throw @"Implement in subclasses";
}


- (BOOL) shouldScrollToSelectedSection
{
    return YES;
}


#pragma mark - Dealloc

- (void)dealloc
{
    // Remove notification observations
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}



#pragma mark - BSCategoryFilterDelegate

- (void)filterChangedToCategory:(Tag *)tag
{
    [self filterChangedToCategory:tag takingScreenshot:YES];
}


- (void)filterChangedToCategory:(Tag *)tag takingScreenshot:(BOOL)shouldTakeScreenshot
{
    // So we remember when bringing the modal view back again
    // The argument is already a Tag* reference or nil
    tagBeingFilterBy = tag;
    
    // Change buttons
    UIBarButtonItem *filterButton = self.navigationItem.rightBarButtonItems[1];
    [self.showEntriesPresenter viewIsReadyToDisplayImageForCategory:tag]; // notify filter need ne image

    UIBarButtonItem *addButton = self.navigationItem.rightBarButtonItems[0];
    self.navigationItem.rightBarButtonItems = @[addButton, filterButton];

    // Notify that flilter changed
    [self.showEntriesPresenter filterChangedToCategory:tag]; // thi could be unified ith previou
    
    [self.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^(NSArray * _Nullable entries, NSArray * _Nullable sections) {
        self.entries = entries;
        self.sections = sections;
        
        [self.collectionView reloadData];
        
        if (shouldTakeScreenshot)
        {
            // Refresh blurry background after collectionview reloaded
            [self performSelector:@selector(blurrContentViewBackground) withObject:nil afterDelay:0.1];
        }
    }];
}



#pragma mark - Filter icons

- (void)blurrContentViewBackground
{
    // Do your stuff here. This will method will get called once your collection view get loaded.
   UIImage *image = [BSVisualEffects blurredViewImageFromView:self.view];

    UIViewController *presentedController = self.presentedViewController;
    UIView *contentView = [presentedController.view viewWithTag:100];
    
    UIImageView *imageView = (UIImageView *)[contentView viewWithTag:400];
    imageView.image = image;

    UIView *blurrContainer = [contentView viewWithTag:777];
    CGRect  rect = blurrContainer.bounds;
    rect.origin.x += 0;
    rect.origin.y += 0;
    blurrContainer.bounds = rect;
}



#pragma mark - BSAbstractExpensesSummaryUserInterfaceProtocol

- (void)displayImageForCategory:(UIImage *)image
{
    UIBarButtonItem *filterButton = self.navigationItem.rightBarButtonItems[1];
    [filterButton setImage:image];
}

@end

