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
@objcMembers
class SQLiteModel: NSObject {
    required override public init() {
        super.init()
    }
    
    func primaryKey() -> String {
        return ""
    }
    
    func ignoreKeys() -> [String] {
        return []
    }
}
