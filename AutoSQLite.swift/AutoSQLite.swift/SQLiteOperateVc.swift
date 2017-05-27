//
//  SQLiteOperateVc.swift
//  AutoSQLite.swift
//
//  Created by QJ Technology on 2017/5/26.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

import UIKit

//SQL 语句操作的vc
class SQLiteOperateVc: UIViewController {
    enum SQLiteOperateType: Int {
        case statement = 0//sql语句操作的类型
        case wrapper = 1//sqlite封装的类型(SQLite.Swift封装的类型)
    }

    var operateType: SQLiteOperateType = .statement

    // 创建db
    var manager: SQLiteDataBase?

    // 测试的model
    var testModel = TestModel()
    

    @IBAction func createAction() {
        switch operateType {
        case .statement:
            createStatement()
        case .wrapper:
            createWrapper()
        }
    }
    
    @IBAction func insertAction() {
        switch operateType {
        case .statement:
            insertStatement()
        case .wrapper:
            insertWrapper()
        }
    }
    
    
    @IBAction func updateAction() {
        switch operateType {
        case .statement:
            updateStatement()
        case .wrapper:
            updateWrapper()
        }
    }
    
    
    @IBAction func deleteAction() {
        switch operateType {
        case .statement:
            deleteStatement()
        case .wrapper:
            deleteWrapper()
        }
    }
    
    
    @IBAction func selectAction() {
        switch operateType {
        case .statement:
            selectStatement()
        case .wrapper:
            selectWrapper()
        }
    }
    
    
    @IBAction func dropAction() {
        switch operateType {
        case .statement:
            dropStatement()
        case .wrapper:
            dropWrapper()
        }
    }
    
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}



// MARK: - sql语句操作的方法
extension SQLiteOperateVc{
    
    func createStatement() {
        manager = SQLiteDataBase.createDB("statementDB")
        
        testModel.pkid      = 1
        testModel.age       = 18
        testModel.name      = "Tony"
        testModel.ignore    = "ignore"
    }
    
    func insertStatement() {
//        manager?.insert(object: testModel, intoTable: "statementTable")
        
        SQLiteDataBase.insert(object: testModel, intoTable: "statementTable")
    }
    
    
    func updateStatement() {
        testModel.name = "Reet"
//        manager?.update(testModel, fromTable: "statementTable")
        
        SQLiteDataBase.update(testModel, fromTable: "statementTable")
    }
    
    
    func deleteStatement() {
//        manager?.delete(fromTable: "statementTable", sqlWhere: "pkid = 2")
        SQLiteDataBase.deleteModel(testModel, fromTable: "statementTable")
    }
    
    
    func selectStatement() {
//        guard let results = manager?.select(fromTable: "statementTable", sqlWhere: "pkid = 1") else {
//            print("没有查询到数据")
//            return
//        }

        let results = SQLiteDataBase.select(testModel, fromTable: "statementTable")

        if results.count > 0{
            for result in results {
                print("查询的数据\(result)")
            }
        }else {
            print("没有查询到数据")
        }
    }
    
    
    func dropStatement() {
        manager?.drop(dropTable: "statementTable")
    }
}



extension SQLiteOperateVc{
    func createWrapper() {
        manager = SQLiteDataBase.createDB("wrapperDB")
    }
    
    func insertWrapper() {
        
    }
    
    
    func updateWrapper() {
        
    }
    
    
    func deleteWrapper() {
        
    }
    
    
    func selectWrapper() {
        
    }
    
    
    func dropWrapper() {
        
    }
}

