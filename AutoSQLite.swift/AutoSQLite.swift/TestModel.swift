//
//  TestModel.swift
//  AutoSQLite.swift
//
//  Created by QJ Technology on 2017/5/26.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

import UIKit
import AutoSQLiteSwift

@objcMembers
class TestModel: SQLiteModel {
    
    var name    : String = ""
    var age     : Int = 0
    var uuid    : String?//表内唯一的标识，用户和server关联或者自查询的时候使用，如果没有设置，可通过查询后获取
    var ignore  : String = ""//需要忽略的属性
    var weight  : Float = 0
    var newAge  : Int = 0
    
    //后面需要支持的类型
    var optionalString : String?
    var optionalInt : Int?

    var optionalisTest:Bool?
    var optionalDouble:Double?
    var optionalFloat:Float?

    /// 忽略的字段，不保存
    override func ignoreKeys() -> [String]? {
        return ["ignore"]
    }
    
    /// 用于查询的字段，最好是唯一，如果不存在，就需要先使用数据查询到主键以后才能更新，删除，移除
    override func searchKeys() -> [String]? {
        return ["uuid"]
    }
}
