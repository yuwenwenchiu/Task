//
//  BudgetViewController.swift
//  Task
//
//  Created by Yuwen Chiu on 2019/10/8.
//  Copyright © 2019 YuwenChiu. All rights reserved.
//

import UIKit

class BudgetViewController: UIViewController {
    
    @IBOutlet weak var budgetTextField: UITextField!
    
    var BudgetTableViewController: BudgetTableViewController?
    
    var budget: BudgetMO!
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        if budget != nil {
            
            budgetTextField.text = budget.budgetMoney
            BudgetTableViewController?.budgetNameTextField.text = budget.budgetName
            BudgetTableViewController?.budgetDateLabel.text = formatter.string(from: budget.budgetDate ?? Date())
            BudgetTableViewController?.budgetDatePicker.date = budget.budgetDate ?? Date()
            BudgetTableViewController?.monthlyDepositLabel.text = budget.budgetDeposit
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        
        budgetTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "budgetInfo"{
            
            BudgetTableViewController = segue.destination as? BudgetTableViewController
        }
    }
    
    @IBAction func saveBudget(_ sender: UIBarButtonItem) {
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            budget = BudgetMO(context: appDelegate.persistentContainer.viewContext)
            
            budget.budgetID = UUID().uuidString
            budget.budgetMoney = budgetTextField.text
            budget.budgetName = BudgetTableViewController?.budgetNameTextField.text
            budget.budgetDate = BudgetTableViewController?.budgetDatePicker.date
            budget.budgetDeposit = BudgetTableViewController?.monthlyDepositLabel.text
            
            appDelegate.saveContext()
            print("心願儲存中...")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func inputBudget(_ sender: UITextField) {
        
        BudgetTableViewController?.monthlyDepositLabel.text = "$ " + "\(budgetTextField.text ?? String(0))"
        BudgetTableViewController?.budgetMoney = Int(budgetTextField.text ?? String(0))
        print("儲蓄心願的目標金額：\(String(describing: BudgetTableViewController?.budgetMoney))")
    }
    
}
