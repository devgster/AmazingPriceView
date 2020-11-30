//
//  SwiftPriceAnimationView.swift
//  Pods
//
//  Created by hyunndy on 2020/11/24.
//

import Foundation
import UIKit

public protocol AmazingPriceViewDelegate {
    func IsPriceOverMaximumPrice(isOverMaximumPrice: Bool)
    func IsPriceOverMinimumPrice(isOverMinimumPrice: Bool)
}

//public enum CurrencyViewOrder {
//    case Front
//    case Rear
//}

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
    
    var testValue:Int = 0
    
    private var font: UIFont = .systemFont(ofSize: 36.0)
    private var fontColor: UIColor = .black
    private var fontSize: CGFloat = 36.0
    
    public private(set) var maximumPrice: Int = 1000
    public private(set) var minimumPrice: Int = 2000000
    
    private var maximumPricefontColor: UIColor = .systemPink
    
    private var insertAnimationDuration = 0.08
    private var deleteAnimationDuration = 0.10
    private var shakeAnimationDuration = 0.30
    
    public var delegate: AmazingPriceViewDelegate? = nil
    
    private var placeHolder = UILabel()
    
    private var currencyView: CurrencyView!
    private var currency: String = "원"
    private var floatingPoint: String = ","
//    private var currencyViewOrder: CurrencyViewOrder = .Rear
    
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
        }
    }
    
    public private(set) var isOverMaximum: Bool = false {
        didSet {
            if oldValue == self.isOverMaximum { return }
            
            guard let delegate = self.delegate else { return }

            delegate.IsPriceOverMaximumPrice(isOverMaximumPrice: self.isOverMaximum)

            if self.isOverMaximum {
                setMaximumPriceAnimation()
            } else {
                restoreNumberViews()
            }
        }
    }

    public private(set) var isOverMinimum: Bool = false {
        didSet {
            if oldValue == self.isOverMinimum { return }
            
            guard let delegate = self.delegate else { return }

            delegate.IsPriceOverMinimumPrice(isOverMinimumPrice: self.isOverMinimum)
        }
    }
    
    public init() {
        super.init(frame: .zero)
    }
    
    public init(_ font:UIFont = .systemFont(ofSize: 36.0), _ fontColor:UIColor = .black, _ maximumPricefontColor:UIColor = .systemPink, _ fontSize:CGFloat = 36.0, _ maximumPrice:Int = 1000, _ minimumPrice:Int = 2000000, _ insertAnimationDuration:Double = 0.08, _ deleteAnimationDuration:Double = 0.10, _ shakeAnimationDuration: Double = 0.30) {
        super.init(frame: .zero)
        
        self.font = font
        self.fontColor = fontColor
        self.fontSize = fontSize
        self.font.withSize(self.fontSize)
        self.maximumPricefontColor = maximumPricefontColor
        
        self.maximumPrice = maximumPrice
        self.minimumPrice = minimumPrice
        
        self.insertAnimationDuration = insertAnimationDuration
        self.deleteAnimationDuration = deleteAnimationDuration
        self.shakeAnimationDuration = shakeAnimationDuration
        
//        self.currencyViewOrder = order
//        self.currency = currency
//        self.floatingPoint = floatingPoint
        
        initNumberViews()
    }
    
    public func initPlaceHolder(_ text: String?, _ font: UIFont = .systemFont(ofSize: 36.0), _ fontColor: UIColor = .black) {
        
        self.addSubview(self.placeHolder)
        self.placeHolder.text = text
        self.placeHolder.font = font
        self.placeHolder.textColor = fontColor
        self.placeHolder.translatesAutoresizingMaskIntoConstraints = false
        self.placeHolder.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.placeHolder.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.placeHolder.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    private func initNumberViews() {
        
        self.addSubview(self.numberStackView)
        self.numberStackView.isHidden = true
        self.numberStackView.axis = .horizontal
        self.numberStackView.distribution = .fill
        self.numberStackView.alignment = .center
        self.numberStackView.translatesAutoresizingMaskIntoConstraints = false
        self.numberStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.numberStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        var maxPrice = self.maximumPrice
        while(maxPrice > 0) {
            self.numberLabelCount += 1
            maxPrice /= 10
        }
        
        self.maximumFloatingPointNum = (self.numberLabelCount - 1) / 3
        
        for _ in 1...self.numberLabelCount {
            let numberLabel = UILabel()
            numberLabel.isHidden = true
            numberLabel.alpha = 0.0
            numberLabel.textAlignment = .center
            
            numberLabel.font = self.font
            numberLabel.font.withSize(self.fontSize)
            numberLabel.textColor = .black
            numberLabel.text = "0"
            
            numberLabel.widthAnchor.constraint(equalToConstant: numberLabel.intrinsicContentSize.width + 1.0).isActive = true
            self.numberStackView.addArrangedSubview(numberLabel)
        }
        
        self.currencyView = CurrencyView(text: self.currency, font: self.font, fontColor: self.fontColor)
        self.numberStackView.addArrangedSubview(self.currencyView)
    }
    
    public func insertNumber(_ n: Int) {
        
        if self.price == 0 && n == 0 { return }
        
        if self.price == self.maximumPrice {
            if self.isOverMaximum == true {
                self.shake()
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
        
        if self.numberStackView.arrangedSubviews.filter({($0.isHidden == false)}).count >= self.maximumFloatingPointNum + self.numberLabelCount + 1 { return }
        
        self.removeFloatingPoint()
        
        var insertNumberIdx = self.numberStackView.arrangedSubviews.filter { ($0.isHidden == false )}.count - 1
        if insertNumberIdx < 0 {
            insertNumberIdx = 0
        }
        
        let numberView = self.numberStackView.arrangedSubviews[insertNumberIdx] as! UILabel
        if numberView.isHidden == false || numberView.isEqual(self.currencyView) { return }
        
        numberView.text = "\(num)"
        numberView.transform = CGAffineTransform(translationX: 0, y: -40)
        
        UIView.animate(withDuration: self.insertAnimationDuration, delay: 0.0, options: .curveLinear, animations: {
            
            self.currencyView.isHidden = false
            
            numberView.isHidden = false
            
            self.addFloatingPoint()
            
        }, completion: { _ in
            UIView.animate(withDuration: self.insertAnimationDuration, delay: 0.0, options: .curveLinear, animations:{
                
                numberView.transform = CGAffineTransform(translationX: 0, y: 0)
                numberView.alpha = 1.0
                
                self.currencyView.alpha = 1.0
            })
        })
    }
    
    private func deleteNumberAnimation() {
        
        self.removeFloatingPoint()
        
        let deleteNumberIdx = self.numberStackView.arrangedSubviews.filter( { $0.isHidden == false }).count-2
        if deleteNumberIdx < 0 { return }
        
        let numberView = self.numberStackView.arrangedSubviews[deleteNumberIdx] as! UILabel
        
        UIView.animate(withDuration: self.deleteAnimationDuration, delay: 0.0, options: .curveLinear, animations: {
            
            numberView.transform = (deleteNumberIdx != 0) ? CGAffineTransform(translationX: -(numberView.frame.width/2), y: -20) : CGAffineTransform(translationX: -(numberView.frame.width), y: -20)
            
            numberView.alpha = 0.0
            
            numberView.isHidden = true
            
            if deleteNumberIdx == 0 {
                self.currencyView.alpha = 0.0
                self.currencyView.isHidden = true
            }

            self.addFloatingPoint()
            
        }, completion: { _ in
            
            numberView.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
        })
    }
    
    public func deleteNumber() {
        
        if self.price == 0 { return }
        
        self.price = self.price / 10
        
        self.isOverMaximum = false
        
        self.deleteNumberAnimation()
    }
    
    private func setMaximumPriceAnimation() {
        
        self.removeFloatingPoint()
        
        let lastNumberView = self.numberStackView.arrangedSubviews[self.numberLabelCount-1] as! UILabel
        
        lastNumberView.transform = CGAffineTransform(translationX: 0, y: -40)
        
        UIView.animate(withDuration: self.insertAnimationDuration, delay: 0.0, options: .curveLinear, animations: { [weak self] in
            
            guard let self = self else { return }
            
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
            
        }, completion: { _ in
            
            UIView.animate(withDuration: self.insertAnimationDuration, delay: 0.0, options: .curveLinear, animations: {
                
                lastNumberView.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
                lastNumberView.alpha = 1.0
                
                self.shake()
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
        
        let currentNumberCount = self.numberStackView.arrangedSubviews.filter { $0.isHidden == false }.count - 1
        if currentNumberCount < 4 { return }
        
        let floatingPointCount = (currentNumberCount - 1) / 3
        for idx in 1...floatingPointCount {
            
            let floatingPointIdx = (currentNumberCount) - (idx*3)
            
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
        self.placeHolder.isHidden = !isVisible
        self.numberStackView.isHidden = isVisible
    }
    
    func shake() {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");

        translation.values = [-5, 5, -4, 4, -3, 3, -2, 2, 0]
        
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation]
        shakeGroup.duration = shakeAnimationDuration
        self.layer.add(shakeGroup, forKey: "shakeIt")
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
