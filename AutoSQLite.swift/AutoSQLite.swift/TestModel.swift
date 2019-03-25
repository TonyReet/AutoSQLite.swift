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
    var pkid    : Int = 0//PRIMARY KEY ID,这个不能是optional类型
    var ignore  : String = ""//需要忽略的属性
    
    //后面需要支持的类型
    //    var optionalString : String?
    //    var optionalInt : Int?
    //
    //    var optionaldate:NSDate?
    //    var optionalisTest:Bool?
    //    var optionalDouble:Double?
    //    var optionalFloat:Float?
    //    var testModels:[TestModel]? = []
    
    
    override func primaryKey() -> String {
        return "pkid"
    }
    
    override func ignoreKeys() -> [String] {
        return ["ignore"]
    }
    
}
