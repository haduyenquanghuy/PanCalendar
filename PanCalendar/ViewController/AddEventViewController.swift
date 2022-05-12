//
//  AddEventViewController.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 08/05/2022.
//

import UIKit
import ChameleonFramework
import Toast_Swift
import CoreData

class AddEventViewController: UIViewController {
    
    @IBOutlet weak var typeEventSegment: UISegmentedControl!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var startTimeTextField: UITextField!
    
    @IBOutlet weak var endTimeTextField: UITextField!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var notificationSegment: UISegmentedControl!
    
    @IBOutlet var chosenColorButtons: [PanCornerButton]!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var event: Event?
    
    var lastChosenColor: UIButton?
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = false
        createDatePicker(with: startTimeTextField)
        createDatePicker(with: endTimeTextField)
        
        chosenColorButtons.sort { $0.frame.origin.x  < $1.frame.origin.x }
        
        descriptionTextField.delegate = self
        titleTextField.delegate = self
        
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(textField: )), for: UIControl.Event.editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showDefaultUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentSize = CGSize(width: 0, height: self.stackView.frame.height + Constant.extraSpaceToScroll)
    }
    
    func createDatePicker(with textField: UITextField) {
        let toolbar = UIToolbar()
        
        toolbar.sizeToFit()
        
        let dontBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil);
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPressed))
        
        
        toolbar.setItems([cancelBtn,flexibleSpace,dontBtn], animated: true)
        
        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
    }
    
    func showDefaultUI() {
        if let event = event {
            self.title = "Edit Event"
            titleTextField.text = event.title!
            descriptionTextField.text = event.information ?? ""
            startTimeTextField.text = Common.convertDate(event.startTime!, with: PDateFormat.longFormat)
            endTimeTextField.text = Common.convertDate(event.endTime!, with: PDateFormat.longFormat)
            didChosenColor(findButton(by: event.color!))
            notificationSegment.selectedSegmentIndex = event.isEnabled ? 0 : 1
            typeEventSegment.selectedSegmentIndex = Int(event.type)
            saveButton.isEnabled = true
        } else {
            self.title = "Add Event"
            let currentDate = Date()
            startTimeTextField.text = Common.convertDate(currentDate, with: PDateFormat.longFormat)
            endTimeTextField.text = Common.convertDate(currentDate.addingTimeInterval(60), with: PDateFormat.longFormat)
            didChosenColor(findButton())
            saveButton.isEnabled = false
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    //MARK: - Action Handler
    
    @IBAction func pressSave(_ sender: Any) {
        save(with: event)
    }
    
    @objc func donePressed() {
        let datePickerDate = datePicker.date
        let dateVal = Common.convertDate(datePickerDate, with: PDateFormat.longFormat)
        if startTimeTextField.isFirstResponder {
            let endTime = Common.convertDate(endTimeTextField.text!, with: .longFormat)!
            if endTime < datePickerDate {
                view.makeToast("Start time must before end time!", duration: 3.0, position: .bottom, style:ToastStyle())
            } else {
                startTimeTextField.text = "\(dateVal)"
            }
            
        } else if endTimeTextField.isFirstResponder {
            let startTime = Common.convertDate(startTimeTextField.text!, with: .longFormat)!
            if datePickerDate < startTime.addingTimeInterval(60) {
                view.makeToast("Start time must before end time!", duration: 3.0, position: .bottom, style:ToastStyle())
            } else {
                endTimeTextField.text = "\(dateVal)"
            }
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelPressed() {
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if textField == titleTextField, let text = textField.text {
            let isTextFieldEmpty = text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            saveButton.isEnabled = !isTextFieldEmpty
        }
    }
    
    @IBAction func calendarStartButton(_ sender: UIButton) {
        createDatePicker(with: startTimeTextField)
        startTimeTextField.becomeFirstResponder()
    }
    
    @IBAction func calendarEndButton(_ sender: UIButton) {
        createDatePicker(with: endTimeTextField)
        endTimeTextField.becomeFirstResponder()
    }
    
    @IBAction func didChosenColor(_ sender: UIButton) {
        lastChosenColor?.setImage(UIImage(), for: .normal)
        sender.setImage(UIImage(systemName: "sparkles"), for: .normal)
        lastChosenColor = sender
    }
    
    @IBAction func pressDelete(_ sender: UIBarButtonItem) {
        if let event = event {
            let title = event.title!
            EventManager.shared.delete(event)
            navigationController?.viewControllers[0].view.makeToast("Deleted event with title: \(title)", duration: 3.0, position: .bottom, style:ToastStyle())
        }
        navigationController?.popViewController(animated: true)
    }
    
    func findButton(by hexColor: String? = nil) -> UIButton {
        if let hexColor = hexColor {
            for button in chosenColorButtons {
                if hexColor == button.backgroundColor?.hexValue() {
                    return button
                }
            }
        }
        return chosenColorButtons[0]
    }
    
    
    //MARK: - Core Data
    
    func save(with currentEvent: Event? = nil) {
        var event: Event
        if currentEvent != nil {
            event = currentEvent!
        } else {
            let managedContext = EventManager.shared.getManagerContext()
            let entity = NSEntityDescription.entity(forEntityName: "Event", in: managedContext)!
            event = NSManagedObject(entity: entity, insertInto: managedContext) as! Event
        }
        guard let title = titleTextField.text,
              let startTime = startTimeTextField.text,
              let endTime = endTimeTextField.text,
              let color = lastChosenColor?.backgroundColor?.hexValue()
        else { return }
        
        event.title = title
        event.startTime = Common.convertDate(startTime, with: .longFormat)
        event.endTime = Common.convertDate(endTime, with: .longFormat)
        event.color = color
        event.type = Int16(typeEventSegment.selectedSegmentIndex)
        event.isEnabled = notificationSegment.selectedSegmentIndex == 0
        
        if let description = descriptionTextField.text {
            event.information = description
        }
        
        EventManager.shared.save()
        
        navigationController?.popViewController(animated: true)
    }
}
//MARK: - UITextFieldDelegate

extension AddEventViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            textField.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
}
