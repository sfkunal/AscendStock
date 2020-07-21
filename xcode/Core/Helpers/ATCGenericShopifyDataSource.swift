//
//  ATCGenericShopifyDataSource.swift
//  ShoppingApp
//
//  Created by Florian Marcu on 3/17/18.
//  Copyright © 2018 iOS App Templates. All rights reserved.
//

import MobileBuySDK

class ATCGenericShopifyDataSource {
    weak var delegate: ATCGenericCollectionViewControllerDataSourceDelegate?



    func numberOfObjects() -> Int {
        return 1
    }

    func loadFirst() {
        let client = Graph.Client(
            shopDomain: "iosapptemplates.myshopify.com",
            apiKey: "0cfb7301c219271d2d3eed6fe149b84b"
        )

        let query = Storefront.buildQuery { $0
            .shop { $0
                .products(first: 10) { $0
                    .edges { $0
                        .node { $0
                            .id()
                            .title()
                            .productType()
                            .description()
                        }
                    }
                }
            }
        }

        let task = client.queryGraphWith(query) { response, error in
            let collections  = response?.shop.products.edges.map { $0.node }
            collections?.forEach { collection in
                let p = collection.title
                print(p)
            }
        }
        task.resume()
    }

    func loadBottom() {

    }

    func loadTop() {
        
    }

}
