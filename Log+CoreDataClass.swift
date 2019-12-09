//
//  Log+CoreDataClass.swift
//  Travelogue
//
//  Created by Carmel Braga on 12/7/19.
//  Copyright © 2019 Carmel Braga. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Log)
public class Log: NSManagedObject {
var rawDate: Date? {
        get {
            return date as Date?
        }
        set {
            date = newValue as NSDate?
        }
    }
    
    var rawImage: UIImage? {
        get {
            if let imageData = media as Data? {
                return UIImage(data: imageData)
            } else {
                return nil
            }
        }
        set {
            if let rawImage = newValue {
                media = convertImageToNSData(media: rawImage)
            }
        }
    }
    
convenience init?(title: String?, entry: String?, caption: String?, date: Date, media: UIImage?, trip: Trip) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext,
            let title = title, title != "" else {
                return nil
        }
        
        self.init(entity: Log.entity(), insertInto: managedContext)
        
        self.title = title
        self.entry = entry
        self.caption = caption
        self.rawDate = date
        self.trip = trip
        if let media = media {
            self.media = convertImageToNSData(media: media)
        }
    }
    
    func convertImageToNSData(media: UIImage) -> NSData? {
        return processImage(media: media).pngData() as NSData?
    }
    
    func processImage(media: UIImage) -> UIImage {
        if (media.imageOrientation == .up) {
            return media
        }
        
        UIGraphicsBeginImageContext(media.size)
        
        media.draw(in: CGRect(origin: CGPoint.zero, size: media.size), blendMode: .copy, alpha: 1.0)
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        guard let unwrappedCopy = copy else {
            return media
        }
        
        return unwrappedCopy
    }
    
    func update(title: String?, entry: String?, caption: String?, date: Date, media: UIImage?, trip: Trip) {
           self.title = title
                 self.entry = entry
                 self.caption = caption
                 self.rawDate = date
                 self.trip = trip
                 if let media = media {
                     self.media = convertImageToNSData(media: media)
                 }
       }
    
}
