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

    let insertButton = UIButton()
    let insertButton2 = UIButton()
    let insertButton3 = UIButton()

    let clearButton = UIButton()
    let deleteButton = UIButton()
    var testView: AmazingPriceView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        testView = AmazingPriceView.init(.boldSystemFont(ofSize: 36.0), .black, .systemPink, 36.0, 2000000, 1000, 0.08, 0.10, 0.30, .KOR)
//        testView?.initPlaceHolder("금액을 입력하세요", .boldSystemFont(ofSize: 36.0), .systemPink)
        testView = AmazingPriceView(font: .boldSystemFont(ofSize: 36.0), fontSize: 36.0, minimumPrice: 1000, maximumPrice: 20000000000)
        testView?.fontColor = .black
        testView?.maximumPricefontColor = .blue
        testView?.placeHolder = "안녕하세요"
        testView?.delegate = self
        self.view.addSubview(testView!)
        testView?.translatesAutoresizingMaskIntoConstraints = false
        testView?.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor, constant: 50.0).isActive = true
        testView?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.view.addSubview(self.insertButton)
        self.insertButton.setTitle("1", for: .normal)
        self.insertButton.backgroundColor = .lightGray
        self.insertButton.translatesAutoresizingMaskIntoConstraints = false
        self.insertButton.topAnchor.constraint(equalTo: self.testView!.bottomAnchor, constant: 100.0).isActive = true
        self.insertButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.insertButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.insertButton.addTarget(self, action: #selector(insertOneClicked), for: .touchUpInside)
        
        self.view.addSubview(self.insertButton2)
        self.insertButton2.setTitle("2", for: .normal)
        self.insertButton2.backgroundColor = .lightGray
        self.insertButton2.translatesAutoresizingMaskIntoConstraints = false
        self.insertButton2.topAnchor.constraint(equalTo: self.insertButton.bottomAnchor, constant: 15.0).isActive = true
        self.insertButton2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.insertButton2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.insertButton2.addTarget(self, action: #selector(insertTwoClicked), for: .touchUpInside)

        self.view.addSubview(self.insertButton3)
        self.insertButton3.setTitle("3", for: .normal)
        self.insertButton3.backgroundColor = .lightGray
        self.insertButton3.translatesAutoresizingMaskIntoConstraints = false
        self.insertButton3.topAnchor.constraint(equalTo: self.insertButton2.bottomAnchor, constant: 15.0).isActive = true
        self.insertButton3.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.insertButton3.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.insertButton3.addTarget(self, action: #selector(insertThreeClicked), for: .touchUpInside)
        
        self.view.addSubview(self.clearButton)
        self.clearButton.setTitle("clear", for: .normal)
        self.clearButton.backgroundColor = .lightGray
        self.clearButton.translatesAutoresizingMaskIntoConstraints = false
        self.clearButton.topAnchor.constraint(equalTo: self.insertButton3.bottomAnchor, constant: 15.0).isActive = true
        self.clearButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.clearButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.clearButton.addTarget(self, action: #selector(clearClicked), for: .touchUpInside)

        self.view.addSubview(self.deleteButton)
        self.deleteButton.setTitle("delete", for: .normal)
        self.deleteButton.backgroundColor = .lightGray
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = false
        self.deleteButton.topAnchor.constraint(equalTo: self.clearButton.bottomAnchor, constant: 15.0).isActive = true
        self.deleteButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.deleteButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.deleteButton.addTarget(self, action: #selector(deleteClicked), for: .touchUpInside)
    }

    @objc func clearClicked() {
        self.testView?.clear()
    }

    @objc func deleteClicked() {
        self.testView?.deleteNumber()
    }

    @objc func insertOneClicked() {
        self.testView?.insertNumber(1)
    }
    
    @objc func insertTwoClicked() {
        self.testView?.insertNumber(2)
    }
    
    @objc func insertThreeClicked() {
        self.testView?.insertNumber(3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

@available(iOS 10.0, *)
extension ViewController: AmazingPriceViewDelegate {
    func isPriceOverMaximumPrice(isOverMaximumPrice: Bool) {
    }
    
    func isPriceOverMinimumPrice(isOverMinimumPrice: Bool) {
    }
}

