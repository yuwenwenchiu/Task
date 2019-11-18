//
//  HistoryViewController.swift
//  Task
//
//  Created by Yuwen Chiu on 2019/10/7.
//  Copyright © 2019 YuwenChiu. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var historyTableView: UITableView!
    
    var fetchResultController: NSFetchedResultsController<BudgetMO>!
    
    var budgets: [BudgetMO] = []
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 從資料儲存區中讀取資料
        let fetchRequest: NSFetchRequest<BudgetMO> = BudgetMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "budgetDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // 取得AppDelegate物件
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                
                try fetchResultController.performFetch()
                
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    
                    budgets = fetchedObjects
                }
            } catch {
                
                print("讀取資料錯誤訊息：\(error)")
            }
        }
        
        let historyCellXib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        historyTableView.register(historyCellXib, forCellReuseIdentifier: "historyCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return budgets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        formatter.dateFormat = "yyyyMMdd"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        cell.dateLabel.text = formatter.string(from: budgets[indexPath.row].budgetDate ?? Date())
        cell.nameLabel.text = budgets[indexPath.row].budgetName
        cell.moneyLabel.text = "$ " + (budgets[indexPath.row].budgetMoney ?? String(0))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 62.5
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "刪除") {
            (action, sourceView, completionHandler) in
            
            // 從資料儲存區刪除一列
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                
                let context = appDelegate.persistentContainer.viewContext
                context.delete(self.fetchResultController.object(at: indexPath))
                
                appDelegate.saveContext()
            }
            
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemYellow
        
        let editAction = UIContextualAction(style: .destructive, title: "編輯") {
            (action, sourceView, completionHandler) in
            
            completionHandler(true)
        }
        editAction.backgroundColor = .systemGray
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return swipeConfiguration
    }
    
    // 準備開始處理內容更變時會被呼叫
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        historyTableView.beginUpdates()
    }
    
    // 有任何的內容改變會自動被呼叫
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            let newIndexPath = IndexPath(row: 0, section: 0)
            historyTableView.insertRows(at: [newIndexPath], with: .fade)
            
        case .delete:
            if let indexPath = indexPath {
                historyTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        case .update:
            if let indexPath = indexPath {
                historyTableView.reloadRows(at: [indexPath], with: .fade)
            }
            
        default:
            historyTableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            
            budgets = fetchedObjects as! [BudgetMO]
        }
    }
    
    // 完成內容更變時會被呼叫
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        historyTableView.endUpdates()
    }
    
}
