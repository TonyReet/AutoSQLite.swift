# AutoSQLite.swift
SQLite.swift的封装，使用swift的反射原理，Model直接存储.获取. 无需再转换,增删改查. 脱离sql语句,不需要添加相关的绑定操作，直接完成转换。

[![](https://img.shields.io/badge/Supported-iOS8-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)
[![](https://img.shields.io/badge/Swift-compatible-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)

![png](Snapshot.png)

### 使用方法
- 1、引入source目录下的文件文件:

```
SQLiteModel.swift
SQLiteDataBase.swift
SQLiteDataBaseTool.swift
SQLMirrorModel.swift
SQLPropertyModel.swift

创建model继承SQLiteModel即可
```
- 2、使用以下方法

```
        // 创建dataBase,
        var manager = SQLiteDataBase.createDB("testDataBaseName")
```

```
        // 插入
        manager.insert(object: testModel, intoTable: "testTableName")
        
        或者
        
        SQLiteDataBase.insert(object: testModel, intoTable: "testTableName")
```

```     
        // 删除
        manager.delete(testModel, fromTable: "testTableName")
        
        或者
        
        SQLiteDataBase.deleteModel(testModel, fromTable: "testTableName")
        
```

```
        // 更新
        testModel.name = "Reet"

        manager.update(testModel, fromTable: "testTableName")
        
        或者
        
        SQLiteDataBase.update(testModel, fromTable: "testTableName")
```

```
        // 查询
        guard let results = manager.select(testModel, fromTable: "testTableName") else {
            print("没有查询到数据")
            return
        }

        for result in results {
            print("查询的数据\(result)")
        }
        
        或者
        
        let results = SQLiteDataBase.select(testModel, fromTable: "testTableName")

        if results.count > 0{
            for result in results {
                print("查询的数据\(result)")
            }
        }else {
            print("没有查询到数据")
        }

```

### TODO:

1、添加对非基本类型的处理
2、支持使用protocol,减少代码的耦合
2、支持pod,carthage
~~3、使用SQLite.swift的风格重写Model的直接操作~~
4、增加insert和update的自动判断

你的star是我的动力

有任何疑问或建议. 欢迎在github或微博里issue我. 
微博:[@TonyReet](http://weibo.com/u/3648931023)
QQ:20130639  

