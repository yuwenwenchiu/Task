//
//  BudgetTableViewController.swift
//  Task
//
//  Created by Yuwen Chiu on 2019/10/7.
//  Copyright © 2019 YuwenChiu. All rights reserved.
//

import UIKit

class BudgetTableViewController: UITableViewController {
    
    @IBOutlet weak var budgetNameTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var budgetDatePicker: UIDatePicker!
    @IBOutlet weak var monthlyDepositLabel: UILabel!
    
    // 儲蓄心願的目標金額
    var budgetMoney: Int?
    
    let formatterY = DateFormatter()
    var dateY: String!
    let formatterM = DateFormatter()
    var dateM: String!
    let formatterD = DateFormatter()
    var dateD: String!
    let today = Date()
    
    // Picker的顯示狀態
    var isDatePickerShown = false

    // 包含Picker的Cell位置
    let datePickerCellIndexPath = IndexPath(row: 2, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formatterY.dateFormat = "yyyy"
        dateY = formatterY.string(from: Date())
        formatterM.dateFormat = "MM"
        dateM = formatterM.string(from: Date())
        formatterD.dateFormat = "dd"
        dateD = formatterD.string(from: Date())
        dateLabel.text = dateY + "-" + dateM + "-" + dateD
    }
    
    @IBAction func dateValueChanged(_ sender: UIDatePicker) {
        
        dateY = formatterY.string(from: sender.date)
        dateM = formatterM.string(from: sender.date)
        dateD = formatterD.string(from: sender.date)
        dateLabel.text = dateY + "-" + dateM + "-" + dateD
        
        // 今天和儲蓄心願的日期差距
        let diffDateComponents = Calendar.current.dateComponents([.day], from: today, to: budgetDatePicker.date)
        print("日期差距：\(diffDateComponents.day!)")
        
        // 每月應存金額 = 目標金額 / 日期差距 * 31
        let monthlyDeposit = budgetMoney! / diffDateComponents.day! * 31
        print("每月應存金額：\(monthlyDeposit)")
        
        monthlyDepositLabel.text = "$ \(monthlyDeposit)"
    }
    
    @IBAction func closeBudgetNameKeyboard(_ sender: UITextField) {
        
    }
    
    @IBAction func monthlyReminder(_ sender: UISwitch) {
        
        if sender.isOn {
            
            // 建立通知內容的物件
            let reminderContent = UNMutableNotificationContent()
            reminderContent.title = "每月儲蓄進度提醒"
            reminderContent.body = ""
            
            let triggerMonthly = Calendar.current.dateComponents([.month], from: today, to: budgetDatePicker.date)
            let reminderTrigger = UNCalendarNotificationTrigger(dateMatching: triggerMonthly, repeats: false)
            let request = UNNotificationRequest(identifier: "notification", content: reminderContent, trigger: reminderTrigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                
                print("成功建立通知...")
            }
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
 
        return 5
    }

    // 選擇列後要做什麼？依據位置展開包含DatePicker的Cell，並且修改DatePicker的顯示狀態、更新tableView
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
            
        default:
            break
        }
    }

    // 每列的高度？依據不同位置、DatePicker的顯示狀態，回傳相應的高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath {
            
        case datePickerCellIndexPath:
            if isDatePickerShown == true {
                return 215
            } else {
                return 0
            }
            
        default:
            return 62.5
        }
    }
    
}
