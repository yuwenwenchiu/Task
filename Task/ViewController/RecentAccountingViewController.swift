//
//  RecentAccountingViewController.swift
//  Task
//
//  Created by Yuwen Chiu on 2019/10/7.
//  Copyright © 2019 YuwenChiu. All rights reserved.
//

import UIKit

class RecentAccountingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var recentAccountingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let headerXib = UINib(nibName: "RecentAccountingHeaderView", bundle: nil)
        recentAccountingTableView.register(headerXib, forHeaderFooterViewReuseIdentifier: "RecentAccountingHeaderView")
        
        let recentAccountingCellXib = UINib(nibName: "RecentAccountingTableViewCell", bundle: nil)
        recentAccountingTableView.register(recentAccountingCellXib, forCellReuseIdentifier: "recentAccountingCell")
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentAccountingCell", for: indexPath) as UITableViewCell
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
