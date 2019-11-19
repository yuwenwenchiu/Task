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
    
    //var records: [RecordMO] = []
    
    var records: [String:[RecordMO]] = [:]
    var recordKey: [String] = []
    var recordValue: [RecordMO] = []
    
    let dataImage = UIImage(systemName: "photo")?.withTintColor(.link).pngData()
    
    let formatter = DateFormatter()
    
    @IBOutlet weak var recentAccountingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "yyyy-MM-dd"

        // 從資料儲存區中讀取資料
        let fetchRequest: NSFetchRequest<RecordMO> = RecordMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "recordDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // 取得AppDelegate物件
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                
                try fetchResultController.performFetch()
                
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    
                    //records = fetchedObjects
                    
                    for record in fetchedObjects {
                        
                        if let date = record.recordDate {
                            
                            recordKey.append(formatter.string(from: date))
                        }
                    }
                    recordKey = Array(Set(recordKey))
                    print("日期： \(recordKey)")
                    
                    for date in recordKey {
                        
                        recordValue = []
                        
                        for record in fetchedObjects {
                            
                            if date == formatter.string(from: record.recordDate!) {
                                
                                recordValue.append(record)
                            }
                        }
                        records[date] = recordValue
                    }
                    print("得到的東西：\(records)")
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
        
        return records.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        let date = recordKey[section]
        guard let rowsInSection = records[date] else { return 0 }
        
        // testRecords[recordDate[section]]!.count
        
        return rowsInSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentAccountingCell", for: indexPath) as! RecentAccountingTableViewCell
        
        cell.recordImage.image = UIImage(data: records[recordKey[indexPath.section]]?[indexPath.row].recordImage ?? dataImage!)
        cell.recordCategory.text = records[recordKey[indexPath.section]]?[indexPath.row].recordCategory
        cell.recordRemarks.text = records[recordKey[indexPath.section]]?[indexPath.row].recordRemarks == "" ? "備註" : records[recordKey[indexPath.section]]?[indexPath.row].recordRemarks
        cell.recordLocation.text = records[recordKey[indexPath.section]]?[indexPath.row].recordLocation == "" ? "地點" : records[recordKey[indexPath.section]]?[indexPath.row].recordLocation
        cell.recordMethod.text = records[recordKey[indexPath.section]]?[indexPath.row].recordMethod
        cell.recordMoney.text = records[recordKey[indexPath.section]]?[indexPath.row].recordMoney
                
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
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RecentAccountingHeaderView") as! RecentAccountingHeaderView
        headerView.contentView.backgroundColor = .systemGray
        headerView.dateLabel.text = recordKey[section]
        
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
            
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddAccountingPage") as? AddAccountingViewController {

                controller.record = self.records[self.recordKey[indexPath.section]]?[indexPath.row]
                self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
            }
                    
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
        
//        if let fetchedObjects = controller.fetchedObjects {
//
//            records = fetchedObjects as! [RecordMO]
//        }
        
        if let fetchedObjects = controller.fetchedObjects {
            
            for record in (fetchedObjects as! [RecordMO]) {
                
                if let date = record.recordDate {
                    
                    recordKey.append(formatter.string(from: date))
                }
            }
            recordKey = Array(Set(recordKey))
            
            for date in recordKey {
                
                recordValue = []
                
                for record in (fetchedObjects as! [RecordMO]) {
                    
                    if date == formatter.string(from: record.recordDate!) {
                        
                        recordValue.append(record)
                    }
                }
                records[date] = recordValue
            }
        }
    }
    
    // 完成內容更變時會被呼叫
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        recentAccountingTableView.endUpdates()
    }

}
