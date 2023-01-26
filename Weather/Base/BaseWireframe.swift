//
//  BaseWirefram.swift
//  Weather
//
//  Created by Juan Dario Delgado Lasso on 25/01/23.
//

import UIKit

protocol WireframeInterface: AnyObject { }

class BaseWireframe {

    unowned var _viewController: UIViewController
    var _temporaryStoredViewController: UIViewController?

    init(viewController: UIViewController) {
        _temporaryStoredViewController = viewController
        _viewController = viewController
    }
}

extension BaseWireframe: WireframeInterface { }

extension BaseWireframe {
    
    var viewController: UIViewController {
        defer { _temporaryStoredViewController = nil }
        return _viewController
    }
    
    var navigationController: UINavigationController? {
        return viewController.navigationController
    }
}
