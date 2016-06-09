//
//  BSGraphViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 09/07/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSGraphViewController.h"
#import "BSCurrencyHelper.h"
#import "Expensit-Swift.h"

@interface BSGraphViewController ()

@end

@implementation BSGraphViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.graphTitle = [self.lineGraphPresenter graphTitle];
    self.moneyIn = [self.lineGraphPresenter income];
    self.moneyOut = [self.lineGraphPresenter expenses];
    self.xValues = [self.lineGraphPresenter abscissaValues];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}



#pragma mark - LineGraphCurrencyFormatterProtocol

- (NSString *) formattedStringForNumber:(NSNumber *)number
{
    return [[BSCurrencyHelper amountFormatter] stringFromNumber:number];
}


@end
