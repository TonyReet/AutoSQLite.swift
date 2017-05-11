//
//  SQLiteDataBaseTool.swift
//  AutoSQLite.swift
//
//  Created by QJ Technology on 2017/5/11.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

import Foundation

class SQLiteDataBaseTool: NSObject{
    
    
    /// 将原生的类型转换成sql类型
    ///
    /// - Parameter type: 原生类型
    /// - Returns: sql类型
    class func sqlType(_ nativeType : Any.Type)->String {
        
        if nativeType is Int.Type {
            return "INTEGER"
        }else if nativeType is Float.Type, nativeType is Double.Type {
            return "DOUBLE"
        }else if nativeType is NSString.Type || nativeType is String.Type || nativeType is Character.Type {
            return "TEXT"
        }
        
        return ""
    }
    
    /// 移除字符串的最后一个字符
    ///
    /// - Parameter oldStr:未处理的字符串
    /// - Returns: 处理完的字符串
    class func removeLastStr(_ oldStr:String)->String{
        return oldStr.substring(to: oldStr.index(before: oldStr.endIndex))
    }
    
    
    /// 去掉空格
    ///
    /// - Parameter name: 处理完的字符串
    class func removeBlankSpace(_ name: String)->String{
        var databaseName = name
        
        //包含空格的情况，去掉空格
        let blankSpaceStr = " "
        if name.contains(blankSpaceStr){
            databaseName = databaseName.replacingOccurrences(of:blankSpaceStr, with:"")
        }
        
        return databaseName
    }
    
    /// 获取当前时间的str
    ///
    /// - Returns: 当前时间的str
    class func dateNowAsString() -> String {
        let nowDate = Date()
        let timeInterval = nowDate.timeIntervalSince1970 * 1000
        let timeString: String = String(timeInterval)
        return timeString
    }
}
