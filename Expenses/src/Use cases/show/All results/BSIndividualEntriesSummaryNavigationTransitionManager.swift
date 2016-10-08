//
//  BSIndividualEntriesSummaryNavigationTransitionManager.swift
//  Expenses
//
//  Created by Borja Arias Drake on 13/08/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation
import UIKit

class BSIndividualEntriesSummaryNavigationTransitionManager : BSBaseNavigationTransitionManager
{
    func configureEditEntryViewControllerWithSegue(_ segue : UIStoryboardSegue, selectedIndexPath indexPath: NSIndexPath, allEntriesPresenter: BSAbstractExpensesSummaryPresenterEventsProtocol)
    {
        
        let entry = allEntriesPresenter.showEntriesController._fetchedResultsController?.sections?[indexPath.section].objects?[indexPath.row] as! Entry
        
        
        
        let navigationController = segue.destination as! UINavigationController
        let cellActionsDataSource = BSStaticTableAddEntryFormCellActionDataSource(coreDataController: self.coreDataController, isEditing:true);
        let addEntryVC = navigationController.topViewController as! BSEntryDetailsFormViewController
        addEntryVC.isEditingEntry = true
        let appDelegate = UIApplication.shared.delegate as! BSAppDelegate
        
        addEntryVC.addEntryController = BSAddEntryController(entryToEdit : entry)
        addEntryVC.addEntryPresenter = BSAddEntryPresenter(addEntryController: addEntryVC.addEntryController!, userInterface: addEntryVC, indexPathOfEntryToEdit: indexPath)        
        addEntryVC.cellActionDataSource = cellActionsDataSource;
        addEntryVC.appearanceDelegate = appDelegate.themeManager;
    }
    
}
