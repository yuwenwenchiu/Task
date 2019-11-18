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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func saveRecord(_ sender: Any) {
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            record = RecordMO(context: appDelegate.persistentContainer.viewContext)
            
            record.recordID = UUID().uuidString
            record.recordeiType = Int16(recordeiSegmentedControl.selectedSegmentIndex)
            record.recordImage = recordImageButton.currentImage?.pngData()
            record.recordMoney = recordMoneyTextField.text
            record.recordDate = AddAccountingTableViewController?.recordDatePicker.date
            record.recordMethod = AddAccountingTableViewController?.recordMethodLabel.text
            record.recordCategory = AddAccountingTableViewController?.recordCategoryLabel.text
            record.recordRemarks = AddAccountingTableViewController?.recordRemarksTextField.text
            record.recordLocation = AddAccountingTableViewController?.recordLocationTextField.text
            
//            switch eiSegmentedControl.selectedSegmentIndex {
//
//            case 0:
//                record.eiType = 0
//                record.image = imageButton.currentImage?.pngData()
//                record.money = Int64((inputMoneyTextField.text! as NSString).integerValue)
//                record.date = AddAccountingTableViewController?.dateLabel.text
//                record.dateY = AddAccountingTableViewController?.dateY
//                record.dateM = AddAccountingTableViewController?.dateM
//                record.dateD = AddAccountingTableViewController?.dateD
//                record.method = AddAccountingTableViewController?.methodLabel.text
//                record.category = AddAccountingTableViewController?.categoryLabel.text
//                record.remarks = AddAccountingTableViewController?.remarksTextField.text
//                record.location = AddAccountingTableViewController?.locationTextField.text
//
//            case 1:
//                record.eiType = 1
//                record.image = imageButton.currentImage?.pngData()
//                record.money = Int64(inputMoneyTextField.text!)!
//                record.date = AddAccountingTableViewController?.dateLabel.text
//                record.dateY = AddAccountingTableViewController?.dateY
//                record.dateM = AddAccountingTableViewController?.dateM
//                record.dateD = AddAccountingTableViewController?.dateD
//                record.method = AddAccountingTableViewController?.methodLabel.text
//                record.category = AddAccountingTableViewController?.categoryLabel.text
//                record.remarks = AddAccountingTableViewController?.remarksTextField.text
//                record.location = AddAccountingTableViewController?.locationTextField.text
//
//            default:
//
//                break
//            }
            
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
    
//    @IBAction func eiChanged(_ sender: UISegmentedControl) {
//
//        AddAccountingTableViewController?.eiType = recordeiSegmentedControl.selectedSegmentIndex
//
//        switch recordeiSegmentedControl.selectedSegmentIndex {
//
//        case 0:
//            AddAccountingTableViewController?.recordMethodLabel.text = AddAccountingTableViewController?.eMethod[0]
//            AddAccountingTableViewController?.recordCategoryLabel.text = AddAccountingTableViewController?.eCategory[0]
//
//        case 1:
//            AddAccountingTableViewController?.recordMethodLabel.text = AddAccountingTableViewController?.iMethod[0]
//            AddAccountingTableViewController?.recordCategoryLabel.text = AddAccountingTableViewController?.iCategory[0]
//
//        default:
//            break
//        }
//
//        AddAccountingTableViewController?.recordMethodPicker.dataSource = AddAccountingTableViewController
//        AddAccountingTableViewController?.recordCategoryPicker.dataSource = AddAccountingTableViewController
//    }
//
//    @IBAction func selectedImage(_ sender: UIButton) {
//
//        let imageSourceAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        let cameraAction = UIAlertAction(title: "拍攝照片", style: .default) {
//            (action) in
//
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//
//                let imagePicker = UIImagePickerController()
//                imagePicker.allowsEditing = false
//                imagePicker.sourceType = .camera
//                imagePicker.delegate = self
//
//                self.present(imagePicker, animated: true, completion: nil)
//            }
//        }
//
//        let photoLibraryAction = UIAlertAction(title: "選擇圖片", style: .default) {
//            (action) in
//
//            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//
//                let imagePicker = UIImagePickerController()
//                imagePicker.allowsEditing = false
//                imagePicker.sourceType = .photoLibrary
//                imagePicker.delegate = self
//
//                self.present(imagePicker, animated: true, completion: nil)
//            }
//        }
//
//        imageSourceAlert.addAction(cameraAction)
//        imageSourceAlert.addAction(photoLibraryAction)
//
//        present(imageSourceAlert, animated: true, completion: nil)
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           
            recordImageButton.setImage(image, for: .normal)
            recordImageButton.contentMode = .scaleToFill
            recordImageButton.clipsToBounds = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
