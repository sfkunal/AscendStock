//
//  InstaLinePageControl.swift
//  DatingApp
//
//  Created by Florian Marcu on 1/26/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class InstaLinePageControl: UIControl {
    var numberOfPages: Int = 0 {
        didSet {
            update()
        }
    }

    var selectedPage: Int = 0 {
        didSet {
            update()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if numberOfPages == 0 {
            return
        }
        let spacing: CGFloat = 2.0
        let height: CGFloat = 3
        let subviewWidth = ((self.bounds.width - CGFloat(self.numberOfPages - 1) * spacing) / CGFloat(numberOfPages))
        var currentX: CGFloat = 0
        for view in subviews {
            view.frame = CGRect(x: currentX, y: self.bounds.minY, width: subviewWidth, height: height)
            currentX += subviewWidth + spacing
        }
    }

    fileprivate func update() {
        self.backgroundColor = .clear
        self.subviews.forEach({$0.removeFromSuperview()})
        for i in 0 ..< numberOfPages {
            let view = UIView()
            view.backgroundColor = (i == selectedPage) ? .white : UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.4)
            view.layer.cornerRadius = 1.0
            self.addSubview(view)
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
}
