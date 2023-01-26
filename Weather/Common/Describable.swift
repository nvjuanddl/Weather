//
//  Describable.swift
//  Weather
//
//  Created by Juan Dario Delgado L on 25/01/23.
//

import UIKit

protocol Describable {
    static var name: String { get }
}

extension Describable {
    static var name: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Describable { }
extension UICollectionReusableView: Describable { }
extension UITableViewHeaderFooterView: Describable { }
