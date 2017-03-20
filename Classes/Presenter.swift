//
//  Presenter.swift
//  Beholder
//
//  Created by Mikael Alfredsson on 20.03.17.
//  Copyright © 2017 Mikael Alfredsson. All rights reserved.
//

import Foundation
import UIKit

class Presenter {

    var children: [Presenter] = []

    func addChild(_ weff: Presenter) {
        children.append(weff)
    }

    class func layoutHash() -> Int { return String(describing: self).hashValue }

    func deepLayoutHash() -> Int {
        return children.map { type(of: $0).layoutHash() }.reduce(type(of: self).layoutHash(), { result, value in combineHash(current: result, next: value) })
    }

    func deepLayoutIdentifier() -> String {
        return String(deepLayoutHash())
    }

    private func combineHash(current: Int, next: Int) -> Int {
        let mult = Int.multiplyWithOverflow(31, current).0
        return Int.addWithOverflow(mult, next).0
    }

    public subscript(name: String) -> Any? {
        let m = Mirror(reflecting: self)
        return m.children.first { (label, value) in
            label == name
        }?.value
    }
}

protocol Parent {
    func addChild(_ view: UIView)
}

protocol Component {
    init(frame: CGRect)
    func setPresenter(_ presenter: Presenter)
    func getRoot() -> UIView
}

class ViewHolder: UIView, Component {

    override required init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // fatalError("init(coder:) has not been implemented")
    }

    func setPresenter(_ presenter: Presenter) {

    }

    func getRoot() -> UIView {
        return self
    }
}

class ViewHolderGroup: ViewHolder, Parent {
    func addChild(_ view: UIView) {

    }

    override func setPresenter(_ presenter: Presenter) {
        populateChildren(views: subviews, presenters: presenter.children)
    }
}

extension UIView {

    func setupComponent(nibName: String?) {
        let bundle = Bundle(for: type(of: self))
        let nib: String! = nibName != nil ? nibName : String(describing: type(of: self))
        UINib(nibName: nib, bundle: bundle).instantiate(withOwner: self, options: nil)
        addSubview(self)
        self.frame = bounds
    }

    func nibSetup() {
        let view = loadViewFromNib()
        view.frame = bounds
        addSubview(view)
    }

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }

    func populateChildren(views: [UIView], presenters: [Presenter]) {
        zip(views, presenters).forEach { (view, presenter) in
            if let component = view as? Component {
                component.setPresenter(presenter)
            }
        }
    }

}