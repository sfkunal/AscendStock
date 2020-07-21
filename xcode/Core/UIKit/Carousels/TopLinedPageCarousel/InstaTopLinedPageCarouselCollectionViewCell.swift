//
//  InstaTopLinedPageCarouselCollectionViewCell.swift
//  DatingApp
//
//  Created by Florian Marcu on 1/26/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class InstaTopLinedPageCarouselCollectionViewCell: UICollectionViewCell, ATCGenericCollectionViewScrollDelegate {
    @IBOutlet var containerView: UIView!
    @IBOutlet var carouselContainerView: UIView!
    @IBOutlet var linePageControl: InstaLinePageControl!
    
    func genericScrollView(_ scrollView: UIScrollView, didScrollToPage page: Int) {
        linePageControl.selectedPage = page
    }
}
