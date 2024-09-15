//
//  DetailViewController.swift
//  TestExample
//
//  Created by Nguyễn Tất Hùng on 10/09/2024.
//

import UIKit
import FSCalendar

class DetailViewController: UIViewController , FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance {

    @IBOutlet weak var task_name: UILabel!
    @IBOutlet weak var task_descript: UITextView!
    @IBOutlet weak var dealine: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var category: UISegmentedControl!
    var taskNameString:String!
    var taskDescString:String!
    var taskDateString:String!
    var taskCategory:Int!
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    var datesWithEvent=[""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        task_name.text = taskNameString
        task_descript.text = taskDescString
        dealine.text = taskDateString
        task_descript.isEditable = false
        category.selectedSegmentIndex = taskCategory
        category.isEnabled = false
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.appearance.headerTitleColor = .blue
        calendar.appearance.weekdayTextColor = .red
        calendar.appearance.selectionColor = .green
        calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
        for t in Common.loadListTask() {
            let task = t as! TaskInfo
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let myString = formatter.string(from: task.task_date ?? Date())
            print(myString)
            datesWithEvent.append(myString)
        }
    }
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 3
        }
        return 0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let key = self.dateFormatter.string(from: date)
        if self.datesWithEvent.contains(key) {
            return [UIColor.magenta, appearance.eventDefaultColor, UIColor.black]
        }
        return nil
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor.blue
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        return appearance.borderDefaultColor
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        return appearance.borderSelectionColor
    }
}
