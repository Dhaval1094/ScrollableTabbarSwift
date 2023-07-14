//
//  ReusableView.swift

//  Created by Dhaval Trivedi on 10/07/23.
//
import UIKit

public protocol ReusableView: class {
    static var reuseIdentity: String { get }
}

extension ReusableView where Self: UIView {
    public static var reuseIdentity: String {
        return "\(self)"
    }
}
