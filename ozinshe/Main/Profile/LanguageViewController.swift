//
//  LanguageViewController.swift
//  ozinshe
//
//  Created by Aziza on 30.06.2023.
//

import UIKit
import Localize_Swift

protocol LanguageProtocol {
    func languageDidChange()

}
class LanguageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var lineView: UIView!
    
    var delegate: LanguageProtocol?
    
    let languageArray = [["English", "en"], ["Казакша", "kk"], ["Русский","ru"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.layer.cornerRadius = 32
        backgroundView.clipsToBounds = true
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        lineView.layer.cornerRadius = 2.5
        
        tableView.dataSource = self
        tableView.delegate = self
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageArray.count
    }
        // Do any additional setup after loading the view.
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let lable = cell.viewWithTag(1000) as! UILabel
        lable.text = languageArray [indexPath.row] [0]
        
        let imageView = cell.viewWithTag(1001) as! UIImageView
        
        if languageArray[indexPath.row][1] == Localize.currentLanguage() {
            imageView.image = UIImage(named: "Check")
        }
        else {
            imageView.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Localize.setCurrentLanguage(languageArray[indexPath.row][1])
        delegate?.languageDidChange()
        dismiss(animated: true)
    }
        
        
        
        
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
        
}
