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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func writePriceInKorean(_ price: Int) -> String {
        // WRITE PRICE IN KOREAN CHARACTERS
        if price == 0 {
            self.priceLabel.text = ""
            return ""
        }
        
        var priceText = " 원"
        var value = price
        
        let prefix: [String] = ["", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구"]
        let suffix: [String] = ["", "십", "백", "천"]
        let suffix2: [String] = ["", "만"]
        
        var index2 = 0
        
        while value > 0 {
            
            var priceTextTemp = ""
            for index in 0 ..< 4 {
                if value == 0 { break }
                
                let end = value % 10
                
                if end == 1 && index == 0 && index2 == 0 {
                    priceTextTemp = "일"
                } else if end == 1 {
                    priceTextTemp = suffix[index] + priceTextTemp
                } else if end != 0 {
                    priceTextTemp = prefix[end] + suffix[index] + priceTextTemp
                }
                
                value = value / 10
            }
            
            priceText = priceTextTemp + suffix2[index2] + priceText
            
            index2 += 1
        }
        
        return priceText
    }
}

extension ViewController: AmazingPriceViewDelegate {
    
    func priceChanged(price: Int) {
        self.priceLabel.text = self.writePriceInKorean(price)
    }
    
    func isPriceOverMaximumPrice(isOverMaximumPrice: Bool) {
        
        if isOverMaximumPrice {
            self.infoLabel.text = "Greater than MAX!"
        } else {
            self.infoLabel.text = "Less than MAX"
        }
    }
    
    func isPriceOverMinimumPrice(isOverMinimumPrice: Bool) {
        if isOverMinimumPrice {
            self.infoLabel.text = "Greater than MIN"
        } else {
            self.infoLabel.text = "Less than MIN!"
        }
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


