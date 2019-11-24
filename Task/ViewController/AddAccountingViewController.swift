//
//  AddAccountingViewController.swift
//  Task
//
//  Created by Yuwen Chiu on 2019/10/7.
//  Copyright © 2019 YuwenChiu. All rights reserved.
//

import UIKit
import CoreData

class AddAccountingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var recordeiSegmentedControl: UISegmentedControl!
    @IBOutlet weak var recordImageButton: UIButton!
    @IBOutlet weak var recordMoneyTextField: UITextField!
    
    var record: RecordMO!
    
    var AddAccountingTableViewController: AddAccountingTableViewController?
    
    let dataImage = UIImage(systemName: "photo")?.withTintColor(.link).pngData()
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        if record != nil {
            
            recordeiSegmentedControl.selectedSegmentIndex = Int(record.recordeiType)
            recordImageButton.setImage(UIImage(data: record.recordImage ?? dataImage!), for: .normal)
            recordMoneyTextField.text = record.recordMoney
            AddAccountingTableViewController?.recordDateLabel.text = formatter.string(from: record.recordDate ?? Date())
            AddAccountingTableViewController?.recordDatePicker.date = record.recordDate ?? Date()
            AddAccountingTableViewController?.recordMethodLabel.text = record.recordMethod
            AddAccountingTableViewController?.recordCategoryLabel.text = record.recordCategory
            AddAccountingTableViewController?.recordRemarksTextField.text = record.recordRemarks
            AddAccountingTableViewController?.recordLocationTextField.text = record.recordLocation
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        
        recordMoneyTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "moreInfo"{
            
            AddAccountingTableViewController = segue.destination as? AddAccountingTableViewController
        }
    }
    
    @IBAction func backToPrevious(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveRecord(_ sender: Any) {
        
        formatter.timeZone = TimeZone.init(identifier: "UTC")
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            record = RecordMO(context: appDelegate.persistentContainer.viewContext)
            
            record.recordID = UUID().uuidString
            record.recordeiType = Int16(recordeiSegmentedControl.selectedSegmentIndex)
            record.recordImage = recordImageButton.currentImage?.pngData()
            record.recordMoney = recordMoneyTextField.text
            record.recordDate = formatter.date(from: (AddAccountingTableViewController?.recordDateLabel.text)!)
            record.recordMethod = AddAccountingTableViewController?.recordMethodLabel.text
            record.recordCategory = AddAccountingTableViewController?.recordCategoryLabel.text
            record.recordRemarks = AddAccountingTableViewController?.recordRemarksTextField.text == "" ? "備註" : AddAccountingTableViewController?.recordRemarksTextField.text
            record.recordLocation = AddAccountingTableViewController?.recordLocationTextField.text == "" ? "地點" : AddAccountingTableViewController?.recordLocationTextField.text
            
            appDelegate.saveContext()
            print("帳務儲存中...")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recordeiTypeChaged(_ sender: UISegmentedControl) {
        
        AddAccountingTableViewController?.eiType = recordeiSegmentedControl.selectedSegmentIndex
        
        switch recordeiSegmentedControl.selectedSegmentIndex {
            
        case 0:
            AddAccountingTableViewController?.recordMethodLabel.text = AddAccountingTableViewController?.eMethod[0]
            AddAccountingTableViewController?.recordCategoryLabel.text = AddAccountingTableViewController?.eCategory[0]
            
        case 1:
            AddAccountingTableViewController?.recordMethodLabel.text = AddAccountingTableViewController?.iMethod[0]
            AddAccountingTableViewController?.recordCategoryLabel.text = AddAccountingTableViewController?.iCategory[0]
            
        default:
            break
        }
        
        AddAccountingTableViewController?.recordMethodPicker.dataSource = AddAccountingTableViewController
        AddAccountingTableViewController?.recordCategoryPicker.dataSource = AddAccountingTableViewController
    }
    
    @IBAction func recordImageSelected(_ sender: UIButton) {
        
        let imageSourceAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "拍攝照片", style: .default) {
            (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let photoLibraryAction = UIAlertAction(title: "選擇圖片", style: .default) {
            (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        imageSourceAlert.addAction(cameraAction)
        imageSourceAlert.addAction(photoLibraryAction)
        
        present(imageSourceAlert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           
            recordImageButton.setImage(image, for: .normal)
            recordImageButton.contentMode = .scaleToFill
            recordImageButton.clipsToBounds = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
