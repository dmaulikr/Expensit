//
//  BSShowAllEntriesController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation



class BSShowAllEntriesController: BSAbstractShowEntriesController {
    
    override func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return self.coreDataController.fetchRequestForIndividualEntriesSummary()
    }

    override func sectionNameKeyPath() -> String? {
        return "yearMonthDay"
    }    

}
