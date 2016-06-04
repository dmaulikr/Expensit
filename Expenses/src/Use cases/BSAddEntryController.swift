//
//  BSAddEntryController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 04/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

class BSAddEntryController: NSObject, BSAddEntryControllerProtocol {
    
    var coreDataStackHelper : CoreDataStackHelper
    var coreDataController : BSCoreDataController

    
    override init()
    {
        let delegate = UIApplication.sharedApplication().delegate as! BSAppDelegate
        self.coreDataStackHelper = delegate.coreDataHelper;
        self.coreDataController = BSCoreDataController(entityName : "Entry", delegate:nil, coreDataHelper:self.coreDataStackHelper)
        
        super.init()
    }

    /// BSAddEntryControllerProtocol
    
    func saveEntry(entry : Entry, successBlock :()->(), failureBlock:(error : NSError) -> () )
    {
        do
        {
            try self.coreDataController.saveEntry(entry)
            successBlock()
        }
        catch is ErrorType
        {
            failureBlock(error: NSError(domain: "Could not save", code: 1, userInfo: nil))
        }
        
    }
    
    func discardChanges() {
        self.coreDataController.discardChanges()
    }
    
    func deleteEntry(entry : Entry) {
        self.coreDataController.deleteModel(entry)
    }
    
    func saveChanges() {
        self.coreDataController.saveChanges()
    }
    
    func newEntry() -> Entry {
        return self.coreDataController.newEntry()
    }

}