//
//  ShowMonthlyEntriesControllerProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 18/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc protocol BSAbstractShowEntriesControllerProtocol {
    
    func filterByCategory(category : Tag) // Just changes internal configuration to filter next time entries for summary gets called
    func entriesForSummary() -> NSDictionary
    func imageForCategoy(category :Tag?) -> UIImage?
    func allTags() -> [Tag]
    func allTagsImages() -> [UIImage]
    
    
    // remove
    func sectionNameKeyPath() -> String?
    func abscissaValues() -> [NSDictionary]
    func graphSurplusResultsForSection(section: String) -> [AnyObject]
    func graphExpensesResultsForSection(section: String) -> [AnyObject]

}