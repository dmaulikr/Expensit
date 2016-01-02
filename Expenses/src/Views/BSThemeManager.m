//
//  BSThemeManager.m
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSThemeManager+Protected.h"
#import "BSThemeManager_iOS7.h"

#import "BSCells.h"

@implementation BSThemeManager

+ (BSThemeManager *) manager
{
    return [[BSThemeManager_iOS7 alloc] init]; // 7 And above
    
}


- (void)applyTheme
{
    [self applyThemeToNavigationBar];
}


- (void)themeTableViewCell:(UITableViewCell *)cell
{
    if ([cell isKindOfClass:[BSEntryTextDetail class]])
    {
        ((BSEntryTextDetail *)cell).positiveSignColor = [self.theme greenColor];
        ((BSEntryTextDetail *)cell).negativeSignColor = [self.theme redColor];
    }
    else if ([cell isKindOfClass:[BSStaticTableViewCell class]])
    {
        ((BSStaticTableViewCell *)cell).selectedTintColor = [self.theme selectedTintColor];
        ((BSStaticTableViewCell *)cell).tintColor = [self.theme blueColor];
    }

}

@end
