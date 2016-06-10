//
//  BSCategoryFilterPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 09/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


class BSCategoryFilterPresenter: NSObject, BSCategoryFilterPresenterEventsProtocol {
    
    var categoryFilterController : BSCategoryFilterControllerProtocol
    
    init!(categoryFilterController: BSCategoryFilterControllerProtocol) {
        self.categoryFilterController = categoryFilterController
        super.init()
    }

    func tagInfo() -> NSDictionary {
        let tags = self.categoryFilterController.allTags()
        let images = self.categoryFilterController.allTagsImages()
        return NSDictionary(objects: [tags, images], forKeys: ["tags", "images"])
    }

}