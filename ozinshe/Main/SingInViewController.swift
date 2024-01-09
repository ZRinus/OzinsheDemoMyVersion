//
//  ViewController.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 25.12.2023.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Localize_Swift

class SingInViewController: UIViewController {
    
    @IBOutlet weak var SalemLabel: UILabel!
    @IBOutlet weak var Exit: UILabel!
    @IBOutlet weak var emailTextField: TextFieldWithPadding!
    @IBOutlet weak var passwordTextField:
    TextFieldWithPadding!
    
    @IBOutlet weak var singinButton: UIButton!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        // Do any additional setup after loading the view.
    }
    
    func configureViews() {
        emailErrorLabel.text = ""
        SalemLabel.text = "HELLO".localized()
        Exit.text = "SING_IN".localized()
        if Localize.currentLanguage() == "ru" {
            SalemLabel.text = "Привет"
            Exit.text = "Вход в аккаунт"
                }
                if Localize.currentLanguage() == "kk" {
                    SalemLabel.text = "Салем"
                    SalemLabel.text = "Аккаунтқа кіріңіз"
                }
                if Localize.currentLanguage() == "en" {
                    SalemLabel.text = "Hello"
                    Exit.text = "Sing in email"
                }
        emailTextField.layer.cornerRadius = 12.0
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        passwordTextField.layer.cornerRadius = 12.0
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        singinButton.layer.cornerRadius = 12.0
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPredicion = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicion.evaluate(with: email)
    }
    
    
    @IBAction func textFieldEditingDidBegin(_ sender: TextFieldWithPadding) {
        emailErrorLabel.text = ""
        
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
        
    }
    
    @IBAction func textFieldEditingChanged(_ sender: TextFieldWithPadding) {
       emailErrorLabel.text = ""
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
    }
    
    
    @IBAction func textFieldEditingDidEnd(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor =  UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.00).cgColor
    }
    
    @IBAction func singin(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if email.isEmpty || password.isEmpty {
            return
        }
        // емаил не пустой
        if !isValidEmail(email) {
    // email ne pravilnii
            emailErrorLabel.text = "Қате формат"
            emailTextField.layer.borderColor = UIColor.systemRed.cgColor
            return
        }
        
        SVProgressHUD.show()
        let parametrs = ["email": email, "password": password]
        AF.request(Urls.SING_IN_URL, method: .post, parameters: parametrs, encoding: JSONEncoding.default).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let token = json["accessToken"].string {
                      Storage.sharedInstance.accessToken = token
                    UserDefaults.standard.set(token, forKey: "accessToken")
                      self.startApp()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
           
        func startApp() {
                let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController")
                tabViewController?.modalPresentationStyle = .fullScreen
                self.present(tabViewController!, animated: true, completion: nil)
            }
        
    @IBAction func togglePassword(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
        
    }
    
    @IBAction func authorizationButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AuthorizationViewController")
        navigationController?.show(vc! , sender: self)
    }
}



