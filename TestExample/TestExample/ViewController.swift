//
//  ViewController.swift
//  TestExample
//
//  Created by Nguyễn Tất Hùng on 09/09/2024.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIAlertDelegate {
    private var taskListTableView: UITableView!
    private var timer = Timer()
    override func viewWillAppear(_ animated: Bool) {

        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .lightGray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.blue]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.blue]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.taskListTableView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {

        self.navigationController?.isNavigationBarHidden = true
        timer.invalidate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let barHeight: CGFloat = 50
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        taskListTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        taskListTableView.register(UINib(nibName: "TaskListTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskListTableViewCell")
        taskListTableView.dataSource = self
        taskListTableView.delegate = self
        self.view.addSubview(taskListTableView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Task List"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        titleLabel.textColor = .blue
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        DataSingleton.sharedInstance.dataShare[Constant.k_cellCanEdit]=false as AnyObject?
        self.navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add task", style: .plain, target: self, action: #selector(addTapped))
        
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { _ in
            self.checkRemainder()
        })
    }
    func checkRemainder(){
        for task in Common.loadListTask(){
            let t = task as! TaskInfo
            let today = Date()
            let remainDate = Calendar.current.date(byAdding: .day, value: 1, to: today)!
            if t.task_remainder && Calendar.current.isDate(t.task_date!, inSameDayAs: remainDate) {
                self.view.showAlertWithTitle("Task Notify", message: "Task " + t.task_name! + " dealine in 1 day",listTitles:["OK"],delegate: self)
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataSingleton.sharedInstance.dataShare[Constant.k_indexPath]=indexPath.row as AnyObject?
        self.view.showAlertWithTitle("Action Select",message:"please choose action",listTitles:["Update","Details","Cancel"],delegate:self)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Common.loadListTask().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListTableViewCell", for: indexPath as IndexPath) as! TaskListTableViewCell
        let task=Common.loadListTask()[indexPath.row] as! TaskInfo
        cell.taskName.text = task.task_name
        cell.taskDescript.text = task.task_descript
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss dd/MM/yyyy"
        cell.time.text = formatter.string(from: task.task_date ?? Date())
        if task.task_status?.intValue==0 {
            cell.taskName.textColor = UIColor.red
        }else{
            cell.taskName.textColor = UIColor.blue
        }
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPressGestureRecognized(_:)))
        cell.addGestureRecognizer(longpress)
        return cell
    }
    @objc func addTapped(){
        let myViewController = AddViewController(nibName: "AddViewController", bundle: nil)
        self.navigationController?.pushViewController(myViewController, animated: true)
    }
    func snapshopOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    // MARK: Gesture Methods
    @objc func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        
        let state = longPress.state
        
        let locationInView = longPress.location(in: taskListTableView)
        
        let indexPath = taskListTableView.indexPathForRow(at: locationInView)
        
        struct My {
            
            static var cellSnapshot : UIView? = nil
            
        }
        struct Path {
            
            static var initialIndexPath : IndexPath? = nil
            
        }
        struct firstPath {
            
            static var initialIndexPath : IndexPath? = nil
            
        }
        switch state {
        case UIGestureRecognizer.State.began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                firstPath.initialIndexPath = indexPath
                let cell = taskListTableView.cellForRow(at: indexPath!) as UITableViewCell?
                My.cellSnapshot  = snapshopOfCell(cell!)
                var center = cell?.center
                
                My.cellSnapshot!.center = center!
                My.cellSnapshot!.alpha = 0.0
                taskListTableView.addSubview(My.cellSnapshot!)
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.y = locationInView.y
                    My.cellSnapshot!.center = center!
                    My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell?.alpha = 0.0
                    }, completion: { (finished) -> Void in
                        if finished {
                            cell?.isHidden = true
                        }
                })
            }
            break
        case UIGestureRecognizer.State.changed:
            var center = My.cellSnapshot!.center
            center.y = locationInView.y
            My.cellSnapshot!.center = center
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                taskListTableView.moveRow(at: indexPath!, to:Path.initialIndexPath!)
                Path.initialIndexPath = indexPath
            }
            break
        default:
            if indexPath != nil{
                updateDataBase(fromIndex:firstPath.initialIndexPath!.row,toIndex:indexPath!.row )
            }else{
                updateDataBase(fromIndex:firstPath.initialIndexPath!.row,toIndex:Path.initialIndexPath!.row )
            }
            let cell = taskListTableView.cellForRow(at: Path.initialIndexPath!) as UITableViewCell?
            cell?.isHidden = false
            cell?.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                My.cellSnapshot!.center = (cell?.center)!
                My.cellSnapshot!.transform = CGAffineTransform.identity
                My.cellSnapshot!.alpha = 0.0
                cell?.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
            })
            break
            
        }//.switch
    }// .longPressGestureRecognized
    func updateDataBase(fromIndex index:Int,toIndex:Int){
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext as NSManagedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskInfo")
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let fetchedEntities = try managedObjectContext.fetch(fetchRequest) as! [TaskInfo]
            if index > toIndex {
                for i in toIndex...index-1 {
                    fetchedEntities[i].index = NSDecimalNumber(string:String(i + 2))
                    
                }
                fetchedEntities[index].index = NSDecimalNumber(string:String(toIndex + 1))
            }
            if index < toIndex {
                for i in index...toIndex-1 {
                    fetchedEntities[i+1].index = NSDecimalNumber(string:String(i+1))
                }
                fetchedEntities[index].index = NSDecimalNumber(string:String(toIndex+1))
            }
            try managedObjectContext.save()
        }catch let error as NSError{
            NSLog("My Error: %@", error)
        }
    }
    func actionClick(_ sender: AnyObject) {
        DataSingleton.sharedInstance.dataShare[Constant.k_cellCanEdit]=false as AnyObject?
        let button = sender as! UIButton
        if(button.titleLabel?.text=="Details"){
            let indexPath=DataSingleton.sharedInstance.dataShare[Constant.k_indexPath] as! Int
            let detailViewController = DetailViewController(nibName: "DetailViewController", bundle: nil)
            let task=Common.loadListTask()[indexPath] as! TaskInfo
            detailViewController.taskNameString = task.task_name
            detailViewController.taskDescString = task.task_descript
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss dd/MM/yyyy"
            let myString = formatter.string(from: task.task_date ?? Date())
            detailViewController.taskDateString = myString
            detailViewController.taskCategory = task.task_category?.intValue
            DataSingleton.sharedInstance.dataShare[Constant.k_cellCanEdit]=false as AnyObject?
            self.present(detailViewController, animated: true, completion: nil)
        }
        if(button.titleLabel?.text=="Update"){
            let indexPath=DataSingleton.sharedInstance.dataShare[Constant.k_indexPath] as! Int
            let myViewController = AddViewController(nibName: "AddViewController", bundle: nil)
            let task=Common.loadListTask()[indexPath] as! TaskInfo
            myViewController.taskNameString = task.task_name
            myViewController.taskDescString = task.task_descript
            myViewController.taskStatus = task.task_status?.intValue
            myViewController.taskCategory = task.task_category?.intValue
            myViewController.taskRemainder = task.task_remainder
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss dd/MM/yyyy"
            let myString = formatter.string(from: task.task_date ?? Date())
            myViewController.taskDateString = myString
            DataSingleton.sharedInstance.dataShare[Constant.k_cellCanEdit]=true as AnyObject?
            self.navigationController?.pushViewController(myViewController, animated: true)
        }
    }
}
