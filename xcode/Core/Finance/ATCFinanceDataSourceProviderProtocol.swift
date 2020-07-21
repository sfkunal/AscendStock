//
//  FinanceDataSourceProviderProtocol.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/16/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

protocol ATCFinanceDataSourceProviderProtocol: class {
    var user: ATCUser? { get set }

    func fetchLineChart(for selectedDate: ATCChartDate, completion: (_ chart: ATCLineChart?) -> Void) -> Void
    func fetchCryptosChart(for selectedDate: ATCChartDate, completion: (_ chart: ATCLineChart?) -> Void) -> Void
    func fetchAssetChart(for asset: ATCFinanceAsset, selectedDate: ATCChartDate, completion: (_ chart: ATCLineChart?) -> Void) -> Void
    func fetchAssetDetails(for user: ATCUser?, asset: ATCFinanceAsset, completion: (_ position: ATCFinanceAssetPosition?, _ stats: ATCFinanceAssetStats, _ news: [ATCFinanceNewsModel]) -> Void) -> Void
    func fetchBankAccountChart(for account: ATCFinanceAccount, selectedDate: ATCChartDate, completion: (_ chart: ATCLineChart?) -> Void) -> Void

    var chartConfig: ATCLineChartConfiguration { get }
    var profileUpdater: ATCProfileUpdaterProtocol {get}
}
