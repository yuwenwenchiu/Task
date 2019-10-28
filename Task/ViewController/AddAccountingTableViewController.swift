//
//  AddAccountingTableViewController.swift
//  Task
//
//  Created by Yuwen Chiu on 2019/10/8.
//  Copyright © 2019 YuwenChiu. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class AddAccountingTableViewController: UITableViewController, UIPickerViewDelegate,  UIPickerViewDataSource {
    
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
    
    var isDatePickerShown = false
    var isMethodPickerShown = false
    var isCategoryPickerShown = false
    
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
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "store"
        
        
        
    }
    
    // MARK: - Picker view data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        if pickerView.tag == 0 {
            
            if eiType == 0 {
                
                return eMethod.count
            } else {
                
                return iMethod.count
            }
        } else {
            
            if eiType == 0 {
                
                return eCategory.count
            } else {
                
                return iCategory.count
            }
        }
    }
    
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 0 {
            
            if eiType == 0 {
                
                methodLabel.text = eMethod[row]
            } else {
                
                methodLabel.text = iMethod[row]
            }
        } else {
            
            if eiType == 0 {
                
                categoryLabel.text = eCategory[row]
            } else {
                
                categoryLabel.text = iCategory[row]
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
        
        return 9
    }
    
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
    
    
    //     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    //
    //     // Configure the cell...
    //
    //     return cell
    //     }
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
