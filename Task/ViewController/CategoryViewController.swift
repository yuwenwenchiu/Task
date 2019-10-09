//
//  CategoryViewController.swift
//  Task
//
//  Created by Yuwen Chiu on 2019/10/8.
//  Copyright © 2019 YuwenChiu. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addCategoryButton(_ sender: UIBarButtonItem) {
        
        popUpAlert()
    }
    
    func popUpAlert() {
    
    //func popUpAlert(itemText: String?, indexPath: IndexPath?) {
        
        let alertTitle: String = "新增類別"
        
//        if itemText == nil {
//            alertTitle = "新增類別"
//        } else {
//            alertTitle = "修改類別"
//        }
        
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            (inputTextField: UITextField) in
            inputTextField.placeholder = "請輸入類別名稱"
            //inputTextField.text = itemText
        })
        
        let okAction = UIAlertAction(title: "確認", style: .default, handler: nil) //{
//            // 按下 OK 之後要執行的動作
//            (okAction: UIAlertAction) in
//
//            // 如果可以取得 textField 的值
//            if let inputText = alert.textFields?[0].text {
//
//                // 新增的情況
//                if itemText == nil {
//
//                    self.shoppingItems.append(Item(itemName: inputText, done: false))
//                    self.tableView.insertRows(at: [IndexPath(row: self.shoppingItems.count - 1, section: 0)], with: .automatic)
//                    self.saveList()
//
//                    // 修改的情況
//                } else {
//
//                    self.shoppingItems[indexPath!.row].itemName = inputText
//                    self.saveList()
//                    self.tableView.reloadData()
//
//                }
//            }
//        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
