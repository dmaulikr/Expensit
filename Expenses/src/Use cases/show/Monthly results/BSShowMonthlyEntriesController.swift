//
//  BSShowMonthlyEntriesController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


class BSShowMonthlyEntriesController: BSAbstractShowEntriesController, BSShowMonthlyEntriesControllerProtocol {
    
    override func fetchRequest() -> NSFetchRequest {
        return self.coreDataController.fetchRequestForMonthlySummary()
    }

    override func sectionNameKeyPath() -> String? {
        return "year"
    }
            
}