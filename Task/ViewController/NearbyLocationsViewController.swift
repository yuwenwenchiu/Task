//
//  NearbyLocationsViewController.swift
//  Task
//
//  Created by Yuwen Chiu on 2019/10/22.
//  Copyright © 2019 YuwenChiu. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class NearbyLocationsViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var locationsTableView: UITableView!
    
    var NearbyLocationsViewControllerDelegate: NearbyLocationsViewControllerDelegate?
    
    let locationManager = CLLocationManager()
    let searchQuerys = ["store", "shop", "coffee", "restaurant", "hospital"]
    var searchResults = [MKMapItem]()
    var searchAllResults = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationSearchBar.delegate = self
        locationsTableView.delegate = self
        locationsTableView.dataSource = self
        locationManager.delegate = self
        
        // 請求使用者授權定位服務
        locationManager.requestWhenInUseAuthorization()
        
        // 定位的精準度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 取得定位
        locationManager.requestLocation()
    }
    
    @IBAction func checkButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    // 取得使用者定位資料
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 確保didUpdateLocations只呼叫一次
        manager.delegate = nil
        
        let request = MKLocalSearch.Request()
        
        // 搜尋附近地點的範圍
        request.region = MKCoordinateRegion(center: locations[0].coordinate, latitudinalMeters: 50, longitudinalMeters: 50)
        
        for searchQuery in searchQuerys {
            
            // 搜尋附近地點類型的關鍵字(ex. store,hotel,coffee...)，place為所有類型
            request.naturalLanguageQuery = searchQuery
            
            let search = MKLocalSearch(request: request)
            
            // 搜尋附近地點的結果
            search.start { (response, error) in
                
                guard let searchResponse = response else {
                    
                    return
                }
                
                // 所有關鍵字得到的資料放入searchAllResults
                self.searchAllResults.append(contentsOf: searchResponse.mapItems)
                
                // 再把searchAllResults存入searchResults
                self.searchResults = self.searchAllResults
                
                self.locationsTableView.reloadData()
                
                //print("搜尋結果：\(self.searchResults)")
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("定位錯誤：\(error)")
    }
    
    // Table有幾列？回傳searchResults的數量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResults.count
    }
    
    // 每列顯示什麼？searchResults的地點名稱、地點地址
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! NearbyLocationsTableViewCell
        cell.locationNameLabel.text = searchResults[indexPath.row].name
        cell.locationAddressLabel.text = searchResults[indexPath.row].placemark.title
        
        return cell
    }
    
    // 選擇列後要做什麼？searchResults的地點名稱傳回上一個頁面，delegate傳資料
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let locationName = searchResults[indexPath.row].name else {
            
            return
        }
        
        NearbyLocationsViewControllerDelegate?.passLocationName(name: locationName)
        
        dismiss(animated: true, completion: nil)
    }
    
    // 每列的高度？
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 62.5
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // 當關鍵字有值時
        if searchText != "" {
            
            // 暫時存放匹配的地點資料
            var temp = [MKMapItem]()
            
            for result in searchResults {
                
                if (result.name?.lowercased().hasPrefix(searchText.lowercased()))! {
                    
                    temp.append(result)
                }
            }
            
            // 將searchResults清空後存入匹配的地點資料
            self.searchResults = []
            self.searchResults = temp
        
        // 當關鍵字為空時，存入所有使用者附近地點
        } else {
            
            searchResults = searchAllResults
        }
        
        locationsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        locationsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchResults = searchAllResults
        locationsTableView.reloadData()
    }
}

protocol NearbyLocationsViewControllerDelegate {
    
    func passLocationName(name: String)
}
