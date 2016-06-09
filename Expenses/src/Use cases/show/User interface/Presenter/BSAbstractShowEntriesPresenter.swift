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
    
    func filterChangedToCategory(category : Tag) {
        self.showEntriesController.filterByCategory(category)
    }
    
    func viewIsReadyToDisplayEntriesCompletionBlock(block: ( sections : [BSDisplaySectionData] ) -> () )
    {
        let dictionary = self.showEntriesController.entriesForSummary()
        //let ent = dictionary["entries"] as! [AnyObject]?
        let sec = dictionary["sections"] as! [NSFetchedResultsSectionInfo]
        let output = self.displayDataFromEntriesForSummary(sec)
        // CallBack hen data i ready
        block( sections: output)
    }
    
    func viewIsReadyToDisplayImageForCategory(category : Tag?) {
        let image = self.showEntriesController.imageForCategoy(category)
        self.userInteface.displayImageForCategory(image!)
    }
    
    func filterButtonTapped() {
        
    }
    
    func addNewEntryButtonTapped() {
        
    }

    func tagInfo() -> NSDictionary {
        let tags = self.showEntriesController.allTags()
        let images = self.showEntriesController.allTagsImages()
        return NSDictionary(objects: [tags, images], forKeys: ["tags", "images"])
    }
    
    func displayDataFromEntriesForSummary(data : [NSFetchedResultsSectionInfo]) -> [BSDisplaySectionData]
    {
        return []
    }

    
}