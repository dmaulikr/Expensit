//
//  BSShowAllEntriesPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

class BSShowAllEntriesPresenter : BSAbstractShowEntriesPresenter {
 
    override func displayDataFromEntriesForSummary(_ data : [NSFetchedResultsSectionInfo]) -> [BSDisplaySectionData]
    {
        var sections = [BSDisplaySectionData]()
        
        for coreDatasectionInfo in data
        {
            var entries = [BSDisplayEntry]()
            for i in 0 ..< coreDatasectionInfo.numberOfObjects {
                let coreDataEntry : Entry = coreDatasectionInfo.objects![i] as! Entry
                let entryData = BSDisplayEntry(title: coreDataEntry.desc , value: BSCurrencyHelper.amountFormatter().string(from: coreDataEntry.value), signOfAmount: .zero)
                entries.append(entryData)
            }
                        
            let sectionData = BSDisplaySectionData(title: coreDatasectionInfo.name, entries: entries)
            sections.append(sectionData)
        }
        
        return sections
    }
    
}
