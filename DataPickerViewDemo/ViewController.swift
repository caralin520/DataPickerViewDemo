//
//  ViewController.swift
//  DataPickerViewDemo
//
//  Created by Lv on 2018/3/5.
//  Copyright © 2018年 Lv. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //数据数组(二维数组)
    var DataArray = [NSMutableArray]()
    
    fileprivate var yearsArray:NSMutableArray=[]
    fileprivate var monthArray:NSMutableArray=[]
    fileprivate var dataArray:NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataValue()
       
    }
    
    
    @IBAction func didEvent(_ sender: Any) {
        
        let dataView = DataPickerView.init(title: "日期", showType: .DATAYPE, pickerViewType: .THREE)
        dataView.actionSelected { (dataString) in
            print(dataString)
            
        }
        
       let _ =  dataView.show(target: self)
    }
    

    /**
     传数据
     */
    func dataValue(){
        self.yearsArray.removeAllObjects()
        self.monthArray.removeAllObjects()
        self.dataArray.removeAllObjects()
        
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd"
        let strNowTime = timeFormatter.string(from: date) as String
        let substringArry = strNowTime.components(separatedBy:"-")
        
        self.yearsArray = [1898...Int(substringArry[0])!+1]
        self.monthArray = [1...Int(substringArry[1])!+1]
        self.dataArray = [1...Int(substringArry[2])!+1]
        

        self.DataArray.insert(self.yearsArray, at: 0)
        self.DataArray.insert(self.monthArray, at: 1)
        self.DataArray.insert(self.dataArray, at:2)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

