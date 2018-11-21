//
//  ShareButton.swift
//  encryptionTimeTest
//
//  Created by Jakub Tudruj on 22/11/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import UIKit

class ShareButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : 0.5
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    private func setupButton() {
        setTitleColor(UIColor.white, for: .normal)
        backgroundColor = UIColor.purple
    }
    
}
