//
//  Header.h
//  Expenses
//
//  Created by Borja Arias Drake on 09/10/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//


@class Tag;

@protocol BSCategoryFilterDelegate <NSObject>

- (void)filterChangedToCategory:(Tag * _Nullable)category;

@end
