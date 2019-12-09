//
//  NewLogViewController.swift
//  Travelogue
//
//  Created by Carmel Braga on 12/7/19.
//  Copyright © 2019 Carmel Braga. All rights reserved.
//

import UIKit

class NewLogViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var logTextView: UITextView!
    
        var log: Log?
        var trip: Trip?
        var media: UIImage?
        var date: Date?        
        let imagePickerController = UIImagePickerController()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            title = ""
            
            if let log = log {
                let name = log.title
                let caption = log.caption
                titleTextField.text = name
                captionTextField.text = caption
                logTextView.text = log.entry
                title = name
                datePicker.date = log.rawDate!
                media = log.rawImage
                imageView.image = media
            } else {
                titleTextField.text = ""
                captionTextField.text = ""
                logTextView.text = ""
                imageView.image = nil
            }
            
            date = datePicker.date
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func select() {
            let alert = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
                (alertAction) in
                self.camera()
            }))
            alert.addAction(UIAlertAction(title: "Library", style: .default, handler: {
                (alertAction) in
                self.library()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        func camera() {
            if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
                print("No camera detected.")
                return
            }
            
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            present(imagePickerController, animated: true)
        }
        
        func library() {
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            present(imagePickerController, animated: true)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            defer {
                imagePickerController.dismiss(animated: true, completion: nil)
            }
            
            guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                return
            }
            media = selectedImage
            imageView.image = media
            if let log = log {
                log.rawImage = selectedImage
            }
        }
        
        
        
    @IBAction func save(_ sender: Any) {
        guard let name = titleTextField.text else {
            print("Failed.")
            return
        }
        
        guard let caption = captionTextField.text else {
                   print("Failed.")
                   return
               }
        
        let logName = name.trimmingCharacters(in: .whitespaces)
        if (logName == "") {
            print("Name is required.")
            return
        }
        
        let entry = logTextView.text
        
        if log == nil {
            if let trip = trip {
                log = Log(title: logName, entry: entry, caption: caption, date: date ?? Date(timeIntervalSinceNow: 0), media: media, trip: trip)
            }
        } else {
            if let trip = trip {
                log?.update(title: logName, entry: entry, caption: caption, date: date!, media: media, trip: trip)
            }
        }
        
        if let log = log {
            do {
                let managedContext = log.managedObjectContext
                try managedContext?.save()
            } catch {
                print("Failed.")
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectImage(_ sender: Any) {
        select()
        
    }
    
}
