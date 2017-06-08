//
//  ViewController.swift
//  AutoSQLite.swift
//
//  Created by QJ Technology on 2017/5/11.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! SQLiteOperateVc
        
        if segue.identifier == "statement" {
            destinationVc.operateType = .statement
        }else if segue.identifier == "wrapper" {
            destinationVc.operateType = .wrapper
        }
    }
}

