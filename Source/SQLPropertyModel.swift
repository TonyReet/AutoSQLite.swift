//
//  SQLPropertyModel.swift
//  AutoSQLite.swift
//
//  Created by QJ Technology on 2017/5/15.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

import Foundation
import SQLite


/// 保存属性的model
open class SQLPropertyModel: NSObject {
    
    public var key     : String
    
    public var value   : AnyObject?
    
    //类型
    public var type    : Any.Type
    
    //是否是主键
    public var isPrimaryKey = false

    public init(type:Any.Type, key:String, value:AnyObject,isPrimaryKey:Bool) {
        self.type = type
        self.key = key
        self.value = value
        self.isPrimaryKey = isPrimaryKey
    }
}
