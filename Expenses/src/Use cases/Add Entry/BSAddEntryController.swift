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
        let delegate = UIApplication.shared.delegate as! BSAppDelegate
        self.coreDataStackHelper = delegate.coreDataHelper;
        self.coreDataController = BSCoreDataController(entityName : "Entry", delegate:nil, coreDataHelper:self.coreDataStackHelper)
        
        super.init()
    }

    /// BSAddEntryControllerProtocol
    
    func save(entry : Entry, successBlock :()->(), failureBlock:(error : NSError) -> () )
    {
        do
        {
            try self.coreDataController.save(entry)
            successBlock()
        }
        catch is Error
        {
            failureBlock(error: NSError(domain: "Could not save", code: 1, userInfo: nil))
        }
        
    }
    
    func discardChanges() {
        self.coreDataController.discardChanges()
    }
    
    func delete(entry : Entry) {
        self.coreDataController.deleteModel(entry)
    }
    
    func saveChanges() {
        self.coreDataController.saveChanges()
    }
    
    func newEntry() -> Entry {
        return self.coreDataController.newEntry()
    }

}
