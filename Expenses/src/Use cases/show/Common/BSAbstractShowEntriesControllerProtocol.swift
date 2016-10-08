//
//  ShowMonthlyEntriesControllerProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 18/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc protocol BSAbstractShowEntriesControllerProtocol : BSCoreDataControllerProtocol {
    
    func filter(by category : Tag) // Just changes internal configuration to filter next time entries for summary gets called
    func entriesForSummary() -> NSDictionary
    func image(for category :Tag?) -> UIImage?
    func sectionNameKeyPath() -> String?
    var _fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {get}
}
