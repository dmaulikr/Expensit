//
//  BSCategoryFilterViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 22/03/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSCategoryFilterDelegate.h"

@protocol BSCategoryFilterPresenterEventsProtocol;


@interface BSCategoryFilterViewController : UIViewController

@property (strong, nonatomic, nullable) id<BSCategoryFilterPresenterEventsProtocol> categoryFilterPresenter;

@property (nonatomic, weak, nullable) id <BSCategoryFilterDelegate> delegate;

@property (nonatomic, weak, nullable) IBOutlet UIPickerView *pickerView;

@property (nonatomic, weak, nullable) IBOutlet UILabel *statusLabel;

@property (nonatomic, strong, nullable) id selectedTag;


@end
