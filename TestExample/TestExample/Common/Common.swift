//
//  Common.swift
//  WakeUpOnLan
//
//  Created by Nguyễn Tất Hùng on 5/11/16.
//  Copyright © 2016 Nguyễn Tất Hùng. All rights reserved.
//

import UIKit
import CoreData

class Common: NSObject {
    class func loadListTask() -> [AnyObject]{
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext as NSManagedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskInfo")
        
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: false)
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var result = [AnyObject]()
        do {
            result = try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError{
            NSLog("My Error: %@", error)
        }
        return result
    }
    class func removeTask(_ object:NSManagedObject){
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext as NSManagedObjectContext
        managedObjectContext.delete(object)
        do {
           try managedObjectContext.save()
        } catch let error as NSError{
            NSLog("My Error: %@", error)
        }
    }
    class func showAlert(_ title:String,message:String){
        let alertView = UIAlertView()
        alertView.addButton(withTitle: "Ok")
        alertView.title = title
        alertView.message = message
        alertView.show();
    }
    class func validateIp(_ ip:String)->Bool{
        let validIpAddressRegex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
        if ip.range(of: validIpAddressRegex, options: .regularExpression) != nil {
            return true
        }
        return false
    }
    class func getLabelHeight(_ text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        
        return label.frame.height
    }
}
extension UIView:UIAlertDelegate{
    func showAlertWithTitle(_ title:String,message:String,listTitles:[String]=["Đóng"],delegate:UIAlertDelegate?=nil){
        DispatchQueue.main.async(execute: {
            let messageView = UIAlert(frame: CGRect(x: 0,y: 0,width: 280,height: 150), title: title, message: message,listTitles:listTitles)
            messageView.center = CGPoint(x: self.frame.size.width/2 , y: self.frame.size.height/2)
            messageView.ground = UIView(frame:self.frame)
            messageView.ground.backgroundColor=UIColor.black
            messageView.ground.alpha=0.5
            self.addSubview(messageView.ground)
            self.addSubview(messageView)
            messageView.delegate=delegate
            messageView.ground.center = self.center
            messageView.center = self.center
            messageView.ground.addGestureRecognizer(UITapGestureRecognizer(target:messageView, action: #selector(messageView.closeView)))
        })
    }
    func actionClick(_ sender:AnyObject){
        print("UIAlertView Click")
    }
}
