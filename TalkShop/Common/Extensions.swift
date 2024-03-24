//
//  Extensions.swift
//  TalkShop
//
//  Created by Samarth on 22/03/24.
//

import Foundation
import UIKit

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView { }
extension UICollectionViewCell: ReusableView { }

extension UITableView {
    func registerNib<Cell: UITableViewCell>(cellType _: Cell.Type, bundle: Bundle? = nil) {
        let nibName: String = String(describing: Cell.self)
        let cellNib: UINib = UINib(nibName: nibName, bundle: bundle)
        register(cellNib, forCellReuseIdentifier: Cell.defaultReuseIdentifier)
    }
}

extension UICollectionView: ReusableView {
    
    func registerNib<Cell: UICollectionViewCell>(cellType _: Cell.Type, bundle: Bundle? = nil) {
        let nibName: String = String(describing: Cell.self)
        let cellNib: UINib = UINib(nibName: nibName, bundle: bundle)
        register(cellNib, forCellWithReuseIdentifier: Cell.defaultReuseIdentifier)
    }
    
}
