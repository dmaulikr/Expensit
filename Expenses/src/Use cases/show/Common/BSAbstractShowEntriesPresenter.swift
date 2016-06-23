//
//  ShowMonthlyEntriesPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 20/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

class BSAbstractShowEntriesPresenter : NSObject, BSAbstractExpensesSummaryPresenterEventsProtocol {
    
    var showEntriesController : BSAbstractShowEntriesControllerProtocol
    var userInteface : BSAbstractExpensesSummaryUserInterfaceProtocol
    
    init!(showEntriesUserInterface: BSAbstractExpensesSummaryUserInterfaceProtocol,
         showEntriesController : BSAbstractShowEntriesControllerProtocol) {
        self.userInteface = showEntriesUserInterface
        self.showEntriesController = showEntriesController
        super.init()
    }
    
    
    /// BSBaseExpensesSummaryPresenterEventsProtocol
    
    func filterChanged(to category : Tag) {
        self.showEntriesController.filter(by : category)
    }
    
    func viewIsReadyToDisplayEntriesCompletionBlock(_ block: ( sections : [BSDisplaySectionData] ) -> () )
    {
        let dictionary = self.showEntriesController.entriesForSummary()        
        let sec = dictionary["sections"] as! [NSFetchedResultsSectionInfo]
        let output = self.displayDataFromEntriesForSummary(sec)
        // CallBack hen data i ready
        block( sections: output)
    }
    
    func viewIsReadyToDisplayImage(for category : Tag?) {
        let image = self.showEntriesController.image(for: category)
        self.userInteface.displayImage( for : image!)
    }
    
    func filterButtonTapped() {
        
    }
    
    func addNewEntryButtonTapped() {
        
    }
    
    func displayDataFromEntriesForSummary(_ data : [NSFetchedResultsSectionInfo]) -> [BSDisplaySectionData]
    {
        return []
    }

    
}
