//
//  KeypadCellCollectionViewCell.swift
//  AmazingPriceView
//
//  Created by Minjee Kim on 2021/02/17.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class KeypadCell: UICollectionViewCell {
    
    @IBOutlet weak var keyLabel: UILabel!
    
    static let HEIGHT: CGFloat = 50
    
    enum KEY : Int {
        case delete = -1
        case clear = -2
        case blank = -3
        case number = 10
    }
    
    class func keyType(for key: Int) -> KEY {
        
        if key >= 0 {
            return .number
            
        } else if key == KEY.delete.rawValue {
            return .delete
            
        } else if key == KEY.clear.rawValue {
            return .clear
            
        } else {
            return .blank
        }
    }
    
    class func getKey(_ indexPath: IndexPath) -> Int {
        
        var value = 0
        
        if indexPath.item < 9 {
            value = indexPath.item + 1
            
        } else if indexPath.item == 9 {
            value = KeypadCell.KEY.clear.rawValue
            
        } else if indexPath.item == 10 {
            value = 0
            
        } else if indexPath.item == 11 {
            value = KeypadCell.KEY.delete.rawValue
            
        } else {
            value = KeypadCell.KEY.blank.rawValue
        }
        
        return value
    }
    
    var key: Int = 0 {
        didSet {
            
            switch KeypadCell.keyType(for: self.key) {
            case .number:
                self.keyLabel.text = "\(self.key)"
                self.keyLabel.font = .systemFont(ofSize: 20)
                
            case .delete:
                self.keyLabel.text = "Back"
                self.keyLabel.font = .systemFont(ofSize: 17)
                
            case .clear:
                self.keyLabel.text = "Clear"
                self.keyLabel.font = .systemFont(ofSize: 17)
                
            default:
                self.keyLabel.text = ""
            }
        }
    }
    
    
    
}
