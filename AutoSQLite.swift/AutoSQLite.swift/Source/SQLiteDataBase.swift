//
//  SQLiteDataBase.swift
//  AutoSQLite.swift
//
//  Created by QJ Technology on 2017/5/11.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

import Foundation
import SQLite



class SQLiteDataBase: NSObject {
    //创建单例
    static let shared           = SQLiteDataBase()
    
    /// 是否打开打印,true是打开,false是关闭
    var printDebug              = true
    
    let default_DataBase_Name   = "database"
    
    var database: Connection?
    
    var databasePath: String?
    
    var databaseName: String?
    
    // MARK: - 初始化
    // 初始化db
    class func createDB(_ dataBaseName: String,isRemoveOld: Bool? = false)->SQLiteDataBase {
        let sqliteDataBase = SQLiteDataBase.shared
        
        let defaultPath = sqliteDataBase.defaultPath()
        
        if sqliteDataBase.checkNameIsVerify(dataBaseName) {
            
            let databaseName = SQLiteDataBaseTool.removeBlankSpace(dataBaseName)
            
            sqliteDataBase.database = try? Connection("\(defaultPath)/\(databaseName).sqlite3")
            sqliteDataBase.databasePath = "\(defaultPath)/\(databaseName).sqlite3"
        } else {
            
            let default_DataBase_Name = sqliteDataBase.default_DataBase_Name
            sqliteDataBase.database = try? Connection("\(defaultPath)/\(default_DataBase_Name).sqlite3")
            sqliteDataBase.databasePath = "\(defaultPath)/\(default_DataBase_Name).sqlite3"
        }
        
        sqliteDataBase.sqlitePrint("数据库文件地址:\(String(describing: sqliteDataBase.databasePath))")
        
        return sqliteDataBase
    }
    
    // MARK: - 创建表
    class func createTable(_ tableName: String,object:SQLiteModel) {
        let sqliteDataBase = SQLiteDataBase.shared
        
        guard let sqlMirrorModel = SQLMirrorModel.operateByMirror(object: object) else {
            return
        }
        
        sqliteDataBase.createTable(tableName,sqlMirrorModel:sqlMirrorModel)
    }
    
    // MARK: - 插入数据
    class func insert(object: SQLiteModel, intoTable tableName: String) {
        let sqliteDataBase = SQLiteDataBase.shared
        
        sqliteDataBase.insert(object:object, intoTable: tableName)
    }
    
    class func insertList(objectList: [SQLiteModel], intoTable tableName: String) {
        let sqliteDataBase = SQLiteDataBase.shared
        
        for object in objectList {
            sqliteDataBase.insert(object:object, intoTable: tableName)
        }
    }
    
    
    // MARK: - 更新数据
    class func update(_ object: SQLiteModel,fromTable tableName: String) {
        let sqliteDataBase = SQLiteDataBase.shared
        
        sqliteDataBase.update(object,fromTable:tableName)
    }
    
    class func updateList(objectList: [SQLiteModel], intoTable tableName: String) {
        let sqliteDataBase = SQLiteDataBase.shared
        
        for object in objectList {
            sqliteDataBase.update(object,fromTable:tableName)
        }
    }
    
    // MARK: - 查询数据
    class func selectAll(fromTable tableName: String)->[[String:AnyObject]]{
        let sqliteDataBase = SQLiteDataBase.shared
        
        return sqliteDataBase.select(fromTable:tableName,sqlWhere: nil)
    }
    
    class func select(_ object: SQLiteModel,fromTable tableName: String)->[[String:AnyObject]]{
        let sqliteDataBase = SQLiteDataBase.shared
        
        return sqliteDataBase.select(object,fromTable:tableName)
    }
    
    
    // MARK: - 删除数据
    class func deleteModel(_ object: SQLiteModel,fromTable tableName: String) {
        let sqliteDataBase = SQLiteDataBase.shared
        
        guard let sqlMirrorModel = SQLMirrorModel.operateByMirror(object: object) else {
            return
        }
        
        for sqlPropertie in sqlMirrorModel.sqlProperties {
            let key = sqlPropertie.key
        
            guard key == sqlMirrorModel.sqlPrimaryKey else {
                continue
            }
            
            sqliteDataBase.delete(fromTable: tableName,sqlWhere: "\(key) = '\(sqlPropertie.value)'")
        }
    }
    
    class func deleteModelWhere(_ sqlWhere: String,fromTable tableName: String) {
        let sqliteDataBase = SQLiteDataBase.shared
        
        sqliteDataBase.delete(fromTable: tableName,sqlWhere: sqlWhere)
    }
    
    class func drop(dropTable tableName: String){
        let sqliteDataBase = SQLiteDataBase.shared
        sqliteDataBase.drop(dropTable:tableName)
    }
    
    
    // MARK: - 获取默认的路径地址
    func defaultPath() -> String {
        guard let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else{
            return NSHomeDirectory()
        }
        
        return documentsPath
    }
    
}

extension SQLiteDataBase {
    /// 创建表
    ///
    /// - Parameters:
    ///   - tableName: 创建的表名
    ///   - mirrorModels:转换完的model
    func createTable(_ tableName: String,sqlMirrorModel:SQLMirrorModel) {
        
        if !checkNameIsVerify(tableName) {
            sqlitePrint("failed to create table: \(tableName)")
            return
        }
        
        let tableFinalName = SQLiteDataBaseTool.removeBlankSpace(tableName)
        
        if tableExists(tableName: tableFinalName) == true {
            return
        }
        
        //创建表
        var sqlStr = "CREATE TABLE IF NOT EXISTS " + tableFinalName
        

        //主键
        var primaryKey = ""
        
        //拼接动态字段
        var keyStr = ""
        for sqlPropertie in sqlMirrorModel.sqlProperties {
            
            let key = sqlPropertie.key
            let type = sqlPropertie.type
            let forPrimaryKey = sqlMirrorModel.sqlPrimaryKey
            
            //如果是primaryKey 就返回
            guard key != forPrimaryKey else {
                primaryKey = forPrimaryKey
                continue
            }
            
            keyStr += "\(key) \(SQLiteDataBaseTool.sqlType(type)),"
            
        }

        //添加主键
        sqlStr += "(" + primaryKey + " INTEGER UNIQUE PRIMARY KEY NOT NULL,"
        
        sqlStr += SQLiteDataBaseTool.removeLastStr(keyStr)
        
        sqlStr += ")"
        
        execute(sqlStr)
    }
    
    /// 根据object插入
    ///
    /// - Parameters:
    ///   - object: object
    ///   - tableName: 需要插入的tableName
    func insert(object: SQLiteModel, intoTable tableName: String) {
        guard let sqlMirrorModel = SQLMirrorModel.operateByMirror(object: object) else {
            return
        }
        
        self.createTable(tableName,sqlMirrorModel:sqlMirrorModel)
        
        var keyStr   = ""
        var valueStr = ""
        for sqlPropertie in sqlMirrorModel.sqlProperties {
            
            let key = sqlPropertie.key
            let value = sqlPropertie.value
            
            keyStr += (key + " ,")
            valueStr += ("'\(value)' ,")
        }
        
        keyStr = SQLiteDataBaseTool.removeLastStr(keyStr)
        valueStr = SQLiteDataBaseTool.removeLastStr(valueStr)
        
        let sqlStr = "INSERT INTO \(tableName) (\(keyStr)) VALUES (\(valueStr))"
        self.execute(sqlStr)
    }
    
    /// 根据object修改数据库
    ///
    /// - Parameters:
    ///   - object: 需要修改的object
    ///   - tableName: talbeName
    func update(_ object: SQLiteModel,fromTable tableName: String) {
        guard let sqlMirrorModel = SQLMirrorModel.operateByMirror(object: object) else {
            return
        }

        self.createTable(tableName,sqlMirrorModel:sqlMirrorModel)
        
        var setStr   = ""
        var whereStr = ""
        
        for sqlPropertie in sqlMirrorModel.sqlProperties {
            
            let key = sqlPropertie.key
            let value = sqlPropertie.value
            let primaryKey = sqlMirrorModel.sqlPrimaryKey
            
            self.sqlitePrint("key:\(key),primaryKey:\(String(describing: primaryKey))")
            guard key != primaryKey else {
                whereStr = "\(key) = '\(String(describing: value))'"
                continue
            }
            
            // setstr
            let tmpStr = "\(key) = '\(String(describing: value))' ,"
            
            setStr += tmpStr
        }
        
        setStr = SQLiteDataBaseTool.removeLastStr(setStr)
        
        let sqlStr = "UPDATE \(tableName) SET \(setStr) WHERE \(whereStr)"
        self.execute(sqlStr)
    }
    
    
    /// 查询数据
    ///
    /// - Parameters:
    ///   - tableName: 表名
    ///   - sqlWhere: sql查询语句
    /// - Returns: 返回结果
    func select(fromTable tableName: String,sqlWhere: String? = nil)->[[String:AnyObject]] {
        if tableExists(tableName: tableName) == false {
            return [[String:AnyObject]]()
        }
        
        var sqlStr = ""
        
        if let sqlWhere = sqlWhere {
            sqlStr = "SELECT * FROM \(tableName) WHERE \(sqlWhere)"
        }else{
            sqlStr = "SELECT * FROM \(tableName)"
        }
        
        let results = prepare(sqlStr)
        
        return results
    }
    
    func select(_ object: SQLiteModel,fromTable tableName: String)->[[String:AnyObject]] {
        if tableExists(tableName: tableName) == false {
            return [[String:AnyObject]]()
        }
        
        guard let sqlMirrorModel = SQLMirrorModel.operateByMirror(object: object) else {
            return [[String:AnyObject]]()
        }
        
        self.createTable(tableName,sqlMirrorModel:sqlMirrorModel)
        
        var whereStr:String?
        
        for sqlPropertie in sqlMirrorModel.sqlProperties {
            
            let key = sqlPropertie.key
            let value = sqlPropertie.value
            let primaryKey = sqlMirrorModel.sqlPrimaryKey
            
            self.sqlitePrint("key:\(key),primaryKey:\(String(describing: primaryKey))")
            guard key != primaryKey else {
                whereStr = "\(key) = '\(String(describing: value))'"
                continue
            }
        }

        var sqlStr = ""
        if let whereStr = whereStr {
            sqlStr = "SELECT * FROM \(tableName) WHERE \(whereStr)"
        }else{
            sqlStr = "SELECT * FROM \(tableName)"
        }
        
        let results = prepare(sqlStr)
        
        self.sqlitePrint("sqlStr:\(sqlStr)")
        
        return results
    }
    
    /// 删除table里面的字段
    ///
    /// - Parameters:
    ///   - tableName: table
    ///   - sqlWhere: 执行的where语句
    func delete(fromTable tableName: String,sqlWhere: String) {
        if tableExists(tableName: tableName) == false {
            return
        }
        
        let sqlStr = "DELETE FROM \(tableName) WHERE \(sqlWhere)"
        self.execute(sqlStr)
    }
    
    /// 删除整张表
    ///
    /// - Parameter tableName: 删除的表名
    func drop(dropTable tableName: String) {
        if tableExists(tableName: tableName) == false {
            return
        }
        
        let sqlStr = "DROP FROM \(tableName)"
        self.execute(sqlStr)
    }
    
    
    
    // MARK: - Tool Func
    // 检查tableName是否有效
    func checkNameIsVerify(_ name: String) -> Bool {
        if name.characters.count == 0 {
            sqlitePrint("name: \(name) format error")
            return false
        }
        
        return true
    }
    
    
    //https://github.com/stephencelis/SQLite.swift/issues/6
    func tableExists(tableName: String) -> Bool {
        guard database != nil else {
            return false
        }
        
        do {
            let isExists = try database?.scalar(
                "SELECT EXISTS (SELECT * FROM sqlite_master WHERE type = 'table' AND name = ?)", tableName
                ) as! Int64 > 0
            sqlitePrint("数据库表:\(isExists == true ? "存在" : "不存在")")
            return isExists
        }catch {
            sqlitePrint(error)
            return false
        }
        
    }
    
    /// 执行sql语句
    ///
    /// - Parameters:
    ///   - sqrStr: sql语句
    ///   - finish: 结束的闭包
    ///   - fail: 失败的闭包
    func execute(_ sqlStr:String,finish:()->() = { _ in },fail:()->() = { _ in }){
        do {
            sqlitePrint("sql语句:\(sqlStr)")
            try database?.execute(sqlStr)
            finish()
        }catch {
            sqlitePrint(error)
            fail()
        }
    }
    
    
    /// 查询数据
    ///
    /// - Parameter sqlStr: 查询的语句
    /// - Returns: 返回查询的数据，因为可能是多个，并且每个都以字典类型返回
    /// - 所以是数据类型是[[String:AnyObject]],[String:AnyObject]是字典类型
    func prepare(_ sqlStr: String)->[[String:AnyObject]]{
        var elements:[[String:AnyObject]] = []
        
        do {
            let results = try self.database?.prepare(sqlStr)
            
            if let results = results{
                
                let colunmSize = results.columnNames.count
                
                for row in results  {
                    var record:[String: AnyObject] = [:]
                    
                    for i in 0..<colunmSize {
                        
                        let value   = row[i]
                        let key     = results.columnNames[i] as String
                        
                        if let value = value {
                            record.updateValue(value as AnyObject, forKey: key)
                        }
                        
                    }
                    
                    elements.append(record)
                }
            }
        } catch {
            print(error)
        }
        
        return elements
    }
    
   
    /// 统一的打印
    ///
    /// - Parameter printObj: 打印的内容
    func sqlitePrint(_ printObj:Any){
        if printDebug == true {
            print(printObj)
        }
    }
}
