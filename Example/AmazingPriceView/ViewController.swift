//
//  ViewController.swift
//  SwiftPriceAnimationView
//
//  Created by yoosa3004 on 11/24/2020.
//  Copyright (c) 2020 yoosa3004. All rights reserved.
//

import UIKit
import AmazingPriceView


@available(iOS 10.0, *)
class ViewController: UIViewController {
    
    private let HORIZONTAL_MARGIN: CGFloat = 32.0
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceView: AmazingPriceView!
    @IBOutlet weak var keypadCollectionView: UICollectionView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    /*
    // INITIALIZE AMAZING PRICE VIEW IN CODE
    var priceView = AmazingPriceView(font: .boldSystemFont(ofSize: 36.0), minimumPrice: 1000, maximumPrice: 2000000)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.view.addSubview(self.priceView)
        
        self.priceView.translatesAutoresizingMaskIntoConstraints = false
        self.priceView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor, constant: 200.0).isActive = true
        self.priceView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.priceView.backgroundColor = .systemYellow
    } */
    
    override func loadView() {
        super.loadView()
        
        self.priceView.delegate = self
        self.priceView.placeHolderColor = .lightGray
        self.priceView.placeHolder = "금액"
        self.priceView.placeHolderFont = .systemFont(ofSize: 26, weight: .medium)
        
        self.priceView.fontColor = .black
        self.priceView.maximumPricefontColor = .systemPink
    }
    
    func layoutPriceView() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: AmazingPriceViewDelegate {
    func isPriceOverMaximumPrice(isOverMaximumPrice: Bool) {
        
        if isOverMaximumPrice {
            self.infoLabel.text = "Greater than MAX!"
        } else {
            self.infoLabel.text = "Less than MAX"
        }
        print("isPriceOverMaximumPrice: \(isOverMaximumPrice)")
    }
    
    func isPriceOverMinimumPrice(isOverMinimumPrice: Bool) {
        if isOverMinimumPrice {
            self.infoLabel.text = "Greater than MIN"
        } else {
            self.infoLabel.text = "Less than MIN!"
        }
        print("isPriceOverMinimumPrice: \(isOverMinimumPrice)")
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? KeypadCell else {
            return UICollectionViewCell()
        }
        
        cell.key = KeypadCell.getKey(indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let key = KeypadCell.getKey(indexPath)
        
        
        switch KeypadCell.keyType(for: key) {
        case .number:
            self.priceView.insertNumber(key)
            
        case .delete:
            self.priceView.deleteNumber()
            
        case .clear:
            self.priceView.clear()
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width-self.HORIZONTAL_MARGIN)/3, height: KeypadCell.HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


