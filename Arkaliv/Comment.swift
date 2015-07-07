//
//  Comment.swift
//  Arkaliv
//
//  Created by Jack Cable on 7/6/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class Comment: NSObject {
    
    var properties = Dictionary<String, String>()
    
    init (newProperties: Dictionary<String, String>) {
        super.init()
        properties = newProperties
    }

}
