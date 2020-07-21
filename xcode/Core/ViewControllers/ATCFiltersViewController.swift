//
//  ATCFiltersViewController.swift
//  ListingApp
//
//  Created by Florian Marcu on 6/16/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

protocol ATCFiltersViewControllerDelegate: class {
    func filtersViewController(_ vc: ATCFiltersViewController, didUpdateTo filters:[ATCSelectFilter])
}

class ATCFiltersViewController: ATCGenericCollectionViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    private var currentSelectFilter: ATCSelectFilter?
    private var currentSelectedOptionOfCurrentSelectFilter: ATCFilterOption?
    let localFiltersStore: ATCLocalFiltersStore?

    weak var delegate: ATCFiltersViewControllerDelegate?

    init(uiConfig: ATCUIGenericConfigurationProtocol,
         dataSource: ATCGenericCollectionViewControllerDataSource,
         localFiltersStore: ATCLocalFiltersStore?) {
        self.localFiltersStore = localFiltersStore

        let layout = ATCLiquidCollectionViewLayout(cellPadding: 0)
        let config = ATCGenericCollectionViewControllerConfiguration(pullToRefreshEnabled: false,
                                                                     pullToRefreshTintColor: .white,
                                                                     collectionViewBackgroundColor: .white,
                                                                     collectionViewLayout: layout,
                                                                     collectionPagingEnabled: false,
                                                                     hideScrollIndicators: true,
                                                                     hidesNavigationBar: false,
                                                                     headerNibName: nil,
                                                                     scrollEnabled: true,
                                                                     uiConfig: uiConfig)
        super.init(configuration: config)
        self.selectionBlock = {[weak self] (navController, object, indexPath) in
            guard let strongSelf = self else { return }
            if let selectFilter = object as? ATCSelectFilter {
                strongSelf.currentSelectFilter = selectFilter
                strongSelf.currentSelectedOptionOfCurrentSelectFilter = selectFilter.selectedOption
                strongSelf.presentCurrentFilter()
            }
        }
        let adapter = ATCSelectFilterRowAdapter(titleFont: uiConfig.regularLargeFont,
                                                titleColor: uiConfig.mainTextColor,
                                                optionFont: uiConfig.regularMediumFont,
                                                height: 70)
        self.use(adapter: adapter, for: "ATCSelectFilter")

        var filtersDataSource: ATCGenericCollectionViewControllerDataSource = dataSource
        if let localFiltersStore = localFiltersStore, localFiltersStore.filters.count > 0 {
            filtersDataSource  = ATCGenericLocalDataSource<ATCSelectFilter>(items: localFiltersStore.filters)

        }
        self.genericDataSource = filtersDataSource
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let currentSelectFilter = currentSelectFilter {
            return currentSelectFilter.options.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let option = currentSelectFilter?.options[row] {
            return option.name
        }
        return ""
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let currentSelectFilter = currentSelectFilter {
            currentSelectedOptionOfCurrentSelectFilter = currentSelectFilter.options[row]
        }
    }

    private func presentCurrentFilter() {
        guard let currentSelectFilter = currentSelectFilter else {
            return
        }
        currentSelectedOptionOfCurrentSelectFilter = currentSelectFilter.options[0]

        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250, height: 250)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let alert = UIAlertController(title: currentSelectFilter.title, message: "", preferredStyle: UIAlertController.Style.alert)
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {[weak self] (action) in
            guard let strongSelf = self else { return }
            currentSelectFilter.selectedOption = strongSelf.currentSelectedOptionOfCurrentSelectFilter
            strongSelf.collectionView?.reloadData()
            strongSelf.currentSelectFilter = nil
            strongSelf.currentSelectedOptionOfCurrentSelectFilter = nil
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {[weak self] (action) in
            guard let strongSelf = self else { return }
            strongSelf.currentSelectFilter = nil
            strongSelf.currentSelectedOptionOfCurrentSelectFilter = nil
        }))

        self.present(alert, animated: true)
    }

    @objc private func didTapDoneButton() {
        if let ds = self.genericDataSource {
            var newFilters: [ATCSelectFilter] = []
            for index in 0 ..< ds.numberOfObjects() {
                if let filter = ds.object(at: index) as? ATCSelectFilter {
                    newFilters.append(filter)
                }
            }
            localFiltersStore?.filters = newFilters
            self.delegate?.filtersViewController(self, didUpdateTo: newFilters)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
