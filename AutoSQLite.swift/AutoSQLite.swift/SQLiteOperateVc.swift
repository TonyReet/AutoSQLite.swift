//
//  SQLiteOperateVc.swift
//  AutoSQLite.swift
//
//  Created by QJ Technology on 2017/5/26.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

import UIKit
import AutoSQLiteSwift

//SQL 语句操作的vc
class SQLiteOperateVc: UIViewController {
    // 创建db
    lazy var manager: SQLiteDataBase = {
        return SQLiteDataBase.createDB("statementDB")
    }()

    // 测试的model
    lazy var testModel: TestModel = {
        let testModel =  TestModel()
        testModel.age       = 18
        testModel.name      = "Tony"
        testModel.ignore    = "ignore"
        testModel.weight    = 140
        testModel.newAge    = 19
        testModel.uuid      = "testuuid1"
        
        testModel.optionalInt = 1
        testModel.optionalFloat = 2.0
        testModel.optionalDouble = 3.0
        testModel.optionalisTest = true
        testModel.optionalString = "optionalString"
        
        return testModel;
    }()
    
    var updateIndex = 1
    let sqlTableName = "testTable"
    
    @IBAction func insertAction() {
        testModel.name = "Tony"
        
        manager.insert(testModel , intoTable: sqlTableName)
    }
    
    
    @IBAction func updateAction() {
        // 存在uuid，如果有数据就更新数据，没有数据insert
        testModel.name = "Reet\(updateIndex)"
        testModel.optionalString = "updateOptionalString"
        
        manager.update(testModel, fromTable: sqlTableName)
        updateIndex += 1
    }
    
    
    @IBAction func deleteAction() {
        manager.delete(testModel, fromTable: sqlTableName)
    }
    
    
    @IBAction func selectAction() {
        // select testModel
        guard let results = manager.select(testModel, fromTable: sqlTableName) else {
            sqlitePrint("没有查询到数据")
            return
        }
        
        sqlitePrint("查询到数据:\(results)")
    }
    
    
    @IBAction func dropAction() {
        manager.drop(dropTable: sqlTableName)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
