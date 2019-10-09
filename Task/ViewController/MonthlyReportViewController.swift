//
//  MonthlyReportViewController.swift
//  Task
//
//  Created by Yuwen Chiu on 2019/10/7.
//  Copyright © 2019 YuwenChiu. All rights reserved.
//

import UIKit

class MonthlyReportViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var monthlyReportTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let incomeCellXib = UINib(nibName: "MonthlyReportIncomeCell", bundle: nil)
        monthlyReportTableView.register(incomeCellXib, forCellReuseIdentifier: "monthlyReportIncomeCell")
        
        let expensesCellXib = UINib(nibName: "MonthlyReportExpensesCell", bundle: nil)
               monthlyReportTableView.register(expensesCellXib, forCellReuseIdentifier: "monthlyReportExpensesCell")
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            
            return "收入"
        } else {
            
            return "支出"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let headerView: UITableViewHeaderFooterView
        headerView = view as! UITableViewHeaderFooterView
        headerView.backgroundView?.backgroundColor = .systemGray
        headerView.textLabel?.textColor = .white
        headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        headerView.textLabel?.textAlignment = .center
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
       return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
       return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 3
        } else {
            
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "monthlyReportIncomeCell", for: indexPath) as UITableViewCell
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "monthlyReportExpensesCell", for: indexPath) as UITableViewCell
            return cell
        }
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 62.5
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
