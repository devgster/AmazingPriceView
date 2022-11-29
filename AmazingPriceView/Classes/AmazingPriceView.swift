//
//  SwiftPriceAnimationView.swift
//  Pods
//
//  Created by hyunndy on 2020/11/24.
//

import Foundation
import UIKit

public protocol AmazingPriceViewDelegate: AnyObject {
    func isPriceOverMaximumPrice(isOverMaximumPrice: Bool)
    func isPriceOverMinimumPrice(isOverMinimumPrice: Bool)
    func priceChanged(price: Int)
}

public enum NationalCurrencyInfo {
    case US
    case KOR
}

@available(iOS 10.0, *)
open class AmazingPriceView: UIView {
    
    private class CurrencyView: UILabel {
        init(text: String, font: UIFont, fontColor: UIColor) {
            super.init(frame: .zero)
            
            self.text = text
            self.font = font
            self.textColor = fontColor
            
            self.isHidden = true
            self.alpha = 0.0
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    private var font: UIFont = .systemFont(ofSize: 36.0)
    private var fontSize: CGFloat = 36.0
    
    public var maximumPricefontColor: UIColor = .systemPink
    public var fontColor: UIColor = .black {
        didSet {
            for view in self.numberStackView.arrangedSubviews {
                if let view = view as? UILabel {
                    view.textColor = fontColor
                }
            }
        }
    }
    
    private var insertAnimationDuration = 0.08
    private var deleteAnimationDuration = 0.10
    private var shakeAnimationDuration = 0.30
    
    public private(set) var maximumPrice: Int = 1000
    public private(set) var minimumPrice: Int = 2000000
    
    public weak var delegate: AmazingPriceViewDelegate?
    
    private var placeHolderView = UILabel()
    public var placeHolder: String? = "금액을 입력해주세요" {
        didSet {
            self.placeHolderView.text = placeHolder
        }
    }
    public var placeHolderColor: UIColor = .black {
        didSet {
            self.placeHolderView.textColor = self.placeHolderColor
        }
    }
    
    public var placeHolderFont: UIFont = .systemFont(ofSize: 36.0) {
        didSet {
            self.placeHolderView.font = self.placeHolderFont
        }
    }
    
    public private(set) var currencyInfo: NationalCurrencyInfo = .KOR
    private var currencyView: CurrencyView!
    private var currency: String = "원"
    private var floatingPoint: String = ","
    
    private let numberStackView = UIStackView()
    private var numberLabelCount: Int = 0
    private var maximumFloatingPointNum: Int = 0
    
    public private(set) var price: Int = 0 {
        didSet {
            self.isOverMinimum = (self.price >= self.minimumPrice)
            
            if oldValue == 0 && self.price > 0 {
                self.setPlaceHolder(false)
            } else if oldValue > 0 && self.price == 0 {
                self.setPlaceHolder(true)
            }
            
            if oldValue != self.price {
                self.delegate?.priceChanged(price: self.price)
            }
        }
    }
    
    public private(set) var isOverMaximum: Bool = false {
        didSet {
            if oldValue == self.isOverMaximum { return }
            
            if self.isOverMaximum {
                setMaximumPriceAnimation()
            } else {
                restoreNumberViews()
            }
            
            self.delegate?.isPriceOverMaximumPrice(isOverMaximumPrice: self.isOverMaximum)
        }
    }

    public private(set) var isOverMinimum: Bool = false {
        didSet {
            if oldValue == self.isOverMinimum { return }
            
            guard let delegate = self.delegate else { return }

            delegate.isPriceOverMinimumPrice(isOverMinimumPrice: self.isOverMinimum)
        }
    }
    
    @IBInspectable var numberFont: UIFont = .systemFont(ofSize: 36, weight: .bold)
    @IBInspectable var maxPrice: Int = 2000000
    @IBInspectable var minPrice: Int = 1000
    
    public init(font: UIFont = .systemFont(ofSize: 36.0), minimumPrice: Int = 1000, maximumPrice: Int = 2000000) {
        super.init(frame: .zero)
        
        self.initLayout(font: font, minPrice: minimumPrice, maxPrice: maximumPrice)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)

        self.initLayout(font: self.numberFont, minPrice: self.minPrice, maxPrice: self.maxPrice)
    }
    
    private func initLayout(font: UIFont, minPrice: Int, maxPrice: Int) {
        self.font = font
        self.minimumPrice = minPrice
        self.maximumPrice = maxPrice
        
        initNumberViews()
        initPlaceHolder()
    }
    
    
    private func initPlaceHolder() {
        
        self.addSubview(self.placeHolderView)
        self.placeHolderView.text = placeHolder
        self.placeHolderView.textAlignment = .center
        self.placeHolderView.textColor = self.placeHolderColor
        self.placeHolderView.font = placeHolderFont
        self.placeHolderView.font.withSize(fontSize)

        self.placeHolderView.translatesAutoresizingMaskIntoConstraints = false
        self.placeHolderView.widthAnchor.constraint(equalToConstant: self.placeHolderView.intrinsicContentSize.width + 0.5).isActive = true
        self.placeHolderView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.placeHolderView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.placeHolderView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    public func setAnimationDuration(insert: Double = 0.08, delete: Double = 0.10, shake: Double = 0.30) {
        self.insertAnimationDuration = insert
        self.deleteAnimationDuration = delete
        self.shakeAnimationDuration = shake
    }

    private func initNumberViews() {
        self.addSubview(self.numberStackView)
        self.numberStackView.isHidden = true
        self.numberStackView.axis = .horizontal
        self.numberStackView.distribution = .fill
        self.numberStackView.alignment = .center
        self.numberStackView.translatesAutoresizingMaskIntoConstraints = false
        self.numberStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.numberStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.numberStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        var maxPrice = self.maximumPrice
        while(maxPrice > 0) {
            self.numberLabelCount += 1
            maxPrice /= 10
        }
        
        self.maximumFloatingPointNum = (self.numberLabelCount - 1) / 3
        
        self.currencyView = CurrencyView(text: self.currency, font: self.font, fontColor: self.fontColor)
        
        for _ in 1...self.numberLabelCount {
            let numberLabel = UILabel()
            numberLabel.isHidden = true
            numberLabel.alpha = 0.0
            numberLabel.textAlignment = .center
            
            numberLabel.font = self.font
            numberLabel.font.withSize(self.fontSize)
            numberLabel.textColor = self.fontColor
            numberLabel.text = "0"
            
            numberLabel.widthAnchor.constraint(equalToConstant: numberLabel.intrinsicContentSize.width + 1.0).isActive = true
            self.numberStackView.addArrangedSubview(numberLabel)
        }
        
        self.numberStackView.addArrangedSubview(self.currencyView)
    }
    
    public func insertNumber(_ n: Int) {
        
        if self.price == 0 && n == 0 { return }
        
        if self.price == self.maximumPrice {
            if self.isOverMaximum == true {
                self.shakeAnimation()
            } else {
                self.isOverMaximum = true
            }
        } else {
            let newPrice = self.price * 10 + n
            
            if newPrice > self.maximumPrice {
                self.price = self.maximumPrice
                self.isOverMaximum = true
            } else {
                self.price = newPrice
                self.insertNumberAnimation(n)
            }
        }
    }
    
    private func insertNumberAnimation(_ num: Int) {
        
        var digitNum = 0
        var currentPrice = self.price
        while(currentPrice > 0) {
            digitNum += 1
            currentPrice /= 10
        }
        
        self.removeFloatingPoint()
        
        guard let numberView = self.numberStackView.arrangedSubviews[digitNum-1] as? UILabel else { return }
        if numberView.isHidden == false || numberView.isEqual(self.currencyView) { return }
        
        numberView.text = "\(num)"
        numberView.transform = CGAffineTransform(translationX: 0, y: -40)
        
        UIView.animate(withDuration: self.insertAnimationDuration, delay: 0.0, options: .curveLinear, animations: { [weak self, weak numberView] in
            
            guard let self = self, let numberView = numberView else { return }
            
            self.currencyView.isHidden = false
            
            numberView.isHidden = false
            
            self.addFloatingPoint()
            
        }, completion: { [weak self] _ in
            
            guard let self = self else { return }
            
            UIView.animate(withDuration: self.insertAnimationDuration, delay: 0.0, options: .curveLinear, animations:{ [weak self, weak numberView] in
                
                guard let self = self, let numberView = numberView else { return }
                
                numberView.transform = CGAffineTransform(translationX: 0, y: 0)
                numberView.alpha = 1.0
                
                self.currencyView.alpha = 1.0
            })
        })
    }
    
    public func deleteNumber() {
        
        if self.price == 0 { return }
        
        self.price = self.price / 10
        
        self.isOverMaximum = false
        
        self.deleteNumberAnimation()
    }
    
    private func deleteNumberAnimation() {
        
        self.removeFloatingPoint()
        
        var digitNum = 0
        var currentPrice = self.price
        while(currentPrice > 0) {
            digitNum += 1
            currentPrice /= 10
        }
        
        guard let numberView = self.numberStackView.arrangedSubviews[digitNum] as? UILabel else { return }
        
        UIView.animate(withDuration: self.deleteAnimationDuration, delay: 0.0, options: .curveLinear, animations: { [weak self, weak numberView] in
            
            guard let self = self, let numberView = numberView else { return }
            
            numberView.transform = (digitNum != 0) ? CGAffineTransform(translationX: -(numberView.frame.width/2), y: -20) : CGAffineTransform(translationX: -(numberView.frame.width), y: -20)
            
            numberView.alpha = 0.0
            
            numberView.isHidden = true
            
            if digitNum == 0 {
                self.currencyView.alpha = 0.0
                self.currencyView.isHidden = true
            }

            self.addFloatingPoint()
            
        }, completion: { [weak numberView] _ in
            guard let numberView = numberView else { return }
            
            numberView.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
        })
    }
    
    private func setMaximumPriceAnimation() {
        
        self.removeFloatingPoint()
        
        guard let lastNumberView = self.numberStackView.arrangedSubviews[self.numberLabelCount-1] as? UILabel else { return }
        
        lastNumberView.transform = CGAffineTransform(translationX: 0, y: -40)
        
        UIView.animate(withDuration: self.insertAnimationDuration, delay: 0.0, options: .curveLinear, animations: { [weak self, weak lastNumberView] in
            
            guard let self = self, let lastNumberView = lastNumberView else { return }
            
            let maximumDigits = String(describing: self.maximumPrice).compactMap { String($0) }
            
            for (idx, view) in self.numberStackView.arrangedSubviews.enumerated() {
                guard let view = view as? UILabel else { return }
                
                if idx < self.numberStackView.arrangedSubviews.endIndex-1 && idx < maximumDigits.count {
                    view.text = maximumDigits[idx]
                }
                
                view.textColor = self.maximumPricefontColor
            }
            
            lastNumberView.isHidden = false
            
            self.addFloatingPoint()
            
        }, completion: { [weak self] _ in
            
            guard let self = self else { return }
            
            UIView.animate(withDuration: self.insertAnimationDuration, delay: 0.0, options: .curveLinear, animations: { [weak self, weak lastNumberView] in
                
                guard let self = self, let lastNumberView = lastNumberView else { return }
                
                lastNumberView.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
                lastNumberView.alpha = 1.0
                
                self.shakeAnimation()
            })
        })
    }
    
    public func clear() {
        
        if self.price == 0 { return }
        
        self.price = 0
        
        self.isOverMaximum = false
        
        for view in self.numberStackView.arrangedSubviews {
            view.alpha = 0.0
            view.isHidden = true
        }
    }
    
    private func addFloatingPoint() {
        
        if self.price < 1000 { return }
        
        var digitNum = 0
        var currentPrice = self.price
        while(currentPrice > 0) {
            digitNum += 1
            currentPrice /= 10
        }
        
        let floatingPointCount = (digitNum - 1) / 3
        for idx in 1...floatingPointCount {
            
            let floatingPointIdx = (digitNum) - (idx*3)
            
            let floatingPointView = UILabel()
            floatingPointView.text = self.floatingPoint
            floatingPointView.font = self.font
            floatingPointView.textColor = (self.isOverMaximum == true) ? self.maximumPricefontColor : self.fontColor
            
            self.numberStackView.insertArrangedSubview(floatingPointView, at: floatingPointIdx)
        }
    }
    
    private func removeFloatingPoint() {
        
        let arrFloatingPoint = self.numberStackView.arrangedSubviews.filter { ($0 as! UILabel).text == self.floatingPoint }
        
        for view in arrFloatingPoint {
            self.numberStackView.removeArrangedSubview(view)
            view.isHidden = true
            view.removeFromSuperview()
        }
    }
    
    private func restoreNumberViews() {
        
        for view in self.numberStackView.arrangedSubviews {
            if let view = view as? UILabel {
                view.textColor = self.fontColor
            }
        }
    }
    
    private func setPlaceHolder(_ isVisible: Bool) {
        self.placeHolderView.isHidden = !isVisible
        self.numberStackView.isHidden = isVisible
    }
    
    private func shakeAnimation() {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");

        translation.values = [-5, 5, -4, 4, -3, 3, -2, 2, 0]
        
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation]
        shakeGroup.duration = self.shakeAnimationDuration
        self.layer.add(shakeGroup, forKey: "shakeIt")
    }
    
    private func setCurrencyInfo() {
        switch self.currencyInfo {
        case .KOR:
            self.currency = "원"
            self.floatingPoint = ","
        case .US:
            self.currency = "$"
            self.floatingPoint = ","
        }
    }
}
