//
//  BSDailyExpensesSummaryPresenterEventsProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 23/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


@objc protocol BSDailyExpensesSummaryPresenterEventsProtocol : BSAbstractExpensesSummaryPresenterEventsProtocol {    
    func arrayDayNumbersInMonthFromVisibleSection(_ section: String) -> [String]
    
    @objc(sectionNameForSelectedIndexPath:sectionTitle:)
    func sectionName(forSelected indexPath : IndexPath, sectionTitle: String) -> String
}
