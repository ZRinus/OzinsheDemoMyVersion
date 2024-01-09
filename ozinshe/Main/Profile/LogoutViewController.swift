//
//  LogoutViewController.swift
//  ozinshe
//
//  Created by Aziza on 21.07.2023.
//

import UIKit

class LogoutViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.layer.cornerRadius = 32
        backgroundView.clipsToBounds = true
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        lineView.layer.cornerRadius = 2.5
        logoutButton.layer.cornerRadius = 12
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
        @objc func dismissView() {
                self.dismiss(animated: true, completion: nil)
            }
            func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
                if (touch.view?.isDescendant(of: backgroundView))! {
                    return false
                }
                return true
            }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "accessToken")

                let rootVC = self.storyboard?.instantiateViewController(withIdentifier: "SingInViewController") as! SingInViewController
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = rootVC
                appDelegate.window?.makeKeyAndVisible()
    }
    @IBAction func cancel(_ sender: Any) {
        dismissView()
    }
    
    
    
        // Do any additional setup after loading the view.
    }
    
    
    



