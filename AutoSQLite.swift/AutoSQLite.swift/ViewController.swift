//
//  ViewController.swift
//  AutoSQLite.swift
//
//  Created by QJ Technology on 2017/5/11.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

import UIKit

class TestModel: NSObject {
    var name = "hanmeimei"
    var age  = 18
    var pkid = 1//PRIMARY KEY ID
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 创建db
        let manager: SQLiteDataBase = SQLiteDataBase.create(withDBName: "testDB")
        
        let student = TestModel()
        
        // 插入,Y
        manager.insert(object: student, intoTable: "testTable")
        
        // delete by id,Y
        manager.delete(fromTable: "testTable", sqlWhere: "pkid = 2")
        
        // update,Y
        student.name = "lilei"
        manager.update(student, fromTable: "testTable")
        
        // select
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

