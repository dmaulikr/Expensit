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

@implementation BSEntryDetailsFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    NSError *error = nil;
    if ([self saveModel:&error])
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self displayUnableToSaveErrorwithMessage:[error userInfo][NSLocalizedDescriptionKey]];
    }
}

- (IBAction) cancelButtonPressed:(id)sender
{
    if (self.isEditingEntry)
    {
        [self.coreDataController discardChanges];
    }
    else
    {
        [self.coreDataController deleteModel:self.entryModel];
        [self.coreDataController saveChanges];
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) saveModel:(NSError **)error
{
    return [self.coreDataController saveEntry:self.entryModel error:error];
}


#pragma mark - UITextFieldDelegate

/* TODO: Convert this method into a cell event*/
- (void) textFieldShouldreturn
{
    
    NSError *error = nil;
    if ([self saveModel:&error])
    {
        if (!self.isEditingEntry)
        {
            self.entryModel = [self.coreDataController newEntry];
            [self.tableView reloadData];
        }
    }
    else
    {
        [self displayUnableToSaveErrorwithMessage:[error userInfo][NSLocalizedDescriptionKey]];
    }
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

@end
