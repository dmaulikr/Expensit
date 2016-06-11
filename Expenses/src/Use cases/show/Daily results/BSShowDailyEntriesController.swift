//
//  BSShowDailyEntriesController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation



class BSShowDailyEntriesController: BSAbstractShowEntriesController, BSShowDailyEntriesControllerProtocol {
    
    override func fetchRequest() -> NSFetchRequest {
        return self.coreDataController.fetchRequestForDaylySummary()
    }

    override func sectionNameKeyPath() -> String? {
        return "monthYear"
    }

}