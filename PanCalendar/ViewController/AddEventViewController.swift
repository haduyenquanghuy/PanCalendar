//
//  AddEventViewController.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 08/05/2022.
//

import UIKit
import ChameleonFramework
import Toast_Swift

class AddEventViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var startTimeTextField: UITextField!
    
    @IBOutlet weak var endTimeTextField: UITextField!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var defaultChosenColorButton: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var lastChosenColor: UIButton?
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = false
        createDatePicker(with: startTimeTextField)
        createDatePicker(with: endTimeTextField)
        lastChosenColor = defaultChosenColorButton
        
        descriptionTextField.delegate = self
        titleTextField.delegate = self
        
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(textField: )), for: UIControl.Event.editingChanged)
        
        let currentDate = Date()
        startTimeTextField.text = Common.convertDate(currentDate, with: PDateFormat.longFormat)
        endTimeTextField.text = Common.convertDate(currentDate.addingTimeInterval(60), with: PDateFormat.longFormat)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = false
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
    
    //MARK: - Action Handler
    
    @IBAction func pressSave(_ sender: Any) {
        
        
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
            saveButton.alpha = isTextFieldEmpty ? 0.85 : 1.0
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
        sender.setImage(UIImage(systemName: "sparkles"), for: .normal)
        lastChosenColor?.setImage(UIImage(), for: .normal)
        lastChosenColor = sender
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
