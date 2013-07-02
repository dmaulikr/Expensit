//
//  BSBaseExpenseCell.m
//  Expenses
//
//  Created by Borja Arias Drake on 29/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSBaseExpenseCell.h"

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
                self.amountLabel.textColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
                break;
            case NSOrderedDescending:
                self.amountLabel.textColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
                break;
            default:
                self.amountLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
                break;
        }
    }
}
@end
