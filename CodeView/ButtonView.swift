//
//  ButtonView.swift
//  CodeView
//
//  Created by Seokho on 2019/12/01.
//  Copyright © 2019 Seokho. All rights reserved.
//

import UIKit

class ButtonView: UIView {
    
    weak var topButton: UIButton?
    weak var middleButton: UIButton?
    weak var bottomButton: UIButton?
    
    init(title: [String]) {
        super.init(frame: .zero)
        
        let button2 = UIButton()
        self.middleButton = button2
        button2.setTitle(title[1], for: .normal)
        button2.titleLabel?.lineBreakMode = .byWordWrapping
        button2.titleLabel?.numberOfLines = 0
        button2.titleLabel?.textAlignment = .center
        button2.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        addSubview(button2)
        button2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button2.centerYAnchor.constraint(equalTo: centerYAnchor),
            button2.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        let button1 = UIButton()
        self.topButton = button1
        button1.setTitle(title[0], for: .normal)
        button1.titleLabel?.lineBreakMode = .byWordWrapping
        button1.titleLabel?.numberOfLines = 0
        button1.titleLabel?.textAlignment = .center
        button1.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        addSubview(button1)
        button1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button1.bottomAnchor.constraint(equalTo: button2.topAnchor,constant: -8),
            button1.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        let button3 = UIButton()
        self.bottomButton = button3
        button3.setTitle(title[2], for: .normal)
        button3.titleLabel?.lineBreakMode = .byWordWrapping
        button3.titleLabel?.numberOfLines = 0
        button3.titleLabel?.textAlignment = .center
        button3.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        addSubview(button3)
        button3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button3.topAnchor.constraint(equalTo: button2.bottomAnchor,constant: 8),
            button3.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

