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

    init(addEntryController: BSAddEntryControllerProtocol, userInterface : BSAddEntryInterfaceProtocol) {
        self.addEntryController = addEntryController
        self.userInterface = userInterface
    }
    
    func saveEntry(entry : Entry, successBlock :()->(), failureBlock:(error : NSError) -> () ) {
        self.addEntryController.saveEntry(entry, successBlock: { 
            successBlock()
            }) { (error) in
                failureBlock(error: error)
        }
    }
    
    func userCancelledEditionOfExistingEntry() {
        self.addEntryController.discardChanges()
    }
    
    func userCancelledCreationOfNewEntry(entry : Entry) {
        self.addEntryController.deleteEntry(entry)
        self.addEntryController.saveChanges()
    }
    
    func userSelectedNext() {
        let entry = self.addEntryController.newEntry()
        self.userInterface.displayEntry(entry)
    }
    
    func userInterfaceReadyToDiplayEntry() {
        let entry = self.addEntryController.newEntry()
        self.userInterface.displayEntry(entry)
    }

}