//
//  SQLiteModel.swift
//  AutoSQLite.swift
//
//  Created by QJ Technology on 2017/5/12.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

import Foundation

//modify_future
/// 先使用这个基类进行操作，后续这个基类需要改为protocol

/// 基类
open class SQLiteModel: NSObject {
    var pkid    : Int?//PRIMARY KEY ID,可不设置
    
    public required override init() {
        super.init()
    }
    
    /// 主键字段
    open func primaryKey() -> String? {
        return "pkid"
    }
    
    /// 忽略的字段，不保存
    open func ignoreKeys() -> [String]? {
        return nil
    }
    
    /// 唯一的字段，如果不存在，就需要先使用数据查询到主键以后才能更新，删除，移除
    open func uniqueKeys() -> [String]? {
        return nil
    }
}
