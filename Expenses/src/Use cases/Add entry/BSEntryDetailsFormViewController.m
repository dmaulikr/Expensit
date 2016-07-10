//
//  BSEntryDetailsFormViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 20/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSEntryDetailsFormViewController.h"
#import "BSCoreDataController.h"
#import <QuartzCore/QuartzCore.h>
#import "BSAppDelegate.h"
#import "BSThemeManager.h"
#import "Expensit-Swift.h"

@implementation BSEntryDetailsFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Ready to populate view
    [self.addEntryPresenter userInterfaceReadyToDiplayEntry];

    // Nav Bar buttons
    BSThemeManager *manager =  ((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager;
    UIImage *imageGreen = [manager.theme stretchableImageForNavBarDecisionButtonsWithStrokeColor:[manager.theme tintColor] fillColor:nil];
    UIImage *imageRed = [manager.theme stretchableImageForNavBarDecisionButtonsWithStrokeColor:[manager.theme redColor] fillColor:nil];
    
    UIBarButtonItem *doneButton = self.navigationItem.rightBarButtonItem;
    [doneButton setBackgroundImage:imageGreen forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *cancelButton = self.navigationItem.leftBarButtonItem;
    [cancelButton setBackgroundImage:imageRed forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [cancelButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [manager.theme redColor],  NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
}

- (IBAction) addEntryPressed:(id)sender
{
    [self.addEntryPresenter saveEntry:self.entryModel successBlock:^{
       [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } failureBlock:^(NSError * _Nonnull error) {
        [self displayUnableToSaveErrorwithMessage:[error userInfo][NSLocalizedDescriptionKey]];
    }];
}

- (IBAction) cancelButtonPressed:(id)sender
{
    if (self.isEditingEntry)
    {
        [self.addEntryPresenter userCancelledEditionOfExistingEntry];
    }
    else
    {
        [self.addEntryPresenter userCancelledCreationOfNewEntry:self.entryModel];
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UITextFieldDelegate

/* TODO: Convert this method into a cell event*/
- (void) textFieldShouldreturn
{ 
    [self.addEntryPresenter saveEntry:self.entryModel successBlock:^{
        if (!self.isEditingEntry)
        {
            [self.addEntryPresenter userSelectedNext]; //calls back displayEntry:
        }

    } failureBlock:^(NSError * _Nonnull error) {
        [self displayUnableToSaveErrorwithMessage:[error userInfo][NSLocalizedDescriptionKey]];
    }];
}

- (void)displayUnableToSaveErrorwithMessage:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Couldn't save", nil)
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
        
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:dismiss];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)displayEntry:(Entry * _Nonnull)entry {
    self.entryModel = entry;
    [self.tableView reloadData];
}

@end
