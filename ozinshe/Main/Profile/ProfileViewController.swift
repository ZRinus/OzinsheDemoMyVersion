//
//  ProfileViewController.swift
//  ozinshe
//
//  Created by Aziza on 30.06.2023.
//

import UIKit
import Localize_Swift

class ProfileViewController: UIViewController, LanguageProtocol {

    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var myProfileLabel: UILabel!

    @IBOutlet weak var changePasswordButton: UIButton!
    
    @IBOutlet weak var emailNameLabel: UILabel!
    @IBOutlet weak var darkThemeSwitch: UISwitch!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
  configureViews()
        configureViewsEmail()
    }
    func configureViewsEmail() {
        emailNameLabel.text = Storage.sharedInstance.user
    }
    
    func configureViews() {
        myProfileLabel.text = "MY_PROFILE".localized()
        languageButton.setTitle("LANGUAGE".localized(), for: .normal)
        if Localize.currentLanguage() == "ru" {
                    languageLabel.text = "Русский"
                }
                if Localize.currentLanguage() == "kk" {
                    languageLabel.text = "Қазақша"
                }
                if Localize.currentLanguage() == "en" {
                    languageLabel.text = "English"
                }
        darkThemeSwitch.isOn = (UIApplication.shared.delegate as? AppDelegate)?.window?.overrideUserInterfaceStyle == .dark
    }
    
    
    @IBAction func languageShows(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "LanguageViewController") as! LanguageViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        present(vc, animated: true, completion: nil)
//        let vc = storyboard?.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
//
//        vc.modalPresentationStyle = .overFullScreen
//
//        vc.delegate = self
//                present(vc, animated: true, completion: nil)
    }
    func languageDidChange () {
        configureViews()
    }
    
    @IBAction func logout(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "LogoutViewController") as! LogoutViewController
        vc.modalPresentationStyle = .overFullScreen
        present(vc,animated: true)
        
    }
    
    
    @IBAction func personalData(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") //as! EditProfileViewController
        navigationController?.show(vc!, sender: self)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changePassword(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") //as! ChangePasswordViewController
        navigationController?.show(vc!, sender: self)
        
    }
    
   
    @IBAction func v(_ sender: UISwitch) {
        (UIApplication.shared.delegate as? AppDelegate)?.window?.overrideUserInterfaceStyle = sender.isOn ? .dark : .light

        }
}
