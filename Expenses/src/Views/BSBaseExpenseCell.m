//
//  BSBaseExpenseCell.m
//  Expenses
//
//  Created by Borja Arias Drake on 29/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSBaseExpenseCell.h"
#import "BSAppDelegate.h"

@implementation BSBaseExpenseCell


- (void) setAmount:(NSDecimalNumber *)newAmount
{
    if (_amount != newAmount) {
        // Assign
        _amount = newAmount;
        
        // Configure
        NSComparisonResult result = [_amount compare:@0];
        switch (result) {
            case NSOrderedAscending:
                self.amountLabel.textColor = [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme redColor];
                break;
            case NSOrderedDescending:
                self.amountLabel.textColor = [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme greenColor];
                break;
            default:
                self.amountLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
                break;
        }
    }
}

- (void) setIsPositive:(BOOL)isPositive
{
    // Assign
    _isPositive = isPositive;
    
    // Configure
    
    if (_isPositive) {
        self.amountLabel.textColor = [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme greenColor];
        if (self.amountLabel.text.length != 0 ) {
          self.amountLabel.backgroundColor = [[((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme greenColor] colorWithAlphaComponent:0.1];
        }
    } else {
        self.amountLabel.textColor = [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme redColor];
        if (self.amountLabel.text.length != 0 ) {
          self.amountLabel.backgroundColor = [[((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme redColor] colorWithAlphaComponent:0.1];
        }
    }
}



- (void) configure
{
    //self.amountLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
    self.amountLabel.layer.cornerRadius = 5.0;
    self.amountLabel.adjustsFontSizeToFitWidth = YES;
    if (![self selectedBackgroundView])
    {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme selectedCellColor];
    }

}

@end
