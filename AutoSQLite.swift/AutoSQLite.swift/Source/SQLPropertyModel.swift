//
//  SQLPropertyModel.swift
//  AutoSQLite.swift
//
//  Created by QJ Technology on 2017/5/15.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

import Foundation



/// 保存属性的model
class SQLPropertyModel: NSObject {
    
    var key     : String
    
    var value   : AnyObject
    
    //类型
    var type    : Any.Type
    
    init(type:Any.Type, key:String, value:AnyObject) {
        self.type = type
        self.key = key
        self.value = value
    }
    
}
