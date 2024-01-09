//
//  ChangePasswordViewController.swift
//  ozinshe
//
//  Created by Aziza on 29.07.2023.
//

import UIKit
import SVProgressHUD
import Alamofire

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var password1TextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var password1Button: UIButton!
    @IBOutlet weak var password2Button: UIButton!
    @IBOutlet weak var saveChangeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func configureViews() {
        password1TextField.layer.cornerRadius = 12.0
        password1TextField.layer.borderWidth = 1.0
        password1TextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        password2TextField.layer.cornerRadius = 12.0
        password2TextField.layer.borderWidth = 1.0
        password2TextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        saveChangeButton.layer.cornerRadius = 12.0
        
    }
    
    @IBAction func editingDidBegin(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
    }
    @IBAction func editingDidEnd(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
    }
    @IBAction func showPassword1(_ sender: Any) {
        password1TextField.isSecureTextEntry.toggle()
    }
    @IBAction func showPassword2(_ sender: Any) {
        password2TextField.isSecureTextEntry.toggle()
    }
    @IBAction func saveTouched(_ sender: Any) {
        let password1 = password1TextField.text!
        let password2 = password2TextField.text!
        
        //validasia
        if  password1 != password2 {
            SVProgressHUD.showError(withStatus: "Пароли должны совпадать!")
            return
        }
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [ "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"]
        
        let parametrs = ["password": password1 ]
        AF.request(Urls.CHANGE_PASS_URL, method: .put, parameters: parametrs, encoding: JSONEncoding.default, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            if response.response?.statusCode == 200 {
                self.navigationController?.popViewController(animated: true)
            } else {
                        var resultString = ""
                        if let data = response.data {
                            resultString = String (data: data, encoding: .utf8)!
                        }
                    }
                }
            }
        }
    
   

