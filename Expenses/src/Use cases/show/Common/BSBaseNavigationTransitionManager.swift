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
    var categoryFilterTransitioningDelegate :BSModalSelectorViewTransitioningDelegate
    
    init(coreDataStackHelper : CoreDataStackHelper, coreDataController : BSCoreDataController)
    {
        self.coreDataStackHelper = coreDataStackHelper
        self.coreDataController = coreDataController
        self.categoryFilterTransitioningDelegate = BSModalSelectorViewTransitioningDelegate()
        
        super.init()
    }
    
    func configureAddEntryViewControllerWithSegue(segue : UIStoryboardSegue)
    {
        let navigationController = segue.destinationViewController as! UINavigationController
        let cellActionsDataSource = BSStaticTableAddEntryFormCellActionDataSource(coreDataController: self.coreDataController, isEditing:true);
        let addEntryVC = navigationController.topViewController as! BSEntryDetailsFormViewController
        let appDelegate = UIApplication.sharedApplication().delegate as! BSAppDelegate

        addEntryVC.addEntryController = BSAddEntryController()
        addEntryVC.addEntryPresenter = BSAddEntryPresenter(addEntryController: addEntryVC.addEntryController!, userInterface:addEntryVC)
        addEntryVC.isEditingEntry = false;
        addEntryVC.cellActionDataSource = cellActionsDataSource;
        addEntryVC.appearanceDelegate = appDelegate.themeManager;
    }
    
    
    // TODO: Creating the instance of categoryFilterViewTransitioningDelegate in this method does not ork, there is a crash
    func configureCategoryFilterViewControllerWithSegue(segue : UIStoryboardSegue, categoryFilterViewControllerDelegate: BSCategoryFilterDelegate, tagBeingFilterBy: AnyObject, categoryFilterViewTransitioningDelegate: BSModalSelectorViewTransitioningDelegate)
    {
        
        let categoryFilterViewController = segue.destinationViewController as! BSCategoryFilterViewController
        let categoryFilterController = BSCategoryFilterController()
        categoryFilterViewController.categoryFilterPresenter = BSCategoryFilterPresenter(categoryFilterController: categoryFilterController)
        categoryFilterViewController.transitioningDelegate = categoryFilterViewTransitioningDelegate
        categoryFilterViewController.modalPresentationStyle = .Custom
        categoryFilterViewController.delegate = categoryFilterViewControllerDelegate
        categoryFilterViewController.selectedTag = tagBeingFilterBy
    }
}