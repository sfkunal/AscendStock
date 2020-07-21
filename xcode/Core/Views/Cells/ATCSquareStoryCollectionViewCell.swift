//
//  ATCSquareStoryCollectionViewCell.swift
//  ListingApp
//
//  Created by Florian Marcu on 6/9/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class ATCSquareStoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet var storyContainerView: UIView!
    @IBOutlet var storyImageView: UIImageView!
    @IBOutlet var storyLabel: UILabel!

    func configure(uiConfig: ATCUIGenericConfigurationProtocol, viewModel: ATCStoryViewModel) {
        storyContainerView.layer.borderWidth = 1
        storyContainerView.layer.borderColor = uiConfig.hairlineColor.cgColor
        storyContainerView.layer.cornerRadius = 5
        storyContainerView.clipsToBounds = true
        storyContainerView.layer.masksToBounds = true

        // Shadow
//        storyContainerView.dropShadow()

        storyImageView.contentMode = .scaleAspectFill
        storyImageView.layer.masksToBounds = true
        storyImageView.clipsToBounds = true
        storyLabel.font = uiConfig.mediumBoldFont

        storyImageView.kf.setImage(with: URL(string: viewModel.imageURLString))
        storyLabel.text = viewModel.title
    }
}
