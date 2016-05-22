//
//  ShowMonthlyEntriesPresenterProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 18/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc protocol BSAbstractExpensesSummaryPresenterEventsProtocol
{
    func filterChangedToCategory(category : Tag)
    func viewIsReadyToDisplayEntriesCompletionBlock(_: (entries : [AnyObject]?, sections : [AnyObject]?)->())    
    func viewIsReadyToDisplayImageForCategory(category : Tag?)
    func filterButtonTapped()
    func addNewEntryButtonTapped()
    func tagInfo() -> NSDictionary
    func sectionNameKeyPath() -> String?
    
    func abscissaValues() -> [String]
    func dataForGraphFromSuplusResultsForSection(section: String) -> [AnyObject]
    func dataForGraphFromExpensesResultsForSection(section: String) -> [AnyObject]
}