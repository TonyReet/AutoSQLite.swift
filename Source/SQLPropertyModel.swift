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

    private let express:Expressible
    
    
    public init(type:Any.Type, key:String, value:AnyObject,isPrimaryKey:Bool) {
        self.type = type
        self.key = key
        self.value = value
        self.isPrimaryKey = isPrimaryKey

        if type is Int?.Type {
            self.express = Expression<Int?>(key)
        }else if type is Float?.Type {
            self.express = Expression<Double?>(key)
        }else if type is Double?.Type {
            self.express = Expression<Double?>(key)
        }else if type is Bool?.Type {
            self.express = Expression<Bool?>(key)
        }else if type is String?.Type {
            self.express = Expression<String?>(key)
        }else if type is Int.Type {
            self.express = Expression<Int>(key)
        }else if type is Float.Type {
            self.express = Expression<Double>(key)
        }else if type is Double.Type {
            self.express = Expression<Double>(key)
        }else if type is Bool.Type {
            self.express = Expression<Bool>(key)
        }else if type is String.Type {
            self.express = Expression<String>(key)
        }else {
            self.express = Expression<AnyObject>(key)
            assert(true, "SQLPropertyModel Init:不支持的类型")
        }
    }
    
    
    public func sqlSetter(_ object:SQLiteModel) -> SQLite.Setter {
        
        //let value:Any? = object.value(forKey: key)
        let mirror = Mirror(reflecting: object)
        
        guard let displayStyle = mirror.displayStyle else {
            return express as! Setter
        }
        
        guard mirror.children.count > 0 else {
            return express as! Setter
        }
        
        var value:Any?
        for child in mirror.children{
            if key == child.label { //注意字典只能保存AnyObject类型。
                value = child.value
            }
        }
        
        
        if type is Int?.Type {
            return express as! Expression<Int?> <- value as? Int
        }
        else if type is Float?.Type {
            return express as! Expression<Double?> <- Double((value as? Float)!)
        }
        else if type is Double?.Type {
            return express as! Expression<Double?> <- value as? Double
        }else if type is Bool?.Type {
            return express as! Expression<Bool?> <- value as? Bool
        }else if type is String?.Type {
            return express as! Expression<String?> <- (value as? String)!
        }else if type is Int.Type {
            return express as! Expression<Int> <- value as! Int
        }else if type is Float.Type {
            return express as! Expression<Double> <- Double(value as! Float)
        }else if  type is Double.Type {
            return express as! Expression<Double> <- value as! Double
        }else if type is Bool.Type {
            return express as! Expression<Bool> <- value as! Bool
        }else if type is String.Type {
            return express as! Expression<String> <- value as! String
        }else {
            assert(true, "SQLPropertyModel sqlSetter:不支持的类型")
            return express as! Setter
        }
    }

    public func sqlRowToModel(_ object:SQLiteModel,row:Row) {
        
        /// 确定值使用KVC处理
        if object.responds(to: Selector(key)) {
            if type is Int.Type {
                object.setValue(row[express as! Expression<Int>], forKey: key)
            }else if type is Float.Type {
                object.setValue(row[express as! Expression<Double>], forKey: key)
            }else if type is Double.Type {
                object.setValue(row[express as! Expression<Double>], forKey: key)
            }else if type is Bool.Type {
                object.setValue(row[express as! Expression<Bool>], forKey: key)
            }else if type is String.Type {
                object.setValue(row[express as! Expression<String>], forKey: key)
            }else {
                assert(true, "SQLPropertyModel sqlRowToModel:不支持的类型")
            }
        }else{// 可选值使用runtime获取内存地址，修改内存地址对应的值
            guard let ivar: Ivar = class_getInstanceVariable(object.classForCoder, key) else{
                return
            }
            let fieldOffset = ivar_getOffset(ivar)
            
            let pointerToInstance = Unmanaged.passUnretained(object).toOpaque()
            
            if type is Int?.Type {
                let pointerToField = unsafeBitCast(pointerToInstance + fieldOffset, to: UnsafeMutablePointer<Int?>.self)

                pointerToField.pointee = value as? Int
            }else if type is Float?.Type {
                let pointerToField = unsafeBitCast(pointerToInstance + fieldOffset, to: UnsafeMutablePointer<Float?>.self)

                pointerToField.pointee = value as? Float
            }else if type is Double?.Type {
                let pointerToField = unsafeBitCast(pointerToInstance + fieldOffset, to: UnsafeMutablePointer<Double?>.self)

                pointerToField.pointee = value as? Double
            }else if type is Bool?.Type {
                let pointerToField = unsafeBitCast(pointerToInstance + fieldOffset, to: UnsafeMutablePointer<Bool?>.self)

                pointerToField.pointee = value as? Bool
            }else if type is String?.Type {
                let pointerToField = unsafeBitCast(pointerToInstance + fieldOffset, to: UnsafeMutablePointer<String?>.self)

                pointerToField.pointee = value as? String
            }
        }
    }
    

    public func sqlFilter(_ object:SQLiteModel) -> Expression<Bool> {
        
        //let value:Any? = object.value(forKey: key)
        let mirror = Mirror(reflecting: object)
        
        guard let displayStyle = mirror.displayStyle else {
            return express as! Expression<Bool>
        }
        
        guard mirror.children.count > 0 else {
            return express as! Expression<Bool>
        }
        
        var value:Any?
        for child in mirror.children{
            if key == child.label { //注意字典只能保存AnyObject类型。
               value = child.value
            }
        }
        
        if type is Int?.Type {
            return (express as! Expression<Int> == (value as? Int)!)
        }else if type is Float?.Type {
            return (express as! Expression<Double> == Double((value as? Float)!))
        }else if type is Double?.Type {
            return (express as! Expression<Double> == (value as? Double)!)
        }else if type is Bool?.Type {
            return (express as! Expression<Bool> == (value as? Bool)!)
        }else if type is String?.Type {
            return (express as! Expression<String> == (value as? String)!)
        }else if type is Int.Type {
            return (express as! Expression<Int> == value as! Int)
        }else if type is Float.Type {
            return (express as! Expression<Double> == (Double(value as! Float)))
        }else if type is Double.Type {
            return (express as! Expression<Double> == (value as! Double))
        }else if type is Bool.Type {
            return (express as! Expression<Bool> == value as! Bool)
        }else if type is String.Type {
            return (express as! Expression<String> == value as! String)
        }else {
            assert(true, "SQLPropertyModel sqlFilter:不支持的类型")
            return express as! Expression<Bool>
        }
    }
    

    public func sqlBuildRow(builder:SQLite.TableBuilder,isPkid:Bool) {

        let isPkid = self.isPrimaryKey
        if type is Int?.Type {
            builder.column((express as! Expression<Int?>), defaultValue: 0)
        }else if type is Float?.Type {
            builder.column((express as! Expression<Double?>), defaultValue: 0)
        }else if type is Double?.Type {
            builder.column((express as! Expression<Double?>), defaultValue: 0)
        }else if type is Bool?.Type {
            builder.column((express as! Expression<Bool?>), defaultValue: false)
        }else if type is String?.Type {
            builder.column(express as! Expression<String?>, defaultValue: "")
        }else if type is Int.Type {
            if isPkid {
                builder.column(express as! Expression<Int>, primaryKey: true)
            } else {
                builder.column(express as! Expression<Int>, defaultValue: 0)
            }
        }else if type is Float.Type {
            if isPkid {
                builder.column(express as! Expression<Double>, primaryKey: true)
            } else {
                builder.column(express as! Expression<Double>, defaultValue: 0)
            }
        }else if type is Double.Type {
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
        }else if type is String.Type {
            if isPkid {
                builder.column(express as! Expression<String>, primaryKey: true)
            } else {
                builder.column(express as! Expression<String>, defaultValue: "")
            }
        }else{
            assert(true, "SQLPropertyModel sqlBuildRow:不支持的类型")
        }
    }
}
