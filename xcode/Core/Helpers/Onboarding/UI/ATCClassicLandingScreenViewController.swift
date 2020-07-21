//
//  ATCClassicLandingScreenViewController.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/8/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class ATCClassicLandingScreenViewController: UIViewController, ATCLandingScreenProtocol {
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signUpButton: UIButton!

    weak var delegate: ATCLandingScreenDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.landingScreenDidLoadView(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
