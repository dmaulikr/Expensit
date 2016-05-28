//
//  BSBaseExpenseCell.h
//  Expenses
//
//  Created by Borja Arias Drake on 29/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSBaseExpenseCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) NSDecimalNumber *amount;
@property (assign, nonatomic) BOOL isPositive;

- (void) configure;

@end
