//
//  SMSView.swift
//  PINViewExample
//
//  Created by 高松幸平 on 2019/12/07.
//  Copyright © 2019 gaopin1534. All rights reserved.
//

import UIKit

class SMSView: UIView {
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var virtualTextField: UITextField!
    
    private var codes = [Int]()
    private var digit = 0
    private var codeLabels = [UILabel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func configure(with digit: Int) {
        self.digit = digit
        for _ in 1...digit {
            let (labelView, label) = codeLabel()
            codeLabels.append(label)
            stack.addArrangedSubview(labelView)
        }
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("SMSView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        virtualTextField.tintColor = .clear
        virtualTextField.keyboardType = .numberPad
        virtualTextField.textContentType = .oneTimeCode
        virtualTextField.becomeFirstResponder()
        virtualTextField.delegate = self
    }
    
    private func codeLabel() -> (UIView, UILabel) {
        let container = UIView()
        let label = UILabel()
        let bottomLine = UIView()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 40)
        
        container.addSubview(label)
        container.addSubview(bottomLine)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalToSystemSpacingAfter: container.leftAnchor, multiplier: 0).isActive = true
        label.rightAnchor.constraint(equalToSystemSpacingAfter: container.rightAnchor, multiplier: 0).isActive = true
        label.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bottomLine.backgroundColor = .lightGray
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 10).isActive = true
        bottomLine.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -10).isActive = true
        bottomLine.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        return (container, label)
    }
    
    private func syncView() {
        for (i, label) in codeLabels.enumerated() {
            if codes.count <= i || codes.count == 0 {
                label.text = nil
                return
            }
            label.text = String(codes[i])
        }
        virtualTextField.text = codes.map {String($0)}.joined()
    }
}

extension SMSView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty && !codes.isEmpty {
            codes.removeLast()
            syncView()
            return true
        }
        if codes.count >= digit {
            return false
        }
        if string.count > 1 {
            for char in string.compactMap({ $0 }) {
                guard let i = Int(String(char)), codes.count < digit else {
                    return true
                }
                codes.append(i)
            }
            
        } else {
            guard let code = Int(string) else {
                return false
            }
            codes.append(code)
        }
        syncView()
        return true
    }
}
