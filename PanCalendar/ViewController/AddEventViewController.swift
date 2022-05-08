//
//  AddEventViewController.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 08/05/2022.
//

import UIKit

class AddEventViewController: UIViewController {

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
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(donePressed))
        
        
        toolbar.setItems([cancelBtn,flexibleSpace,dontBtn], animated: true)
        
        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
    }
    
    @objc func donePressed() {
        let dateVal = Common.convertDate(datePicker.date, with: PDateFormat.longFormat)
        if startTimeTextField.isFirstResponder {
            startTimeTextField.text = "\(dateVal)"
        } else if endTimeTextField.isFirstResponder {
            endTimeTextField.text = "\(dateVal)"
        }
        self.view.endEditing(true)
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
        sender.setImage(UIImage(systemName: "checkmark"), for: .normal)
        lastChosenColor?.setImage(UIImage(), for: .normal)
        lastChosenColor = sender
    }
}

extension AddEventViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
