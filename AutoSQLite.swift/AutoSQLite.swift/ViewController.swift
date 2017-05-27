//
//  ViewController.swift
//  AutoSQLite.swift
//
//  Created by QJ Technology on 2017/5/11.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//    @IBAction func statementAction(_ sender: Any) {
//        let operateVc = SQLiteOperateVc()
//        operateVc.operateType = .statement
//        
//        self.present(operateVc, animated: true, completion: nil)
//    }
//    
//    
//    @IBAction func wrapperAction(_ sender: Any) {
//
//    }
//    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! SQLiteOperateVc
        
        if segue.identifier == "statement" {
            destinationVc.operateType = .statement
        }else if segue.identifier == "wrapper" {
            let alertController = UIAlertController(title: "提示", message: "暂不支持，稍候会加入该功能", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil )
            
            alertController.addAction(cancelAction);
            present(alertController, animated: true, completion: nil)
//            destinationVc.operateType = .wrapper
        }
    }
}

