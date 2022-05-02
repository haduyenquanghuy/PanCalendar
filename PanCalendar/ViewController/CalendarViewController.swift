//
//  ViewController.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 30/04/2022.
//

import UIKit

enum SectionType: Int {
    case weekdaySection = 0
    case dateSection = 1
}

class CalendarViewController: UIViewController {
    
    static let dayOfWeeks = 7
    
    var dates = [DateTimeModel]()
    var weekdays = [String]()
    var chosenItem: IndexPath?
    
    @IBOutlet weak var calendarView: UICollectionView!
    
    let dateTimeManager = DateTimeManager(currentDate: Date.now)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.register(CalendarCollectionViewCell.nib(), forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        calendarView.register(CalendarFooterReusableView.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CalendarFooterReusableView.identifier)
        dates = dateTimeManager.dates
        weekdays = Calendar(identifier: .iso8601).weekdaySymbols.map { $0.uppercased() }
    }
}

extension CalendarViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == SectionType.dateSection.rawValue {
            if let chosenItem = chosenItem {
                let lastChosenCell = calendarView.cellForItem(at: chosenItem) as! CalendarCollectionViewCell
                lastChosenCell.type = dates[chosenItem.row].isToday ? .today : .date
            }
            chosenItem = indexPath
            let chosenCell = calendarView.cellForItem(at: indexPath) as? CalendarCollectionViewCell
            chosenCell?.type = .chosen
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
}

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
            }
        } else {
            cell.contentLabel.text = weekdays[indexPath.row]
            cell.type = .weekday
        }
        return cell
    }
}

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
            return CGSize(width: calendarView.frame.width, height: 24)
        }
        return CGSize(width: view.frame.width, height: 1)
    }
}
