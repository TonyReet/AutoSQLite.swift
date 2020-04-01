//
//  SQLMirrorModel.swift
//  AutoSQLite.swift
//
//  Created by QJ Technology on 2017/5/11.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

import Foundation
 


/// 反射保存属性的model
open class SQLMirrorModel: NSObject {
    
    public var sqlProperties : [SQLPropertyModel] = []
    
    //主键
    public var sqlPrimaryKey : String
    
    
    public init(primaryKey:String, properties:[SQLPropertyModel]) {
        sqlPrimaryKey = primaryKey
        sqlProperties = properties

    }
    
    
    /// 通过反射转换成对应的数据，以后不使用闭包了，很不方便
    ///
    /// - Parameters:
    ///   - object: 传入的objc
    ///   - mirrorFinish: 反射结束后的闭包
    public class func operateByMirror(object: SQLiteModel)->SQLMirrorModel?{
        let mirror = Mirror(reflecting: object)
        
        guard let displayStyle = mirror.displayStyle else {
            return nil
        }
        
        guard mirror.children.count > 0 else {
            return nil
        }
        
        var sqlProperties = [SQLPropertyModel]()
        
        for child in mirror.children{
            let value = child.value
            let vMirror = Mirror(reflecting: value)  // 通过值来创建属性的反射
            
            if let key = child.label { //注意字典只能保存AnyObject类型。
                
                var isPrimaryKey = false
                if object.primaryKey() == key {
                    isPrimaryKey = true
                }

                let mirrorModel = SQLPropertyModel(type: vMirror.subjectType,key:key,value:value as AnyObject, isPrimaryKey: isPrimaryKey)

                guard let ignoreKeys = object.ignoreKeys(),ignoreKeys.contains(key) == false else {
                    continue
                }
                
                sqlProperties.append(mirrorModel)
            }
        }
        
        guard let primaryKey = object.primaryKey() else {
            sqlitePrint("没有设置主键")
            return nil
        }
        
        switch displayStyle {
        case .class,.struct:
            return SQLMirrorModel(primaryKey:primaryKey,properties:sqlProperties)
        default:
            sqlitePrint("operateByMirror:不支持的类型")
            return nil
        }
    }
}
