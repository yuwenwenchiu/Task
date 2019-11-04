//
//  AddAccountingTableViewController.swift
//  Task
//
//  Created by Yuwen Chiu on 2019/10/8.
//  Copyright © 2019 YuwenChiu. All rights reserved.
//

import UIKit
import CoreData

class AddAccountingTableViewController: UITableViewController, UIPickerViewDelegate,  UIPickerViewDataSource, NearbyLocationsViewControllerDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateDatePicker: UIDatePicker! 
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var methodPicker: UIPickerView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var remarksTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    var eiType = 0
    
    let formatter = DateFormatter()
    
    var eMethod = ["現金", "信用卡", "轉帳", "Apple Pay", "Line Pay"]
    var iMethod = ["匯款", "現金", "支票"]
    
    var eCategory = ["飲食", "交通", "購物", "休閒娛樂", "生活開銷"]
    var iCategory = ["薪資", "獎金", "投資", "接案", "支援"]
    
    // Picker的顯示狀態
    var isDatePickerShown = false
    var isMethodPickerShown = false
    var isCategoryPickerShown = false
    
    // 包含Picker的Cell位置
    let datePickerCellIndexPath = IndexPath(row: 1, section: 0)
    let methodPickerCellIndexPath = IndexPath(row: 3, section: 0)
    let categoryPickerCellIndexPath = IndexPath(row: 5, section: 0)
    
    var NearbyLocationsViewController: NearbyLocationsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "yyyy-MM-dd"
        dateLabel.text = formatter.string(from: Date())
        methodLabel.text = eMethod[0]
        categoryLabel.text = eCategory[0]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showLocations" {
            
            NearbyLocationsViewController = segue.destination as? NearbyLocationsViewController
            NearbyLocationsViewController?.NearbyLocationsViewControllerDelegate = self
        }
    }
    
    @IBAction func dateValueChanged(_ sender: UIDatePicker) {
        
        dateLabel.text = formatter.string(from: sender.date)
    }
    
    @IBAction func closeRemarksKeyboard(_ sender: UITextField) {
        
    }
    
    @IBAction func closeLocationKeyboard(_ sender: UITextField) {
        
    }
    
    @IBAction func searchNearby(_ sender: UIButton) {
        
    }
    
    // MARK: - Picker view data source
    // Picker都有幾個滾輪？方式、類別都只有1個
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    // 滾輪有幾列？依據不同滾輪和收支，回傳不同的列數
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
            
        case methodPicker:
            if eiType == 0 {
                
                return eMethod.count
            } else {
                
                return iMethod.count
            }
            
        case categoryPicker:
            if eiType == 0 {
                
                return eCategory.count
            } else {
                
                return iCategory.count
            }
            
        default:
            return 0
        }
        
    }
    
    // 每列顯示什麼？依據不同滾輪、收支和列數，回傳不同的資料
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
            
        case methodPicker:
            if eiType == 0 {
                
                return eMethod[row]
            } else {
                
                return iMethod[row]
            }
            
        case categoryPicker:
            if eiType == 0 {
                
                return eCategory[row]
            } else {
                
                return iCategory[row]
            }
            
        default:
            return nil
        }
    }
    
    // 選擇列後要做什麼？依據不同滾輪、收支和所在列，顯示不同的資料
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
            
        case methodPicker:
            if eiType == 0 {
                
                methodLabel.text = eMethod[row]
            } else {
                
                methodLabel.text = iMethod[row]
            }
            
        case categoryPicker:
            if eiType == 0 {
                
                categoryLabel.text = eCategory[row]
            } else {
                
                categoryLabel.text = iCategory[row]
            }
            
        default:
            break
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0.1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 9
    }
    
    // 選擇列後要做什麼？依據不同位置展開包含Picker的Cell，並且修改Picker的顯示狀態、更新tableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
            
        case (datePickerCellIndexPath.section, datePickerCellIndexPath.row - 1):
            if isDatePickerShown == true {
                isDatePickerShown = false
            } else {
                isDatePickerShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        case (methodPickerCellIndexPath.section, methodPickerCellIndexPath.row - 1):
            if isMethodPickerShown == true {
                isMethodPickerShown = false
            } else {
                isMethodPickerShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        case (categoryPickerCellIndexPath.section, categoryPickerCellIndexPath.row - 1):
            if isCategoryPickerShown == true {
                isCategoryPickerShown = false
            } else {
                isCategoryPickerShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default:
            break
        }
    }
    
    // 每列的高度？依據不同位置、Picker的顯示狀態，回傳相應的高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath {
            
        case datePickerCellIndexPath:
            if isDatePickerShown == true {
                return 215
            } else {
                return 0
            }
            
        case methodPickerCellIndexPath:
            if isMethodPickerShown == true {
                return 150
            } else {
                return 0
            }
            
        case categoryPickerCellIndexPath:
            if isCategoryPickerShown == true {
                return 150
            } else {
                return 0
            }
            
        default:
            return 62.5
        }
    }
    
    func passLocationName(name: String) {
        
        locationTextField.text = name
    }
}
