//
//  BSShowYearlyEntriesController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

class BSShowYearlyEntriesController: BSAbstractShowEntriesController {
    
    override func fetchRequest() -> NSFetchRequest {
        return self.coreDataController.fetchRequestForYearlySummary()
    }

    override func sectionNameKeyPath() -> String? {
        return nil
    }

}