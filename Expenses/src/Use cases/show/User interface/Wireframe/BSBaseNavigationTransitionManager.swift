//
//  BSBaseNavigationTransitionManager.swift
//  Expenses
//
//  Created by Borja Arias Drake on 04/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation
import UIKit

class BSBaseNavigationTransitionManager: NSObject
{
    var coreDataStackHelper : CoreDataStackHelper
    var coreDataController : BSCoreDataController
    
    init(coreDataStackHelper : CoreDataStackHelper, coreDataController : BSCoreDataController)
    {
        self.coreDataStackHelper = coreDataStackHelper
        self.coreDataController = coreDataController
        
        super.init()
    }
    
    func configureAddEntryViewControllerWithSegue(segue : UIStoryboardSegue)
    {
        let navigationController = segue.destinationViewController as! UINavigationController
        let cellActionsDataSource = BSStaticTableAddEntryFormCellActionDataSource(coreDataController: self.coreDataController, isEditing:true);
        let addEntryVC = navigationController.topViewController as! BSEntryDetailsFormViewController;
        let appDelegate = UIApplication.sharedApplication().delegate as! BSAppDelegate

        addEntryVC.addEntryController = BSAddEntryController()
        addEntryVC.addEntryPresenter = BSAddEntryPresenter(addEntryController: addEntryVC.addEntryController!, userInterface:addEntryVC)
        addEntryVC.isEditingEntry = false;
        addEntryVC.cellActionDataSource = cellActionsDataSource;
        addEntryVC.appearanceDelegate = appDelegate.themeManager;
    }
}