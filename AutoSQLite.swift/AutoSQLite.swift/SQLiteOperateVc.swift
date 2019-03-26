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
    var operateType: SQLiteOperateType = .statement{
        didSet{
            SQLiteDataBase.shared.operateType = self.operateType
        }
    }

    // 创建db
    lazy var manager: SQLiteDataBase = {
        
        var dataName = ""
        if operateType == .statement {
            dataName = "statementDB"
        }else{
            dataName = "wrapperDB"
        }
        
        return SQLiteDataBase.createDB(dataName)
    }()

    // 测试的model
    lazy var testModel: TestModel = {
        let testModel =  TestModel()
        testModel.pkid      = 1
        testModel.age       = 18
        testModel.name      = "Tony"
        testModel.ignore    = "ignore"
        
        return testModel;
    }()
    

    let sqlTableName = "testTable"
    
    @IBAction func createAction() {
        
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
    func insertOperate() {
        testModel.name = "Tony"
        manager.insert(testModel , intoTable: sqlTableName)
    }
    
    
    func updateOperate() {
        testModel.name = "Reet"
        manager.update(testModel, fromTable: sqlTableName)
    }
    
    
    func deleteOperate() {
        manager.delete(testModel, fromTable: sqlTableName)
    }
    
    
    func selectOperate() {
        let results = manager.select(testModel, fromTable: sqlTableName)
        
        if results.count == 0 {
            print("没有查询到数据")
            return
        }

        for result in results {
            print("查询的数据\(result)")
        }
    }
    
    
    func dropOperate() {
        manager.drop(dropTable: sqlTableName)
    }
}
