//
//  ViewController.swift
//  AutoSQLite.swift
//
//  Created by QJ Technology on 2017/5/11.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

import UIKit

class TestModel: SQLiteModel {
    var name = "hanmeimei"
    var age  = 18
    var pkid = 1//PRIMARY KEY ID
    
    var ignore: String = ""//需要忽略的属性
    
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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 创建db
        let manager: SQLiteDataBase = SQLiteDataBase.createDB("testDB")
        
        let student = TestModel()
        
        // 插入
        manager.insert(object: student, intoTable: "testTable")
        
        // 删除
        manager.delete(fromTable: "testTable", sqlWhere: "pkid = 2")
        
        // 更新
        student.name = "lilei"
        manager.update(student, fromTable: "testTable")
        
        // 查询
        let results = manager.select(fromTable: "testTable", sqlWhere: "pkid = 1")
        for result in results {
            print("查询的数据\(result)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

