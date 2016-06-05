//
//  BSEntryDetailsFormViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 20/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSStaticFormTableViewController.h"


@protocol BSAddEntryPresenterEventsProtocol;
@protocol BSAddEntryControllerProtocol;
@protocol BSAddEntryInterfaceProtocol;

//@class BSCoreDataController;

@interface BSEntryDetailsFormViewController : BSStaticFormTableViewController <UITextFieldDelegate, BSAddEntryInterfaceProtocol>

//@property (strong, nonatomic) BSCoreDataController *coreDataController;
@property (strong, nonatomic, nullable) id<BSAddEntryPresenterEventsProtocol> addEntryPresenter;
@property (strong, nonatomic, nullable) id<BSAddEntryControllerProtocol> addEntryController;

@end
