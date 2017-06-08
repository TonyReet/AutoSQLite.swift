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
    
    var operateType: SQLiteOperateType = .statement{
        didSet{
            SQLiteDataBase.shared.operateType = self.operateType
        }
    }

    // 创建db
    var manager: SQLiteDataBase?

    // 测试的model
    var testModel = TestModel()
    

    let sqlTableName = "testTable"
    
    @IBAction func createAction() {
        createOperate()
    }
    
    @IBAction func insertAction() {
        insertOperate()
    }
    
    
    @IBAction func updateAction() {
        updateOperate()
    }
    
    
    @IBAction func deleteAction() {
        deleteOperate()
    }
    
    
    @IBAction func selectAction() {
        selectOperate()
    }
    
    
    @IBAction func dropAction() {
        dropOperate()
    }
    
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}



// MARK: - sql语句操作的方法
extension SQLiteOperateVc{
    
    func createOperate() {
        
        var dataName = ""
        if operateType == .statement {
            dataName = "statementDB"
        }else{
            dataName = "wrapperDB"
        }
        manager = SQLiteDataBase.createDB(dataName)
        
        testModel.pkid      = 1
        testModel.age       = 18
        testModel.name      = "Tony"
        testModel.ignore    = "ignore"
    }
    
    func insertOperate() {
        manager?.insert(testModel , intoTable: sqlTableName)
        
//        SQLiteDataBase.insert(object: testModel, intoTable: "statementTable")
    }
    
    
    func updateOperate() {
        testModel.name = "Reet"
        manager?.update(testModel, fromTable: sqlTableName)
        
//        SQLiteDataBase.update(testModel, fromTable: "statementTable")
    }
    
    
    func deleteOperate() {
        manager?.delete(testModel, fromTable: sqlTableName)
        
//        SQLiteDataBase.delete(testModel, fromTable: "statementTable")
    }
    
    
    func selectOperate() {
        guard let results = manager?.select(testModel, fromTable: sqlTableName),results.count > 0 else {
            print("没有查询到数据")
            return
        }

        for result in results {
            print("查询的数据\(result)")
        }
        
//        let results = SQLiteDataBase.select(testModel, fromTable: "statementTable")
//
//        if results.count > 0{
//            for result in results {
//                print("查询的数据\(result)")
//            }
//        }else {
//            print("没有查询到数据")
//        }
    }
    
    
    func dropOperate() {
        manager?.drop(dropTable: sqlTableName)
    }
}
