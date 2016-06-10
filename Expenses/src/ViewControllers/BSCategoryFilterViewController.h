//
//  BSCategoryFilterViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 22/03/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Tag;
@protocol BSCategoryFilterDelegate <NSObject>
/*!
 @discussion The argument is already a Tag* reference or nil
 */
- (void)filterChangedToCategory:(Tag *)tag;

@end

@protocol BSCategoryFilterPresenterEventsProtocol;

@interface BSCategoryFilterViewController : UIViewController

@property (strong, nonatomic, nullable) id<BSCategoryFilterPresenterEventsProtocol> categoryFilterPresenter;

@property (nonatomic, weak) id <BSCategoryFilterDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;

@property (nonatomic, strong) id selectedTag;


@end
