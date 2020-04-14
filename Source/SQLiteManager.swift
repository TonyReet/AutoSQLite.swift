//
//  SQLiteManager.swift
//  AutoSQLiteSwift
//
//  Created by TonyReet on 2020/4/14.
//

import UIKit

open class SQLiteManager: NSObject {
    /// 是否打开打印,true是打开,false是关闭,默认false
    public var printDebug = false
    
    /// 创建单例
    public static let shared = SQLiteManager()
}
