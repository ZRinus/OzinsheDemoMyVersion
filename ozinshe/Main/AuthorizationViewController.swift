//
//  AuthorizationViewController.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 20.12.2023.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Alamofire

class AuthorizationViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: TextFieldWithPadding!
    @IBOutlet weak var passwordTextField2: TextFieldWithPadding!
    @IBOutlet weak var passwordTextField3: TextFieldWithPadding!
    @IBOutlet weak var authorizationButton: UIButton!
    @IBOutlet weak var alreadyExistsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        
        // Do any additional setup after loading the view.
    }
    
    func configureViews() {
        
        emailTextField.layer.cornerRadius = 12.0
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        passwordTextField2.layer.cornerRadius = 12.0
        passwordTextField2.layer.borderWidth = 1.0
        passwordTextField2.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        passwordTextField3.layer.cornerRadius = 12.0
        passwordTextField3.layer.borderWidth = 1.0
        passwordTextField3.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        authorizationButton.layer.cornerRadius = 12.0
        
        alreadyExistsLabel.text = ""
        
    }
    
    @IBAction func showPassword1(_ sender: Any) {
        passwordTextField2.isSecureTextEntry.toggle()
    }
    
    @IBAction func showPassword2(_ sender: Any) {
        passwordTextField3.isSecureTextEntry.toggle()
    }
    
    
    @IBAction func editingDidBegin(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
        alreadyExistsLabel.text = ""
    }
    
    @IBAction func editingDidEnd(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor =  UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.00).cgColor
        alreadyExistsLabel.text = ""
        
    }
    
    @IBAction func authorization(_ sender: Any) {
        let email = emailTextField.text!
        let password1 = passwordTextField2.text!
        let password2 = passwordTextField3.text!
        
        if email.isEmpty || password1.isEmpty || password2.isEmpty {
            SVProgressHUD.showError(withStatus: "paroli dolzhni sovpadat")
            return
        }
        
        if password1 != password2 {
            SVProgressHUD.showError(withStatus: "Пароли должны совпадать!")
            print("Пароли должны совпадать!")
            return
        }
        
        // регистрация
        SVProgressHUD.show()
        
        let parametres = ["email": email, "password": password1]
        
        AF.request(Urls.SING_UP_URL, method: .post, parameters: parametres, encoding: JSONEncoding.default).responseData {
            response in
            
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
                if response.response?.statusCode == 400 {
                    self.alreadyExistsLabel.text = "Мұндай email-ы бар пайдаланушы тіркелген"
                }
                else {
                    var ErrorString = "CONNECTION_ERROR".localized()
                    if let sCode = response.response?.statusCode {
                        ErrorString = ErrorString + " \(sCode)"
                    }
                    ErrorString = ErrorString + " \(resultString)"
                    SVProgressHUD.showError(withStatus: "\(ErrorString)")
                }
            }
        }
    }
    
    func startApp() {
        let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController")
        tabViewController?.modalPresentationStyle = .fullScreen
        self.present(tabViewController!, animated: true, completion: nil)
    }
}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


