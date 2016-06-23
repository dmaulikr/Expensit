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
    @objc(filterChangedToCategory:)
    func filterChanged(to category : Tag)
    
    func viewIsReadyToDisplayEntriesCompletionBlock(_: ( sections : [BSDisplaySectionData]) -> ())
    
    @objc(viewIsReadyToDisplayImageForCategory:)
    func viewIsReadyToDisplayImage(for category : Tag?)
    
    func filterButtonTapped()
    
    func addNewEntryButtonTapped()    
}
