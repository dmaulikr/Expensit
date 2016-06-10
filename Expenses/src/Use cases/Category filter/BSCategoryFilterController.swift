//
//  BSCategoryFilterController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 09/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

class BSCategoryFilterController: BSAbstractShowEntriesController, BSCategoryFilterControllerProtocol {
        
    func allTags() -> [Tag] {
        return self.coreDataController.allTags() as! [Tag]
    }

    func allTagsImages() -> [UIImage] {
        return self.coreDataController.allTagImages() as! [UIImage]
    }

}