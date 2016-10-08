//
//  BSAddEntryPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 04/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

class BSAddEntryPresenter: NSObject, BSAddEntryPresenterEventsProtocol {
 
    var addEntryController : BSAddEntryControllerProtocol
    var userInterface : BSAddEntryInterfaceProtocol
    var indexPathOfEntryToEdit : NSIndexPath?

    init(addEntryController: BSAddEntryControllerProtocol, userInterface : BSAddEntryInterfaceProtocol, indexPathOfEntryToEdit: NSIndexPath) {
        self.addEntryController = addEntryController
        self.userInterface = userInterface
        self.indexPathOfEntryToEdit = indexPathOfEntryToEdit
    }

    init(addEntryController: BSAddEntryControllerProtocol, userInterface : BSAddEntryInterfaceProtocol) {
        self.addEntryController = addEntryController
        self.userInterface = userInterface        
    }
    
    func save(entry : Entry, successBlock :()->(), failureBlock:(_ error : NSError) -> () ) {
        self.addEntryController.save(entry: entry, successBlock: {
            successBlock()
            }) { (error) in
                failureBlock(error)
        }
    }
    
    func userCancelledEditionOfExistingEntry() {
        self.addEntryController.discardChanges()
    }
    
    func userCancelledCreationOfNewEntry(_ entry : Entry) {
        self.addEntryController.delete(entry: entry)
        self.addEntryController.saveChanges()
    }
    
    func userSelectedNext() {
        let entry = self.addEntryController.newEntry()
        self.userInterface.display(entry: entry)
    }
    
    func userInterfaceReadyToDiplayEntry()
    {
        if let indexPath = self.indexPathOfEntryToEdit
        {
            // Editing
            let entry = self.addEntryController.entryAtIndexPath(indexPath)
            //tranform entry into diplay entry
            //self.userInterface.display(entry: diplayentry)
        }
        else
        {
            // Creating
            self.userInterface.display(entry: self.addEntryController.newEntry())
        }
    }
}
