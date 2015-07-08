//
//  ArkalivHelper.swift
//  Arkaliv
//
//  Created by Jack Cable on 7/8/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class ArkalivHelper: NSObject {
    
    let barColor = UIColor(red: 0.357, green: 0.443, blue: 0.686, alpha: 1)
    
    func initializeViewController(viewController: UIViewController) {
        
        if let navigationController = viewController.navigationController {
            navigationController.navigationBar.barTintColor = barColor
            navigationController.toolbar.barTintColor = barColor
            navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
            navigationController.navigationBar.tintColor = UIColor.whiteColor()
        }
    }

}
