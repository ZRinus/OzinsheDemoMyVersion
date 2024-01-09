//
//  EditProfileViewController.swift
//  ozinshe
//
//  Created by Aziza on 04.07.2023.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class EditProfileViewController: UIViewController {
    var userID: Int?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var birthTaxtField: UITextField!
    
    @IBOutlet weak var saveChangesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveChangesButton.layer.cornerRadius = 12
        title = "PERSONAL_DATA".localized()  //запомни title
        birthTaxtField.inputView = datePicker
        birthTaxtField.inputAccessoryView = toolbar
        loadUserData()
    }
    lazy var datePicker: UIDatePicker = {
            let datePicker = UIDatePicker(frame: .zero)
            
            datePicker.datePickerMode = .date
            datePicker.timeZone = TimeZone.current
            datePicker.locale = .autoupdatingCurrent
    //
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat =  "HH:mm"
    //
    //        let date = dateFormatter.date(from: "20:00")
    //
    //        datePicker.date = date!
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            return datePicker
        }()
    lazy var toolbar: UIToolbar = {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonAction))
        
        done.setTitleTextAttributes([
            .foregroundColor: UIColor.link
        ], for: .normal)
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        return doneToolbar
    }()
    
    func loadUserData() {
        SVProgressHUD.show()
        let headers: HTTPHeaders = [ "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"]
        AF.request(Urls.PERSONAL_DATA_URL, method: .get, headers: headers).responseData { response in SVProgressHUD.dismiss()
            if response.response?.statusCode == 200 {
                let json = JSON (response.data!)
                let name = json ["name"]
                let email = json["user"]["email"]
                let phoneNumber = json["phoneNumber"]
                let birthDate = json ["birthDate"]
                self.userID = json ["id"].int
                self.nameTextField.text = name.stringValue
                self.emailTextField.text = email.stringValue
                self.phoneTextField.text = phoneNumber.stringValue
                self.birthTaxtField.text = birthDate.stringValue
            } else {
                SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
            }
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            birthTaxtField.text = dateFormatter.string(from: sender.date)
        }
    @objc func doneButtonAction(){
            birthTaxtField.resignFirstResponder()
        }
    
    
    @IBAction func saveChanges(_ sender: Any) {
        let name = nameTextField.text!
        let phone = phoneTextField.text!
        let birthDate = birthTaxtField.text
        
        let headers: HTTPHeaders = [ "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"]
        
        let parameters = [
            "name": name,
            "phoneNumber": phone,
            "birthDate": birthDate,
            "id": userID,
            "language": "kaz" ] as [String: Any]
        
        AF.request(Urls.PERSONAL_DATA_URL, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
            }
            if response.response?.statusCode == 200 {
                self.navigationController?.popViewController(animated: true)
            } else {
                SVProgressHUD.showError(withStatus: resultString)
            }
        }
    }
}




