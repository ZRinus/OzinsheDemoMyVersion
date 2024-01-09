//
//  OnboardingViewController.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 25.12.2023.
//

import UIKit

class OnboardingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var collectionView:UICollectionView!
    
    let sliders = ["Фильмдер, телехикаялар, ситкомдар, анимациялық жобалар, телебағдарламалар мен реалити-шоулар, аниме және тағы басқалары",
                   "Кез келген құрылғыдан қара,Сүйікті фильміңді  қосымша төлемсіз телефоннан, планшеттен, ноутбуктан қара",
                   "Тіркелу оңай. Қазір тіркел де қалаған фильміңе қол жеткіз"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
configureViews()
    }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            // skrit panel s knopkoi nazad
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        
    
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        
        // Do any additional setup after loading the view.
 
    func configureViews() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let descriptionLabel = cell.viewWithTag(100) as? UILabel
        descriptionLabel?.text = sliders[indexPath.row]
        
        let imageView = cell.viewWithTag(200) as? UIImageView
        imageView?.image = UIImage(named: "Onboarding\(indexPath.row + 1)")
        
        let continueButton = cell.viewWithTag(300) as? UIButton
        let skipButton = cell.viewWithTag(400) as? UIButton
        continueButton?.addTarget(self, action: #selector(showLogin),  for: .touchUpInside)
        
        skipButton?.addTarget(self, action: #selector(showLogin),  for: .touchUpInside)
                                  
        if indexPath.row != sliders.count - 1 {
            continueButton?.isHidden = true
        } else {
            skipButton?.isHidden = true
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // obnovit indikator
        let widht = scrollView.frame.width
        pageControll.currentPage = (Int(scrollView.contentOffset.x / widht))
        
    }
  @objc  func showLogin() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SingInViewController") as! SingInViewController
        navigationController?.pushViewController(vc, animated: true)  // mozhno i show
        
    }
}
