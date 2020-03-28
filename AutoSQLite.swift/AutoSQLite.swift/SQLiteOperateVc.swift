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
        testModel.age       = 18
        testModel.name      = "Tony"
        testModel.ignore    = "ignore"
        testModel.weight    = 140
        testModel.newAge    = 19
//        testModel.uuid      = "testuuid1"
        
        testModel.optionalInt = 1
        testModel.optionalFloat = 2.0
        testModel.optionalDouble = 3.0
        testModel.optionalisTest = true
        testModel.optionalString = "optionalString"
        
        return testModel;
    }()
    
    // 测试的model
    lazy var testModel1: TestModel = {
        let testModel =  TestModel()

        testModel.age       = 19
        testModel.name      = "Tony1"
        testModel.ignore    = "ignore"
        testModel.weight    = 141
        testModel.newAge    = 20
        
        testModel.optionalInt = 2
        testModel.optionalFloat = 3.0
        testModel.optionalDouble = 4.0
        testModel.optionalisTest = true
        testModel.optionalString = "optionalString"
        
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
        manager.insert(testModel1 , intoTable: sqlTableName)
    }
    
    
    func updateOperate() {
        testModel.name = "Reet"
        testModel.optionalString = "updateOptionalString"
        
        manager.update(testModel, fromTable: sqlTableName)
    }
    
    
    func deleteOperate() {
        manager.delete(testModel, fromTable: sqlTableName)
    }
    
    
    func selectOperate() {
        guard let results = manager.select(testModel, fromTable: sqlTableName) else {
            sqlitePrint("没有查询到数据")
            return
        }

        for result in results {
//            sqlitePrint("查询的数据\(result)")
//            guard let name = result["name"],let primaryKey = result[testModel.primaryKey()] else {
//                continue
//            }
//            
//            if ((name as! String) == testModel.name){
//                return
//            }
//            
//            testModel.pkid = (primaryKey as! Int)
        }
    }
    
    
    func dropOperate() {
        manager.drop(dropTable: sqlTableName)
    }
}
