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

/// 所有类都需要加入init
class SQLiteModel: NSObject {
    
    func primaryKey() -> String {
        return ""
    }
    
    func ignoreKeys() -> [String] {
        return []
    }
}