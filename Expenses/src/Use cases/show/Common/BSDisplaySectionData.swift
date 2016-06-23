//
//  BSDisplaySectionData.swift
//  Expenses
//
//  Created by Borja Arias Drake on 27/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc enum BSNumberSignType : Int
{
    case zero = 0, positive, negative
}

class BSDisplaySectionData : NSObject
{
    let title : String?
    let entries : [BSDisplayEntry]
    var numberOfEntries : Int  { get { return entries.count } }
    
    init(title : String?, entries : [BSDisplayEntry])
    {
        self.title = title
        self.entries =  entries
        super.init()
    }
}

class BSDisplayEntry : NSObject
{
    let title : String?
    let value : String?
    let signOfAmount : BSNumberSignType
    
    init(title : String?, value : String?, signOfAmount : BSNumberSignType)
    {
        self.title = title
        self.value =  value
        self.signOfAmount =  signOfAmount
        super.init()
    }

}
