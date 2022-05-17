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
    var animator: Animator?
    var isShow = true
    
    var isChosenDate: Bool {
        return chosenItem != nil || chosenDate != nil
    }
    
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
        eventTableView.register(UINib(nibName: "GIFImageTableViewCell", bundle: nil), forCellReuseIdentifier: "GIFImageTableViewCell")
        eventTableView.register(CalendarTableViewHeader.self,
              forHeaderFooterViewReuseIdentifier: "sectionHeader")
       
        dates = dateTimeManager.dates
        weekdays = Calendar(identifier: .iso8601).weekdaySymbols.map { $0.uppercased() }
        
        calendarView.addGestureRecognizer(createSwipeGestureRecognizer(for: .left))
        calendarView.addGestureRecognizer(createSwipeGestureRecognizer(for: .right))
        
        monthLabel.text = dateTimeManager.currentMonthText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        var currentDate = Date()
        if let chosenItem = chosenItem {
            currentDate = dates[chosenItem.row].currentDate
        } else if let chosenDate = chosenDate {
            currentDate = chosenDate
        }
        events = EventManager.shared.loadEvents(by: currentDate, with: isChosenDate)
        eventTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetHeightCalendar()
    }
    
    private func reloadData() {
        dates = dateTimeManager.dates
        calendarView.reloadSections(IndexSet(integer: SectionType.dateSection.rawValue))
        events = EventManager.shared.loadEvents(by: dateTimeManager.currentDate, with: isChosenDate)
        eventTableView.reloadData()
        resetHeightCalendar()
    }
    
    private func resetHeightCalendar() {
        let height = calendarView.collectionViewLayout.collectionViewContentSize.height
        calendarViewHeight.constant = height
        self.view.setNeedsLayout()
    }
    
    private func createSwipeGestureRecognizer(for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureRecognizer.direction = direction
        
        return swipeGestureRecognizer
    }
    
    private func getTableHeaderContent() -> String {
        var currentDate: Date?
        if let chosenItem = chosenItem {
            currentDate = dates[chosenItem.row].currentDate
        } else if chosenDate != nil {
            currentDate = chosenDate
        }
        
        if let currentDate = currentDate {
            if Calendar.current.isDateInToday(currentDate) {
                return "Today"
            }
            return Common.convertDate(currentDate, with: .dateFormat)
        }
        return dateTimeManager.currentMonthText
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
        chosenItem = nil
        chosenDate = nil
        reloadData()
        monthLabel.text = dateTimeManager.currentMonthText
    }
    
    @IBAction func today(_ sender: UIButton) {
        dateTimeManager = DateTimeManager(currentDate: Date())
        chosenDate = Date()
        chosenItem = nil
        reloadData()
        monthLabel.text = Common.convertDate(Date(), with: .dateFormat)
        showDatePickerView(hidden: true)
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
            events = EventManager.shared.loadEvents(by: currentDate, with: isChosenDate)
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
        return CGSize(width: calendarView.frame.width, height: 2)
    }
}

//MARK: - UITableViewDataSource

extension CalendarViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isShow {
            return 0
        }
        return events.isEmpty ? 1 : events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !isShow {
            return UITableViewCell.init()
        }
        
        if !events.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
            
            let eventIndex = events[indexPath.row]
            
            cell.delegate = self
            cell.configUI(with: eventIndex)
            cell.tag = indexPath.row
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "GIFImageTableViewCell", for: indexPath) as! GIFImageTableViewCell
        cell.gifImageView.startAnimatingGIF()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if events.isEmpty {
            return Constant.heightGIFImageCell
        }
        return UITableView.automaticDimension
    }
}

//MARK: - UITableViewDelegate

extension CalendarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                       "sectionHeader") as! CalendarTableViewHeader
        header.delegate = self
        header.title.text = "\(getTableHeaderContent()) 's events"
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
}

//MARK: - EventTableViewCellDelegate

extension CalendarViewController: EventCellDelegate {
    
    func editItem(at pos: Int) {
        let addItemVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
        addItemVC.event = events[pos]
        navigationController?.pushViewController(addItemVC, animated: true)
    }
}

//MARK: - CalendarTableViewHeaderDelegate

extension CalendarViewController: CalendarTableViewHeaderDelegate {
    
    func showSection() {
        isShow = true
        eventTableView.reloadData()
    }
    
    func hideSection() {
        isShow = false
        eventTableView.reloadData()
    }
}
