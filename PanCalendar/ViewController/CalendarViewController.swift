//
//  ViewController.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 30/04/2022.
//

import UIKit
import CoreData

enum SectionType: Int {
    case weekdaySection = 0
    case dateSection = 1
}

class CalendarViewController: UIViewController {
    
    static let dayOfWeeks = 7
    
    var dates = [DateTimeModel]()
    var weekdays = [String]()
    var chosenItem: IndexPath?
    var chosenDate: Date?
    
    @IBOutlet weak var addButton: PHighlightButton!
    
    @IBOutlet weak var calendarViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var datePickerView: UIView!
    
    @IBOutlet weak var calendarView: UICollectionView!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var eventTableView: UITableView!
    
    var dateTimeManager = DateTimeManager(currentDate: Date())
    
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.register(CalendarCollectionViewCell.nib(), forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        calendarView.register(CalendarFooterReusableView.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CalendarFooterReusableView.identifier)
        eventTableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        dates = dateTimeManager.dates
        monthLabel.text = dateTimeManager.currentMonthText
        weekdays = Calendar(identifier: .iso8601).weekdaySymbols.map { $0.uppercased() }
        
        calendarView.addGestureRecognizer(createSwipeGestureRecognizer(for: .left))
        calendarView.addGestureRecognizer(createSwipeGestureRecognizer(for: .right))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        events = EventManager.shared.loadEvents(by: Date())
        eventTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetHeightCalendar()
    }
    
    func reloadData() {
        dates = dateTimeManager.dates
        calendarView.reloadSections(IndexSet(integer: SectionType.dateSection.rawValue))
        events = EventManager.shared.loadEvents(by: dateTimeManager.currentDate)
        eventTableView.reloadData()
        monthLabel.text = dateTimeManager.currentMonthText
        resetHeightCalendar()
    }
    
    func resetHeightCalendar() {
        let height = calendarView.collectionViewLayout.collectionViewContentSize.height
        calendarViewHeight.constant = height
        self.view.setNeedsLayout()
    }
    
    private func createSwipeGestureRecognizer(for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureRecognizer.direction = direction
        
        return swipeGestureRecognizer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddEvent" {
//            print("abcdd")
        }
    }
    
    //MARK: - Action Handler
    @IBAction func pressSearch(_ sender: UIButton) {
        showDatePickerView(hidden: false)
    }
    
    @IBAction func pressCancelDatePicker(_ sender: UIBarButtonItem) {
        showDatePickerView(hidden: true)
    }
    
    @IBAction func pressDoneDatePicker(_ sender: UIBarButtonItem) {
        let pickedDate = datePicker.date
        dateTimeManager = DateTimeManager(currentDate: pickedDate)
        chosenDate = pickedDate
        chosenItem = nil
        reloadData()
        showDatePickerView(hidden: true)
        monthLabel.text = Common.convertDate(pickedDate, with: .dateFormat)
    }
    
    func showDatePickerView(hidden: Bool) {
        UIView.transition(with: datePickerView, duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: {
            self.datePickerView.isHidden = hidden
        })
        if hidden {
            datePicker.date = Date()
        }
    }
    
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            dateTimeManager = dateTimeManager.getPreviousMonth()
        } else {
            dateTimeManager = dateTimeManager.getNextMonth()
        }
        setVarToDefaultWhenChangeMonthCalendar()
        reloadData()
    }
    
    @IBAction func today(_ sender: UIButton) {
        dateTimeManager = DateTimeManager(currentDate: Date())
        setVarToDefaultWhenChangeMonthCalendar()
        reloadData()
        showDatePickerView(hidden: true)
    }
    
    func setVarToDefaultWhenChangeMonthCalendar() {
        chosenItem = nil
        chosenDate = nil
    }
}

//MARK: - UICollectionViewDelegate

extension CalendarViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == SectionType.dateSection.rawValue {
            let currentDate = dates[indexPath.row].currentDate
            monthLabel.text = Common.convertDate(currentDate, with: .dateFormat)
            if let chosenItem = chosenItem {
                let lastChosenCell = calendarView.cellForItem(at: chosenItem) as! CalendarCollectionViewCell
                lastChosenCell.type = dates[chosenItem.row].isToday ? .today : .date
            }
            chosenItem = indexPath
            let chosenCell = calendarView.cellForItem(at: indexPath) as? CalendarCollectionViewCell
            chosenCell?.type = .chosen
            events = EventManager.shared.loadEvents(by: currentDate)
            eventTableView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}

//MARK: - UICollectionViewDataSource

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == SectionType.dateSection.rawValue {
            return dates.count
        }
        return CalendarViewController.dayOfWeeks
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as! CalendarCollectionViewCell
        if indexPath.section == SectionType.dateSection.rawValue {
            let currentDateModel = dates[indexPath.row]
            cell.configure(with: String(currentDateModel.shortDateLabel))
            if !dateTimeManager.isSameMonth(with: currentDateModel) {
                cell.type = .disabled
            } else if currentDateModel.isToday {
                cell.type = .today
            } else if currentDateModel.isSame(chosenDate) {
                cell.type = .chosen
                chosenItem = indexPath
            } else {
                cell.type = .date
            }
        } else {
            cell.contentLabel.text = weekdays[indexPath.row]
            cell.type = .weekday
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let calendarWidth = calendarView.frame.width
        let dateViewWidth = calendarWidth / Double(CalendarViewController.dayOfWeeks) - 1.0
        return CGSize(width: dateViewWidth, height: dateViewWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CalendarFooterReusableView.identifier, for: indexPath) as! CalendarFooterReusableView
        
        footer.configure()
        
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == SectionType.dateSection.rawValue {
            return CGSize(width: calendarView.frame.width, height: 16)
        }
        return CGSize(width: calendarView.frame.width, height: 1)
    }
}

//MARK: - UITableViewDataSource

extension CalendarViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
        
        let eventIndex = events[indexPath.row]
        cell.configUI(with: eventIndex)
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension CalendarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.init(rgb: 0x39393A, a: 0.75)
        header.textLabel?.font = UIFont(name: "Gill Sans", size: 20.0)
        header.textLabel?.textAlignment = .left
        var text = "Today"
        if let chosenItem = chosenItem {
            if !dates[chosenItem.row].isToday {
                text = dates[chosenItem.row].longDateLabel
            }
            
        } else if let chosenDate = chosenDate {
            if !Calendar.current.isDateInToday(chosenDate) {
                text = Common.convertDate(chosenDate, with: .dateFormat)
            }
        }
        header.textLabel?.text = "\(text) 's events"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
}
