//
//  DataPickerView.swift
//  LvZoomPictureView


import UIKit

//UIPickerView 显示三种数组类型
public enum ShowType:String{
    case OTHERType //其他类型
    case DATAYPE //时间类型
    
}

//UIPickerView 显示三种数组类型
public enum PickerViewType:Int{
    case ONE //只有年
    case TWO //年月
    case THREE  //年月日
    
}

typealias DataPickerViewActionSelect = ((_ dataStr:String) -> Void)
class DataPickerView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {
    /**屏幕宽度*/
    fileprivate var  maxWIDE=UIScreen.main.bounds.size.width
    fileprivate var  maxHIGH=UIScreen.main.bounds.size.height
    //推送页面
    var targe:UIViewController!
    
    /**背景View高度*/
    fileprivate var  BACKVIEWHIGH:CGFloat = 300
    /**边距*/
    fileprivate var  MARGIN = CGFloat()
    /**选择框*/
    var myPickerView = UIPickerView()
    /**背景View*/
    var backView = UIView()
    /**选择框值*/
    var timeStr=String()
    /**选择框label*/
    var myLabel:UILabel!
    /**按钮(确定、取消)*/
    var ok = UIButton()
    var cancel = UIButton()
    //确定代理
    var actionSelector:DataPickerViewActionSelect?
    
    //数据数组(二维数组)
    var DataArray = [NSMutableArray]()
    
    /**存储三组数据点击后的值*/
    fileprivate var oneStr = String()
    fileprivate var twoStr = String()
    fileprivate var threeStr = String()
    //存储时间
    fileprivate var yearsArray:NSMutableArray=[]
    fileprivate var monthArray:NSMutableArray=[]
    fileprivate var dataArray:NSMutableArray = []
    
    //存储组和行
    fileprivate var group=Int()
    fileprivate var line=Int()
    //标题
    fileprivate var title = String()
    
    
    //显示类型(时间类型、其他类型)
    var showType = ShowType.DATAYPE
    //显示数据区数
    var pickerViewType = PickerViewType.ONE
    
    //存储当前时间
    fileprivate var substringArry = [String]()
    //按钮颜色自定义
    fileprivate var cancelColorStr = "F5F6F7"
    fileprivate var submitColorStr = "965AFF"
    //小月
    var abortionArray = ["04","06","09","11"]
    /**
     -dataArray 数据
     -title: 标题
     -showType: 数据类型
     -pickerViewType: 显示风格
     -return: 其他类型
     */
    convenience init(dataArray:[NSMutableArray],title:String,showType:ShowType,pickerViewType:PickerViewType){
        self.init()
        self.DataArray=dataArray
        self.showType=showType
        self.pickerViewType=pickerViewType
        self.title=title
        
    }
    
    /**
     -dataArray 数据
     -title: 标题
     -showType: 数据类型
     -pickerViewType: 显示风格
     -return: 日期类型
     */
    convenience init(title:String,showType:ShowType,pickerViewType:PickerViewType){
        self.init()
        self.showType=showType
        self.pickerViewType=pickerViewType
        self.title=title
        
    }
    
    /**
     -dataArray 数据
     -title: 标题
     -showType: 数据类型
     -pickerViewType: 显示风格
     -cancelColorB: 取消按钮颜色
     -submitColorB: 确认按钮颜色
     -return: 日期类型
     */
    convenience init(title:String,showType:ShowType,pickerViewType:PickerViewType,cancelColorB:String,submitColorB:String){
        self.init()
        self.showType=showType
        self.pickerViewType=pickerViewType
        self.title=title
        self.cancelColorStr = cancelColorB
        self.submitColorStr = submitColorB
        
    }
    
    /**
     -dataArray 数据
     -title: 标题
     -showType: 数据类型
     -pickerViewType: 显示风格
     -cancelColorB: 取消按钮颜色
     -submitColorB: 确认按钮颜色
     -return: 其他类型
     */
    convenience init(dataArray:[NSMutableArray],title:String,showType:ShowType,pickerViewType:PickerViewType,cancelColorB:String,submitColorB:String){
        self.init()
        self.showType=showType
        self.pickerViewType=pickerViewType
        self.title=title
        self.cancelColorStr = cancelColorB
        self.submitColorStr = submitColorB
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        
        
    }
    
    /**
     布局页面
     */
    func  show(target:UIViewController)->DataPickerView{
        self.targe = target
        self.MARGIN = 30
        self.frame = CGRect(x: 0, y:0, width:maxWIDE, height:maxHIGH)
        
        //背景色
        self.backgroundColor=UIColor.init(r:0, g:0, b:0, alpha: 0.4)
        
        /**
         背景view
         */
        self.backView.frame=CGRect.init(x:MARGIN, y:((self.maxHIGH/2)-64)-(self.BACKVIEWHIGH/2), width: self.maxWIDE-(self.MARGIN*2), height:self.BACKVIEWHIGH)
        backView.backgroundColor=UIColor.white
        backView.layer.cornerRadius=8
        backView.layer.masksToBounds=true
        self.addSubview(backView)
        
        /**
         标题
         */
        let titleL = UILabel(frame: CGRect.init(x: 0, y:10, width: backView.frame.size.width, height: 21))
        titleL.textAlignment=NSTextAlignment.center
        titleL.textColor=UIColor.init(hex:"3A3A3A", alpha: 1)
        titleL.text=self.title
        backView.addSubview(titleL)
        
        /**
         选择框
         */
        
        self.myPickerView.frame = CGRect.init(x: 0, y:titleL.frame.origin.y+21+30, width: backView.frame.size.width, height: 140)
        self.myPickerView.delegate=self
        self.myPickerView.dataSource=self
        backView.addSubview(self.myPickerView)
        
        /**
         按钮
         */
        self.cancel.frame = CGRect.init(x:10, y:self.backView.frame.size.height-70, width: self.backView.frame.size.width/2-13, height: 40)
        self.cancel.setTitle("取消", for: UIControlState.normal)
        self.cancel.setTitleColor(UIColor.init(hex:"965AFF", alpha: 1), for: UIControlState.normal)
        self.cancel.backgroundColor=UIColor.init(hex:self.cancelColorStr, alpha:1)
        self.cancel.layer.cornerRadius=20
        self.cancel.layer.borderWidth=1
        self.cancel.layer.borderColor=UIColor.init(hex: "965AFF", alpha: 1)?.cgColor
        self.cancel.addTarget(self, action:#selector(self.dismissView), for: UIControlEvents.touchUpInside)
        self.backView.addSubview(self.cancel)
        
        self.ok.frame=CGRect.init(x:self.cancel.frame.origin.x+(self.cancel.frame.size.width+6), y:self.backView.frame.size.height-70, width: self.cancel.frame.size.width, height: self.cancel.frame.size.height)
        self.ok.setTitle("确定", for: UIControlState.normal)
        self.ok.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.ok.backgroundColor=UIColor.init(hex:self.submitColorStr, alpha:1)
        self.ok.layer.cornerRadius=20
        self.ok.addTarget(self, action:#selector(self.determineButtonEvent), for: UIControlEvents.touchUpInside)
        self.backView.addSubview(self.ok)
        
        self.PickerViewSelectRow()
        
        target.view.addSubview(self)
        return self
    }
    
    
    //默认选中
    func PickerViewSelectRow(){
        
        switch showType {
        case .DATAYPE:
            let date = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd"
            let strNowTime = timeFormatter.string(from: date) as String
            self.substringArry = strNowTime.components(separatedBy:"-")
            self.dataValue(ystr: self.substringArry[0], mstr: self.substringArry[1], dstr: self.substringArry[2])
            
            switch pickerViewType {
            case .ONE:
                self.myPickerView.selectRow(self.DataArray[0].count-1,inComponent:0,animated:true)
            case .TWO:
                self.myPickerView.selectRow(self.DataArray[0].count-1,inComponent:0,animated:true)
                self.myPickerView.selectRow(Int(substringArry[1])!-1,inComponent:1,animated:true)
            default:
                self.myPickerView.selectRow(self.DataArray[0].count-1,inComponent:0,animated:true)
                self.myPickerView.selectRow(Int(self.substringArry[1])!-1,inComponent:1,animated:true)
                self.myPickerView.selectRow(Int(self.substringArry[2])!-1,inComponent:2,animated:true)
            }
        default:
            switch pickerViewType {
            case .ONE:
                self.myPickerView.selectRow(0,inComponent:0,animated:true)
            case .TWO:
                self.myPickerView.selectRow(0,inComponent:0,animated:true)
                self.myPickerView.selectRow(0,inComponent:1,animated:true)
            default:
                self.myPickerView.selectRow(0,inComponent:0,animated:true)
                self.myPickerView.selectRow(0,inComponent:1,animated:true)
                self.myPickerView.selectRow(0,inComponent:2,animated:true)
            }
        }
        
    }
    
    
    
    
    /**
     显示日期数据
     */
    func dataValue(ystr:String,mstr:String,dstr:String){
        self.yearsArray.removeAllObjects()
        self.monthArray.removeAllObjects()
        self.dataArray.removeAllObjects()
        //年
        if ystr != "" {
            for i in 1898..<Int(ystr)!+1{
                self.yearsArray.add("\(i)")
            }
        }
        //月
        if mstr != "" {
            for i in 1..<Int(mstr)!+1 {
                if i<10 {
                    self.monthArray.add("0"+"\(i)")
                }else{
                    self.monthArray.add("\(i)")
                    
                }
            }
        }
        
        //日
        if dstr != "" {
            for i in 1..<Int(dstr)!+1{
                if i<10 {
                    self.dataArray.add("0"+"\(i)")
                }else{
                    self.dataArray.add("\(i)")
                }
            }
        }
        
        switch pickerViewType {
        case .ONE:
            self.DataArray.insert(self.yearsArray, at: 0)
        case .TWO:
            self.DataArray.insert(self.yearsArray, at: 0)
            self.DataArray.insert(self.monthArray, at: 1)
        default:
            self.DataArray.insert(self.yearsArray, at: 0)
            self.DataArray.insert(self.monthArray, at: 1)
            self.DataArray.insert(self.dataArray, at:2)
        }

        
        self.myPickerView.reloadAllComponents()
    }
    
    
    
    
    //点击函数
    func actionSelected(action:DataPickerViewActionSelect?) {
        self.actionSelector = action
    }
    
    
    /*********************/
    // 选择框代理方法
    /********************/
    
    /**UIPickerViewDataSource*/
    
    /**
     返回的列显示的数量
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.DataArray.count
    }
    
    
    /**
     返回的行每个组
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.DataArray[component].count
        
    }
    
    
    // *UIPickerViewDelegate
    
    /**
     返回列高度
     */
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    /**
     返回列宽度
     */
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch pickerViewType {
        case .ONE:
            return  self.backView.frame.size.width
        case .TWO:
            return  self.backView.frame.size.width/2
        default:
            return  self.backView.frame.size.width/3
        }
    }
    
    
    // 重写方法,改变View样式
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if view == nil {
            self.myLabel = view as! UILabel!
            self.myLabel=UILabel()
            self.myLabel.textColor = UIColor.init(hex:"6D6D6D", alpha: 1)
            self.myLabel.backgroundColor = UIColor.white
            self.myLabel.textAlignment = NSTextAlignment.center
            self.myLabel.font = UIFont.systemFont(ofSize: 18)
            
        }

        self.myLabel?.text = self.DataArray[component][row] as? String
        
        //选择改变字体颜色
        if component==self.group && row==self.line {
            self.myLabel.textColor = UIColor.init(hex:"56B64D", alpha: 1)
        }
        
        /************/
        // 赋值传值
        /************/
        switch pickerViewType {
        case .ONE:
            switch component {
            case 0:
                self.oneStr = self.myLabel.text!
            default:
                break
            }
        case .TWO:
            switch component {
            case 0:
                self.oneStr = self.myLabel.text!
            default:
                self.threeStr = self.myLabel.text!
            }
        default:
            switch component {
            case 0:
                self.oneStr = self.myLabel.text!
            case 1:
                self.twoStr = self.myLabel.text!
            default:
                self.threeStr = self.myLabel.text!
            }
        }
        
        return self.myLabel
    }
    
    
    /**
     将在滑动停止后触发，并打印出选中列和行索引
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.group = component
        self.line = row
        self.myLabel.text = self.DataArray[component][row] as? String

        /************/
        // 赋值传值
        /************/
        switch pickerViewType {
        case .ONE:
            switch component {
            case 0:
                self.oneStr = self.myLabel.text!
            default:
                break
            }
        case .TWO:
            switch component {
            case 0:
                self.oneStr = self.myLabel.text!
            default:
                self.threeStr = self.myLabel.text!
            }
        default:
            switch component {
            case 0:
                self.oneStr = self.myLabel.text!
            case 1:
                self.twoStr = self.myLabel.text!
            default:
                self.threeStr = self.myLabel.text!
            }
        }
        self.judgeOrLeapYear()
    }
    
    
    /*********************/
    //点击按钮事件
    /********************/
    
    //确定事件
    @objc func determineButtonEvent(){
        switch showType {
        case .DATAYPE:
            switch pickerViewType {
            case .ONE:
                self.actionSelector?(self.oneStr)
            case .TWO:
                self.actionSelector?(self.oneStr+"/"+self.twoStr)
            default:
                self.actionSelector?(self.oneStr+"/"+self.twoStr+"/"+self.threeStr)
            }
        default:
            switch pickerViewType {
            case .ONE:
                self.actionSelector?(self.oneStr)
            case .TWO:
                self.actionSelector?(self.oneStr+self.twoStr)
            default:
                self.actionSelector?(self.oneStr+self.twoStr+self.threeStr)
            }
            
        }
        
        self.dismissView()
        
    }
    
    
    
    //判断是否为闰年和大小月
    func  judgeOrLeapYear(){
      if self.showType == .DATAYPE {
        //年月日
        if self.pickerViewType == .THREE {
         //当前时间
        let nowTime = self.substringArry[0] + "-" + self.substringArry[1] + "-" + self.substringArry[2]
        //选择时间
        let timeStr = self.oneStr + "-" + self.twoStr + "-" + self.threeStr
       //判断是当前时间大于选择时间
      if  nowTime != timeStr{
            /**********当前年***********/
        if self.substringArry[0]  == self.oneStr  {
             //对当前年进行特殊处理
            self.judgeNowyears()
        }else{
            //不是当前年进行处理
            self.judgeNotNowyears()
        }
        
      }else{
        //当前时间
         self.dataValue(ystr:self.substringArry[0], mstr:self.substringArry[1], dstr:self.substringArry[2])
        }
     }
        
     //年月
     if self.pickerViewType == .TWO {
        //当前时间
        let strNowTime = self.substringArry[0] + "-" + self.substringArry[1]
        //选择时间
        let timeStr = self.oneStr + "-" + self.twoStr

        if strNowTime != timeStr {
            if self.substringArry[0]  == self.oneStr  {
              self.dataValue(ystr:self.substringArry[0], mstr:self.substringArry[1], dstr:"")
            }else{
              self.dataValue(ystr:self.substringArry[0], mstr:"12", dstr:"")
            }
        }else{
           self.dataValue(ystr:self.substringArry[0], mstr:self.substringArry[1], dstr:"")
        }
    }
     
    }
        
  }
    
    
    //对当前年进行特殊处理
    func judgeNowyears(){
    
        //判断是否为闰年
        if (Int(self.oneStr)! % 4 == 0 && Int(self.oneStr)! % 100 != 0 ) || Int(self.oneStr)! % 400 == 0 {
            //当前年不是当前月
            if self.substringArry[1] != self.twoStr {
                
                // 判断大小月
                if (self.twoStr == self.abortionArray[0]  || self.twoStr == self.abortionArray[1] || self.twoStr == self.abortionArray[2] || self.twoStr == self.abortionArray[3]) {
                    self.dataValue(ystr:self.substringArry[0], mstr:self.substringArry[1], dstr:"30")
                    
                }else{
                    
                    if self.twoStr == "02" {
                        self.dataValue(ystr:self.substringArry[0], mstr:self.substringArry[1], dstr:"29")
                    }else{
                        self.dataValue(ystr:self.substringArry[0], mstr:self.substringArry[1], dstr:"31")
                    }
                }
                
            }else{
                //当前时间
                self.dataValue(ystr:self.substringArry[0], mstr:self.substringArry[1], dstr:self.substringArry[2])
            }
            
            
        }else{
            
            if self.substringArry[1] != self.twoStr {
                // 判断大小月
                if (self.twoStr == self.abortionArray[0]  || self.twoStr == self.abortionArray[1] || self.twoStr == self.abortionArray[2] || self.twoStr == self.abortionArray[3]) {
                    self.dataValue(ystr:self.substringArry[0], mstr:self.substringArry[1], dstr:"30")
                    
                }else{
                    
                    if self.twoStr == "02" {
                        self.dataValue(ystr:self.substringArry[0], mstr:self.substringArry[1], dstr:"28")
                    }else{
                        self.dataValue(ystr:self.substringArry[0], mstr:self.substringArry[1], dstr:"31")
                    }
                }
            }else{
                //当前时间
                self.dataValue(ystr:self.substringArry[0], mstr:self.substringArry[1], dstr:self.substringArry[2])
            }
        }
    }
    
    
    //不是当前年进行处理
    func judgeNotNowyears(){
        
        /**********不是当前年***********/
        //判断是否为闰年
        if (Int(self.oneStr)! % 4 == 0 && Int(self.oneStr)! % 100 != 0 ) || Int(self.oneStr)! % 400 == 0 {
            
            // 判断大小月
            if (self.twoStr == self.abortionArray[0]  || self.twoStr == self.abortionArray[1] || self.twoStr == self.abortionArray[2] || self.twoStr == self.abortionArray[3]) {
                self.dataValue(ystr:self.substringArry[0], mstr:"12", dstr:"30")
                
            }else{
                
                if self.twoStr == "02" {
                    self.dataValue(ystr:self.substringArry[0], mstr:"12", dstr:"29")
                }else{
                    self.dataValue(ystr:self.substringArry[0], mstr:"12", dstr:"31")
                    
                }
            }
            
            
        }else{
            // 判断大小月
            if (self.twoStr == self.abortionArray[0]  || self.twoStr == self.abortionArray[1] || self.twoStr == self.abortionArray[2] || self.twoStr == self.abortionArray[3]) {
                self.dataValue(ystr:self.substringArry[0], mstr:"12", dstr:"30")
                
            }else{
                
                if self.twoStr == "02" {
                    self.dataValue(ystr:self.substringArry[0], mstr:"12", dstr:"28")
                }else{
                    self.dataValue(ystr:self.substringArry[0], mstr:"12", dstr:"31")
                }
            }
            
            
        }
        
    }
    
    
    
//    //日期比较
//    func compareDate(nowTime:String,chooseTime:String) -> Int{
//        let timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "yyyy-MM-dd"
//        let oneDayStr = timeFormatter.date(from: chooseTime)
//        let anotherDayStr = timeFormatter.date(from: nowTime)
//         //选择时间
//        let dataA = timeFormatter.string(from: oneDayStr!)
//        //当前时间
//        let dataB = timeFormatter.string(from: anotherDayStr!)
//        //时间比较
//        let result:ComparisonResult = dataA.compare(dataB)
//        
//        if result == .orderedAscending {
//            //dataB比dataA大
//            return 1
//        }
//        
//        if result == .orderedDescending {
//            //dataB比dataA小
//             return -1
//        }
//    
//        return 0
//    }

    
    //消失事件
    @objc func dismissView(){
        UIView.animate(withDuration:0, animations: {
            self.frame.origin.y += UIScreen.main.bounds.size.height
            
        }) { (true) in
            
            for view in self.subviews {
                if view.isKind(of: DataPickerView.self){
                    view.removeFromSuperview()
                }
                
            }
            
        }
    }
    
    
}

