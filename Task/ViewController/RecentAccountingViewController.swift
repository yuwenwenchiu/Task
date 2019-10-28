//
//  RecentAccountingViewController.swift
//  Task
//
//  Created by Yuwen Chiu on 2019/10/7.
//  Copyright © 2019 YuwenChiu. All rights reserved.
//

import UIKit
import CoreData

class RecentAccountingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    var fetchResultController: NSFetchedResultsController<RecordMO>!
    
    var records: [RecordMO] = []
    
    @IBOutlet weak var recentAccountingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 從資料儲存區中讀取資料
        let fetchRequest: NSFetchRequest<RecordMO> = RecordMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                
                try fetchResultController.performFetch()
                
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    
                    records = fetchedObjects
                }
            } catch {
                
                print("讀取資料錯誤訊息：\(error)")
            }
        }
        
        let headerXib = UINib(nibName: "RecentAccountingHeaderView", bundle: nil)
        recentAccountingTableView.register(headerXib, forHeaderFooterViewReuseIdentifier: "RecentAccountingHeaderView")
        
        let recentAccountingCellXib = UINib(nibName: "RecentAccountingTableViewCell", bundle: nil)
        recentAccountingTableView.register(recentAccountingCellXib, forCellReuseIdentifier: "recentAccountingCell")
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentAccountingCell", for: indexPath) as! RecentAccountingTableViewCell
        cell.recordImage.image = UIImage(data: records[indexPath.row].image!)
        cell.recordCategory.text = records[indexPath.row].category
        cell.recordRemarks.text = records[indexPath.row].remarks == "" ? "備註" : records[indexPath.row].remarks
        cell.recordLocation.text = records[indexPath.row].location == "" ? "地點" : records[indexPath.row].location
        cell.recordMethod.text = records[indexPath.row].method
        cell.recordMoney.text = String(records[indexPath.row].money)
                
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 100
    }
    
    //MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RecentAccountingHeaderView")
        headerView?.contentView.backgroundColor = .systemGray
        
        return headerView
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
        
        recentAccountingTableView.beginUpdates()
    }
    
    // 有任何的內容改變會自動被呼叫
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        
        case .insert:
            if let newIndexPath = newIndexPath {
                recentAccountingTableView.insertRows(at: [newIndexPath], with: .fade)
            }
            
        case .delete:
            if let indexPath = indexPath {
                recentAccountingTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        case .update:
            if let indexPath = indexPath {
                recentAccountingTableView.reloadRows(at: [indexPath], with: .fade)
            }
            
        default:
            recentAccountingTableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            
            records = fetchedObjects as! [RecordMO]
        }
    }
    
    // 完成內容更變時會被呼叫
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        recentAccountingTableView.endUpdates()
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
