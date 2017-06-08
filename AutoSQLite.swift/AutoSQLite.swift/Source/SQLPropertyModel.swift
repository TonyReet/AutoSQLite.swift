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
class SQLPropertyModel: NSObject {
    
    var key     : String
    
    var value   : AnyObject?
    
    //类型
    var type    : Any.Type
    
    //是否是主键
    var isPrimaryKey = false

    private let express:Expressible
    
    
    init(type:Any.Type, key:String, value:AnyObject,isPrimaryKey:Bool) {
        self.type = type
        self.key = key
        self.value = value
        self.isPrimaryKey = isPrimaryKey

        if type is Int?.Type {
            self.express = Expression<Int64?>(key)
        }else if type is Float?.Type, type is Double?.Type {
            self.express = Expression<Double?>(key)
        }else if type is Bool?.Type {
            self.express = Expression<Bool?>(key)
        }else if type is String?.Type {
            self.express = Expression<String>(key)
        }else if type is Int.Type {
            self.express = Expression<Int64>(key)
        }else if type is Float.Type, type is Double.Type {
            self.express = Expression<Double>(key)
        }else if type is Bool.Type {
            self.express = Expression<Bool>(key)
        }else {
            self.express =  Expression<String>(key)
        }
    }
    
    
    func sqlSetter(_ object:SQLiteModel) -> SQLite.Setter {
        
        let value:Any? = object.value(forKey: key)
        if type is Int?.Type {
            return express as! Expression<Int64?> <- value as? Int64
        }else if type is Float.Type, type is Double.Type {
            return express as! Expression<Double?> <- value as? Double
        }else if type is Bool?.Type {
            return express as! Expression<Bool?> <- value as? Bool
        }else if type is String?.Type {
            return express as! Expression<String> <- (value as? String)!
        }else if type is Int.Type {
            return express as! Expression<Int64> <- value as! Int64
        }else if type is Float.Type, type is Double.Type {
            return express as! Expression<Double> <- value as! Double
        }else if type is Bool.Type {
            return express as! Expression<Bool> <- value as! Bool
        }else {
            return express as! Expression<String> <- value as! String
        }
    }

    func sqlRowToModel(_ object:SQLiteModel,row:Row) {
        if type is Int?.Type {
            object.setValue(row[express as! Expression<Int64?>], forKey: key)
        }else if type is Float?.Type, type is Double?.Type {
            object.setValue(row[express as! Expression<Double?>], forKey: key)
        }else if type is Bool?.Type {
            object.setValue(row[express as! Expression<Bool?>], forKey: key)
        }else if type is String?.Type {
            object.setValue(row[express as! Expression<String>], forKey: key)
        }else if type is Int.Type {
            object.setValue(row[express as! Expression<Int64>], forKey: key)
        }else if type is Float.Type, type is Double.Type {
            object.setValue(row[express as! Expression<Double>], forKey: key)
        }else if type is Bool.Type {
            object.setValue(row[express as! Expression<Bool>], forKey: key)
        }else {
            object.setValue(row[express as! Expression<String>], forKey: key)
        }
    }
    

    func sqlFilter(_ object:SQLiteModel) -> Expression<Bool> {
        
        let value:Any? = object.value(forKey: key)
        if type is Int?.Type {
            return (express as! Expression<Int64> == (value as? Int64)!)
        }else if type is Float?.Type, type is Double.Type {
            return (express as! Expression<Double> == (value as? Double)!)
        }else if type is Bool?.Type {
            return (express as! Expression<Bool> == (value as? Bool)!)
        }else if type is String?.Type {
            return (express as! Expression<String> == (value as? String)!)
        }else if type is Int.Type {
            return (express as! Expression<Int64> == value as! Int64)
        }else if type is Float.Type, type is Double.Type {
            return (express as! Expression<Double> == value as! Double)
        }else if type is Bool.Type {
            return (express as! Expression<Bool> == value as! Bool)
        }else {
            return (express as! Expression<String> == value as! String)
        }
    }
    

    func sqlBuildRow(builder:SQLite.TableBuilder,isPkid:Bool) {

        let isPkid = self.isPrimaryKey
        if type is Int?.Type {
            builder.column((express as? Expression<Int64>)!, defaultValue: 0)
        }else if type is Float?.Type, type is Double?.Type {
            builder.column((express as? Expression<Double>)!, defaultValue: 0)
        }else if type is Bool?.Type {
            builder.column((express as? Expression<Bool>)!, defaultValue: false)
        }else if type is String?.Type {
            builder.column(express as! Expression<String>, defaultValue: "")
        }else if type is Int.Type {
            if isPkid {
                builder.column(express as! Expression<Int64>, primaryKey: true)
            } else {
                builder.column(express as! Expression<Int64>, defaultValue: 0)
            }
        }else if type is Float.Type, type is Double.Type {
            if isPkid {
                builder.column(express as! Expression<Double>, primaryKey: true)
            } else {
                builder.column(express as! Expression<Double>, defaultValue: 0)
            }
        }else if type is Bool.Type {
            if isPkid {
                builder.column(express as! Expression<Bool>, primaryKey: true)
            } else {
                builder.column(express as! Expression<Bool>, defaultValue: false)
            }
        }else {
            if isPkid {
                builder.column(express as! Expression<String>, primaryKey: true)
            } else {
                builder.column(express as! Expression<String>, defaultValue: "")
            }
        }
    }
    
}
