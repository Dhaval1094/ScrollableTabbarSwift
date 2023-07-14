//
//  Constants.swift

//  Created by Dhaval Trivedi on 10/07/23.
//

import UIKit

//MARK: - General Constant
let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
let appDelegate = UIApplication.shared.delegate as! AppDelegate

//MARK: - API Components
struct API {
    static let baseURL = "https://apollo-fullstack-tutorial.herokuapp.com/graphql"
}

//MARK: - CollectionViewCell Identifiers
struct CollCellIdentifier {
    static let PhotoList = "HomeCollectionCell"
}

//MARK: - Navigation Titles
struct NavigationTitle {
    static let HomeViewTitle = "Appolo"
}
