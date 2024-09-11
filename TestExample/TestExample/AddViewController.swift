//
//  AddViewController.swift
//  TestExample
//
//  Created by Nguyễn Tất Hùng on 10/09/2024.
//

import UIKit
import CoreData
class AddViewController: UIViewController,UIAlertDelegate{
    @IBOutlet weak var task_name: UITextField!
    @IBOutlet weak var descript: UITextField!
    @IBOutlet weak var task_date: UIDatePicker!
    @IBOutlet weak var status: UISegmentedControl!
    @IBOutlet weak var category: UISegmentedControl!
    @IBOutlet weak var remainder: UISwitch!
    var taskNameString:String!
    var taskDescString:String!
    var taskDateString:String!
    var taskStatus:Int!
    var taskCategory:Int!
    var taskRemainder:Bool!
    var managedObjectContext: NSManagedObjectContext!
    var fetchedEntities:[TaskInfo]!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext as NSManagedObjectContext
        let canEdit=DataSingleton.sharedInstance.dataShare[Constant.k_cellCanEdit] as! Bool
        if canEdit {
            task_name.text = taskNameString
            descript.text = taskDescString
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss dd/MM/yyyy"
            task_date.date = formatter.date(from: taskDateString) ?? Date()
            self.status.selectedSegmentIndex = taskStatus
            self.category.selectedSegmentIndex = taskCategory
            self.remainder.setOn(taskRemainder, animated: false)
        }
    }
    @IBAction func addNewTask(_ sender: Any) {
        let canEdit=DataSingleton.sharedInstance.dataShare[Constant.k_cellCanEdit] as! Bool
        if canEdit == false {
            let task: TaskInfo = NSEntityDescription.insertNewObject (forEntityName: "TaskInfo", into:managedObjectContext) as! TaskInfo
            
            let index = Common.loadListTask().count
            
            task.task_name = task_name.text
            task.task_descript = descript.text
            task.task_date = task_date.date
            task.task_status = NSDecimalNumber(decimal: Decimal(status.selectedSegmentIndex))
            task.task_category = NSDecimalNumber(decimal: Decimal(category.selectedSegmentIndex))
            task.task_remainder = remainder.isOn
            task.index = NSDecimalNumber(string:String(index))
            do {
                try managedObjectContext.save()
            } catch let error as NSError{
                NSLog("My Error: %@", error)
            }
        }else{
            let index = DataSingleton.sharedInstance.dataShare[Constant.k_indexPath] as! Int
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedObjectContext = appDelegate.managedObjectContext as NSManagedObjectContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskInfo")
            let sortDescriptor = NSSortDescriptor(key: "index", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            do {
                fetchedEntities = try (managedObjectContext.fetch(fetchRequest) as? [TaskInfo])
                fetchedEntities[index].task_name = task_name.text
                fetchedEntities[index].task_descript = descript.text
                fetchedEntities[index].task_date = task_date.date
                fetchedEntities[index].task_status = NSDecimalNumber(decimal: Decimal(status.selectedSegmentIndex))
                fetchedEntities[index].task_category = NSDecimalNumber(decimal: Decimal(category.selectedSegmentIndex))
                fetchedEntities[index].task_remainder = remainder.isOn
                try managedObjectContext.save()
            } catch let error as NSError{
                NSLog("My Error: %@", error)
            }
        }
        self.view.showAlertWithTitle("Information",message:"completed",listTitles:["OK"],delegate:self);
        
    }
    func actionClick(_ sender:AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
}

