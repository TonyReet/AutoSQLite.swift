//
//  SQLiteDataBase.swift
//  AutoSQLite.swift
//
//  Created by QJ Technology on 2017/5/11.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

import Foundation
import SQLite

//let pkid = "pkid"//PRIMARY KEY ID

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
    class func createDB(_ dataBaseName: String)->SQLiteDataBase {
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
        sqliteDataBase.operateByMirror(object: object) { [weak sqliteDataBase](sqlMirrorModels) in
            guard let strongSqliteDataBase = sqliteDataBase else{
                return
            }
            
            strongSqliteDataBase.createTable(tableName,sqlMirrorModels:sqlMirrorModels)
        }
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
        return self.select(fromTable:tableName,sqlWhere: nil)
    }
    
    class func select(fromTable tableName: String,sqlWhere: String? = nil)->[[String:AnyObject]]{
        let sqliteDataBase = SQLiteDataBase.shared
        
        return sqliteDataBase.select(fromTable:tableName,sqlWhere: sqlWhere)
    }
    
    
    // MARK: - 删除数据
    class func deleteModel(_ object: SQLiteModel,fromTable tableName: String) {
        let sqliteDataBase = SQLiteDataBase.shared
        
        sqliteDataBase.operateByMirror(object: object) { [weak sqliteDataBase](sqlMirrorModels) in
            guard let sqliteDataBase = sqliteDataBase else{
                return
            }
            
            
            
            for sqlMirrorModel in sqlMirrorModels {
                
                guard let key = sqlMirrorModel.key,let value = sqlMirrorModel.value else {
                    continue
                }
                
                guard key == sqlMirrorModel.primaryKey else {
                    continue
                }
                
                sqliteDataBase.delete(fromTable: tableName,sqlWhere: "\(key) = '\(value)'")
            }
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
    func createTable(_ tableName: String,sqlMirrorModels:[SQLMirrorModel]) {
        
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
        for sqlMirrorModel in sqlMirrorModels {
            
            guard let key = sqlMirrorModel.key,let type = sqlMirrorModel.type else {
                continue
            }
            
            let forprimaryKey = sqlMirrorModel.primaryKey
            
            //如果是primaryKey 就返回
            guard key != forprimaryKey else {
                primaryKey = forprimaryKey!
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
        
        operateByMirror(object: object) { [weak self](sqlMirrorModels) in
            guard let strongSelf = self else{
                return
            }
            
            strongSelf.createTable(tableName,sqlMirrorModels:sqlMirrorModels)
            
            var keyStr   = ""
            var valueStr = ""
            for sqlMirrorModel in sqlMirrorModels {
                
                guard let key = sqlMirrorModel.key,let value = sqlMirrorModel.value else {
                    continue
                }
                
                keyStr += (key + " ,")
                valueStr += ("'\(value)' ,")
            }
            
            keyStr = SQLiteDataBaseTool.removeLastStr(keyStr)
            valueStr = SQLiteDataBaseTool.removeLastStr(valueStr)
            
            let sqlStr = "INSERT INTO \(tableName) (\(keyStr)) VALUES (\(valueStr))"
            strongSelf.execute(sqlStr)
        }
    }
    
    /// 根据object修改数据库
    ///
    /// - Parameters:
    ///   - object: 需要修改的object
    ///   - tableName: talbeName
    func update(_ object: SQLiteModel,fromTable tableName: String) {
        operateByMirror(object: object) { [weak self](sqlMirrorModels) in
            guard let strongSelf = self else{
                return
            }
            
            strongSelf.createTable(tableName,sqlMirrorModels:sqlMirrorModels)
            
            var setStr   = ""
            var whereStr = ""
            
            for sqlMirrorModel in sqlMirrorModels {
                
                guard let key = sqlMirrorModel.key else {
                    continue
                }
                
                let value = sqlMirrorModel.value
                let primaryKey = sqlMirrorModel.primaryKey
                strongSelf.sqlitePrint("key:\(key),pkid:\(String(describing: primaryKey))")
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
            strongSelf.execute(sqlStr)
        }
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
    // 检查tableName是否不合法
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
        let results = try! self.database?.prepare(sqlStr)
        
        var elements:[[String:AnyObject]] = []
        
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
            return elements
            
        }else{
            return elements
        }
        
    }
    
    //modify_future
    /// 通过反射转换成对应的数据，以后不使用闭包了，很不方便
    ///
    /// - Parameters:
    ///   - object: 传入的objc
    ///   - mirrorFinish: 反射结束后的闭包
    func operateByMirror(object: SQLiteModel,mirrorFinish:(_ sqlMirrorModel:[SQLMirrorModel])->()){
        let mirror = Mirror(reflecting: object)
        
        guard let displayStyle = mirror.displayStyle else {
            return
        }
        
        guard mirror.children.count > 0 else {
            return
        }
        
        var sqlMirrorModels = [SQLMirrorModel]()
        
        for child in mirror.children{
            let value = child.value
            let vMirror = Mirror(reflecting: value)  // 通过值来创建属性的反射
            
            if let key = child.label { //注意字典只能保存AnyObject类型。
                
                let mirrorModel = SQLMirrorModel()
                mirrorModel.key = key
                mirrorModel.value = value as AnyObject
                mirrorModel.type = vMirror.subjectType
                
                if object.primaryKey() == key {
                    mirrorModel.primaryKey = key
                }
                
                guard object.ignoreKeys().contains(key) == false else {
                    continue
                }
                
                sqlMirrorModels.append(mirrorModel)
            }
        }
        
        switch displayStyle {
        case .class:
            mirrorFinish(sqlMirrorModels)
        default:
            sqlitePrint("不支持的类型")
        }
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
