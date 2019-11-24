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
    
    // 建立讀取結果控制器
    var fetchResultController: NSFetchedResultsController<RecordMO>!
    
    var records: [RecordMO] = []
    
    let dataImage = UIImage(systemName: "photo")?.withTintColor(.link).pngData()
    
    @IBOutlet weak var recentAccountingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 從RecordMO取得NSFetchRequest
        let fetchRequest: NSFetchRequest<RecordMO> = RecordMO.fetchRequest()
        // 讀取出來的物件依照日期降序排列
        let sortDescriptor = NSSortDescriptor(key: "recordDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // 透過AppDelegate取得資料
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            // 建立ManagedObjectContext
            let context = appDelegate.persistentContainer.viewContext
            // 初始化fetchResultController，使用日期作為sectionNameKeyPath
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "recordDate", cacheName: nil)
            // 指定委派為自己來監控資料變化
            fetchResultController.delegate = self
            
            do {
                // 呼叫performFetch()執行讀取結果
                try fetchResultController.performFetch()
                
                // 存取fetchedObjects屬性取得RecordMO物件
                if let fetchedObjects = fetchResultController.fetchedObjects {
                   
                    records = fetchedObjects
                }
            } catch {
                
                print("讀取失敗的錯誤訊息：\(error)")
            }
        }
        
        let headerXib = UINib(nibName: "RecentAccountingHeaderView", bundle: nil)
        recentAccountingTableView.register(headerXib, forHeaderFooterViewReuseIdentifier: "RecentAccountingHeaderView")
        
        let recentAccountingCellXib = UINib(nibName: "RecentAccountingTableViewCell", bundle: nil)
        recentAccountingTableView.register(recentAccountingCellXib, forCellReuseIdentifier: "recentAccountingCell")
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchResultController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchResultController.sections![section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentAccountingCell", for: indexPath) as! RecentAccountingTableViewCell
        
        cell.recordImage.image = UIImage(data: fetchResultController.object(at: indexPath).recordImage ?? dataImage!)
        cell.recordCategory.text = fetchResultController.object(at: indexPath).recordCategory
        cell.recordRemarks.text = fetchResultController.object(at: indexPath).recordRemarks
        cell.recordLocation.text = fetchResultController.object(at: indexPath).recordLocation
        cell.recordMethod.text = fetchResultController.object(at: indexPath).recordMethod
        cell.recordMoney.text = "$ \(fetchResultController.object(at: indexPath).recordMoney!)"
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var sum = 0
        
        // 取得當前Section的所有object
        if let sectionObjects = fetchResultController.sections![section].objects {
            
            let objects = sectionObjects as! [RecordMO]
            
            // 計算所有object的金額總和
            for object in objects {
                
                sum += Int(object.recordMoney!)!
            }
        }
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RecentAccountingHeaderView") as! RecentAccountingHeaderView
        headerView.contentView.backgroundColor = .systemGray
        headerView.dateLabel.text = String(fetchResultController.sections![section].name.prefix(10))
        headerView.sumLabel.text = "$ \(sum)"
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 建立刪除動作
        let deleteAction = UIContextualAction(style: .normal, title: "刪除") {
            (action, sourceView, completionHandler) in
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                
                let context = appDelegate.persistentContainer.viewContext
                context.delete(self.fetchResultController.object(at: indexPath))
                // 呼叫saveContext()儲存更變
                appDelegate.saveContext()
            }
            
             completionHandler(true)
        }
        deleteAction.backgroundColor = .systemYellow
        
        // 建立編輯動作
        let editAction = UIContextualAction(style: .destructive, title: "編輯") {
            (action, sourceView, completionHandler) in
            
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddAccountingPage") as? AddAccountingViewController {

                controller.record = self.fetchResultController.object(at: indexPath)
                self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
            }
                    
            completionHandler(true)
        }
        editAction.backgroundColor = .systemGray
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return swipeConfiguration
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
    // 準備開始處理內容更變時會被呼叫
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        recentAccountingTableView.beginUpdates()
    }
    
    // 有任何的內容更變會自動被呼叫：Section
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
            
        case .insert:
            recentAccountingTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            
        case .delete:
            recentAccountingTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            
        default:
            break
        }
    }
    
    // 有任何的內容更變會自動被呼叫：Object
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
        
        // 讀取結果控制器更變後同步records的資料
        if let fetchedObjects = controller.fetchedObjects {
            
            records = fetchedObjects as! [RecordMO]
            print("最新的資料：\(records)")
        }
        recentAccountingTableView.reloadData()
    }
    
    // 完成內容更變時會被呼叫
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        recentAccountingTableView.endUpdates()
    }

}
