//
//  UIViewController+ATCAdditions.swift
//  ShoppingApp
//
//  Created by Florian Marcu on 9/2/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import UIKit

extension UIViewController {

    func addChildViewControllerWithView(_ childViewController: UIViewController, toView view: UIView? = nil) {
        let view: UIView = view ?? self.view

        childViewController.removeFromParent()
        childViewController.willMove(toParent: self)
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    func removeChildViewController(_ childViewController: UIViewController) {
        childViewController.removeFromParent()
        childViewController.willMove(toParent: nil)
        childViewController.removeFromParent()
        childViewController.didMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
