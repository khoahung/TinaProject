//
//  DataSingleton.swift
//  WakeUpOnLan
//
//  Created by Nguyễn Tất Hùng on 5/10/16.
//  Copyright © 2016 Nguyễn Tất Hùng. All rights reserved.
//

import UIKit

class DataSingleton: NSObject {
    static let sharedInstance = DataSingleton()
    
    fileprivate override init() {
        
        dataShare = [String:AnyObject]()
    }
    
    var dataShare:[String:AnyObject]!
}
