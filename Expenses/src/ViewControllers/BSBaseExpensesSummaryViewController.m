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
    
    // Set up Core Data helpers
    BSAppDelegate *delegate = (BSAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.coreDataStackHelper = delegate.coreDataHelper;
    self.coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:self.coreDataStackHelper]; // CoreData controller (should be a singleton)
    
    // Prepare for Landscape
    self.isShowingLandscapeView = NO;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

    

    
    // NavBar buttons
    UIBarButtonItem *filterButton = [self buttonForCategory:nil];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
    self.navigationItem.rightBarButtonItems = @[addButton, filterButton];
    
    // Category filter view controller transitioning delegate
    self.categoryFilterViewTransitioningDelegate = [[BSModalSelectorViewTransitioningDelegate alloc] init];
    self.animatedBlurEffectTransitioningDelegate = [[BSAnimatedBlurEffectTransitioningDelegate alloc] init];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Perform Fetch
    [self.fetchedResultsController performFetch:nil];
    [self.collectionView reloadData];
    
    // Apply filter before calculating section to go to
    [self filterChangedToCategory:tagBeingFilterBy takingScreenshot:NO]; // No need for taking a screenshot

    // Scroll to selected section
    [self scrollToSelectedSection];
}

- (void)scrollToSelectedSection
{
    if (self.shouldScrollToSelectedSection && self.firstTimeViewWillAppear)
    {
        self.firstTimeViewWillAppear = NO;
        NSArray *sectionNames = [self.fetchedResultsController.fetchedObjects valueForKeyPath:[self sectionNameKeyPath]];
        NSMutableArray* uniqueSectionNames = [[NSMutableArray alloc] init];
        for(id sectionName in sectionNames)
        {
            if(![uniqueSectionNames containsObject:sectionName])
            {
                [uniqueSectionNames addObject:sectionName];
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
    categoryFilterViewController.categories = [self.coreDataController allTags];
    categoryFilterViewController.categoryImages = [self.coreDataController allTagImages];
    
    [self presentViewController:categoryFilterViewController animated:YES completion:nil];
}


- (void)addButtonTapped
{
    [self addButtonTappedWithPresentationCompletedBlock:nil];
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
            [self performSegueWithIdentifier:@"DisplayGraphView" sender:[[self navigationController] topViewController]];
            self.isShowingLandscapeView = YES;
        }
        else if (UIDeviceOrientationIsPortrait(deviceOrientation) && self.isShowingLandscapeView && [self.presentedViewController isKindOfClass:[BSGraphViewController class]])
        {
            [self dismissViewControllerAnimated:NO completion:nil];
            self.isShowingLandscapeView = NO;
        }
    }
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
    if ([[self.fetchedResultsController sections] count])
    {
        sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:[sectionWithMostVisibleCells intValue]];
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



#pragma mark - Core Data

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // Create the request
    NSFetchRequest *fetchRequest = [self fetchRequest];
    
    // FetchedResultsController
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.coreDataStackHelper.managedObjectContext
                                                                      sectionNameKeyPath:self.sectionNameKeyPath
                                                                               cacheName:nil];

    // Execute the request
	NSError *error = nil;
	if (![_fetchedResultsController performFetch:&error])
    {
	    NSLog(@"Unresolved error fetching results. %@, %@", error, [error userInfo]);
	    abort();
	}
    else
    {
        
    }
    
    return _fetchedResultsController;
}


- (NSFetchRequest*) fetchRequest
{
    @throw [NSException exceptionWithName:@"Implement in subclasses" reason:@"This methods should be implemented by the subclasses" userInfo:nil];
    return nil;
}


- (NSFetchRequest *)graphFetchRequest
{
    @throw [NSException exceptionWithName:@"Implement in subclasses" reason:@"This methods should be implemented by the subclasses" userInfo:nil];
    return nil;
}


- (NSString*) sectionNameKeyPath
{
    @throw [NSException exceptionWithName:@"Implement in subclasses" reason:@"This methods should be implemented by the subclasses" userInfo:nil];
    return nil;
}


- (NSArray *)graphSurplusResults
{
    @throw [NSException exceptionWithName:@"Implement in subclasses" reason:@"This methods should be implemented by the subclasses" userInfo:nil];
}


- (NSArray *)graphExpensesResults
{
    @throw [NSException exceptionWithName:@"Implement in subclasses" reason:@"This methods should be implemented by the subclasses" userInfo:nil];
}


- (NSArray *)dataForGraphWithFetchRequestResults:(NSArray*) results
{
    @throw [NSException exceptionWithName:@"Implement in subclasses" reason:@"This methods should be implemented by the subclasses" userInfo:nil];

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
    
    // Change button
    UIBarButtonItem *filterButton = [self buttonForCategory:tag];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
    self.navigationItem.rightBarButtonItems = @[addButton, filterButton];
    
    // Update the request so filter by category
    NSFetchRequest *request = self.fetchedResultsController.fetchRequest;
    [self.coreDataController modifyfetchRequest:request toFilterByCategory:tag];
    
    // Re-fetch the results of the query
    [self.fetchedResultsController performFetch:nil];
    [self.collectionView reloadData];
    
    if (shouldTakeScreenshot)
    {
        // Refresh blurry background after collectionview reloaded
        [self performSelector:@selector(blurrContentViewBackground) withObject:nil afterDelay:0.1];
    }
   
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


- (UIBarButtonItem *)buttonForCategory:(Tag *)tag {

    UIImage *iconImage = [self.coreDataController imageForCategory:tag];
    UIButton *carIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [carIcon setImage:iconImage forState:UIControlStateNormal];
    
    [carIcon addTarget:self
                action:@selector(filterButtonTapped)
      forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithCustomView:carIcon];

    return filterButton;
}

@end

