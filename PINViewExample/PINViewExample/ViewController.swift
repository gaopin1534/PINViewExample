//
//  ViewController.swift
//  PINViewExample
//
//  Created by gaopin1534 on 2019/12/07.
//  Copyright © 2019 gaopin1534. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var upperStackView: UIStackView!
    @IBOutlet weak var lowerStackView: UIStackView!
    let digit = 4
    var number = [Int]()
    var inputIndicators = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for _ in 1...digit {
            let indicator = UILabel.circle
            inputIndicators.append(indicator)
            upperStackView.addArrangedSubview(indicator)
        }
        
        let firstLow = makeLow(from: 1, to: 3)
        let secondLow = makeLow(from: 4, to: 6)
        let thirdLow = makeLow(from: 7, to: 9)
        
        let fourthLow = UIStackView.horizontal
        let zeroPad = NumPadLikeUILabel(of: 0)
        zeroPad.registerTap(target: self, action: #selector(numPadDidTapped(_:)))
        let deleteButton = UILabel()
        deleteButton.text = "←"
        deleteButton.bottunify()
        
        let deleteTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteDidTapped))
       deleteTapRecognizer.delegate = self
        deleteButton.addGestureRecognizer(deleteTapRecognizer)
        [zeroPad, deleteButton].forEach { fourthLow.addArrangedSubview($0) }
        
        [firstLow, secondLow, thirdLow, fourthLow].forEach { lowerStackView.addArrangedSubview($0) }
    }
    
    @objc func numPadDidTapped(_ sender: UITapGestureRecognizer) {
        guard let pad = sender.view as? NumPadLikeUILabel else {
            return
        }
        if number.count >= digit {
            return
        }
        
        number.append(pad.number)
        syncViewAndNum()
        
        if number.count == digit {
            guard let nextVC = UIStoryboard.init(name: "SMSStoryboard", bundle: nil).instantiateInitialViewController() else {
                return
            }
            present(nextVC, animated: true, completion: nil)
        }
    }
    
    @objc func deleteDidTapped() {
        number.removeLast()
        syncViewAndNum()
    }
    
    private func syncViewAndNum() {
        for (i, elm) in inputIndicators.enumerated() {
            elm.textColor =  (i < number.count) ? .blue : .gray
        }
    }
    
    private func makeLow(from: Int, to: Int) -> UIStackView {
        let low = UIStackView.horizontal
        for i in from...to {
            let numPad = NumPadLikeUILabel(of: i)
            numPad.registerTap(target: self, action: #selector(numPadDidTapped(_:)))
            low.addArrangedSubview(numPad)
        }
        return low
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    
}

fileprivate extension UILabel {
    static var circle: UILabel {
        let uiLabel = UILabel()
        uiLabel.text = "●"
        uiLabel.font = UIFont.systemFont(ofSize: 60)
        uiLabel.textColor = .gray
        uiLabel.textAlignment = .center
        return uiLabel
    }
    
    func bottunify() {
        font = .systemFont(ofSize: 40)
        textColor = .blue
        textAlignment = .center
        isUserInteractionEnabled = true
    }
}

fileprivate extension UIStackView {
    static var horizontal: UIStackView {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.distribution = .fillEqually
        return stackview
    }
}

fileprivate class NumPadLikeUILabel: UILabel {
    let number: Int
    init(of number: Int) {
        self.number = number
        super.init(frame: .zero)
        text = String(number)
        bottunify()
    }
    
    required init?(coder: NSCoder) {
        number = 0
        super.init(coder: coder)
    }
    
    func registerTap(target: UIGestureRecognizerDelegate, action: Selector) {
        let gestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = target
        addGestureRecognizer(gestureRecognizer)
    }
}

