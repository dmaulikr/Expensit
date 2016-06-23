//
//  BSAddEntryControllerProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 04/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc protocol BSAddEntryControllerProtocol {
 
    func save(entry : Entry, successBlock :()->(), failureBlock:(error : NSError) -> () )
    func discardChanges()
    func delete(entry : Entry)
    func saveChanges()
    func newEntry() -> Entry

}
