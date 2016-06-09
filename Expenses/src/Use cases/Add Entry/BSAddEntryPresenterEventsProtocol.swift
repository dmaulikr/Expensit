//
//  BSAddEntryPresenterEventsProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 04/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc protocol BSAddEntryPresenterEventsProtocol {
    
    func saveEntry(entry : Entry, successBlock :()->(), failureBlock:(error : NSError) -> () )
    func userCancelledEditionOfExistingEntry()
    func userCancelledCreationOfNewEntry(entry : Entry)
    func userSelectedNext() // Submit + new one
    func userInterfaceReadyToDiplayEntry()
    
}