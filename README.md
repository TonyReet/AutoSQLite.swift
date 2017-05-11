# AutoSQLite.swift
SQLite.swift的封装，使用swift的反射原理，Model直接存储.获取. 无需再转换,增删改查. 脱离sql语句

[![](https://img.shields.io/badge/Supported-iOS8-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)
[![](https://img.shields.io/badge/Swift-compatible-4BC51D.svg?style=flat-square)](https://github.com/TonyReet/TYSnapshotScroll)

**<mark>更新内容:</mark>**


----------------- 2017.5.11更新 -------------

1、首次提交代码，很多地方不完善，暂时自己使用，瞧上的可以尝尝鲜


###使用方法
- 1、引入source目录下的文件文件:

```
SQLiteDataBase.swift
SQLiteDataBaseTool.swift
SQLMirrorModel.swift
```
- 2、使用以下方法

```
        // 创建db
        let manager: SQLiteDataBase = SQLiteDataBase.create(withDBName: "testDB")
```

```
        let student = TestModel()
        
        // 插入
        manager.insert(object: student, intoTable: "testTable")
```

```     
        // 删除
        manager.delete(fromTable: "testTable", sqlWhere: "pkid = 2")
        
```

```
        // 更新
        student.name = "lilei"
        manager.update(student, fromTable: "testTable")
```

```
        // 查询
        let results = manager.select(fromTable: "testTable", sqlWhere: "pkid = 1")
        for result in results {
            print("查询的数据\(result)")
        }
```

###TODO:
1、添加对非基本类型的处理
2、支持使用protocol,减少代码的耦合
2、支持pod,carthage
3、使用SQLite.swift的风格重写Model的直接操作

你的star是我的动力

有任何疑问或建议. 欢迎在github或微博里issue我. 
微博:[@KTony](http://weibo.com/u/3648931023)


