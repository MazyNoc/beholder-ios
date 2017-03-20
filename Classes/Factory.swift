//
//  BeholderFactory.swift
//  Beholder
//
//  Created by Mikael Alfredsson on 20.03.17.
//  Copyright © 2017 Mikael Alfredsson. All rights reserved.
//

import Foundation
import UIKit

class ComponentFactory {

    class ComponentInfo {
        let xibName: String?
        let owner: UIView.Type!
        init (owner: UIView.Type, xib: String?) {
            self.owner = owner
            self.xibName = xib
        }
    }

    var componentInfos = [String: ComponentInfo] ()

    static let mapObj = ComponentFactory.initObjects()

    public static func initObjects() -> [String: ComponentInfo] {
        let result = [String: ComponentInfo]()
        return result
    }



//    static let map = ComponentFactory.initClasses()

    public func register(presenter: Presenter.Type, of component: UIView.Type) {
        componentInfos[String(describing: presenter)] = ComponentInfo(owner: component, xib: nil)
    }

//    public static func initClasses() -> [String: UIView.Type] {
//        var result = [String: UIView.Type]()
//
//        result[String(describing: CardPresenter.self)] = CardView.self
//        result[String(describing: HeaderBodyPresenter.self)] = HeaderBody.self
//        result[String(describing: CollapsiblePresenter.self)] = Collapsible.self
//
//        return result
//    }
//

    public func createHierarchy(_ presenter: Presenter, top: UIView) -> UIView? {

        let presenterName = String(describing: type(of: presenter))

        if let viewClass = componentInfos[presenterName] {
            let view = viewClass.owner.init()
            view.translatesAutoresizingMaskIntoConstraints = false

            if let component = view as? Component {
                component.setPresenter(presenter)
            }

            if let parent = view as? Parent {
                for child in presenter.children {
                    if let childView = createHierarchy(child, top: view) {
                        parent.addChild(childView)
                    }
                }
            }
            return view
        }
        return nil
    }

}
