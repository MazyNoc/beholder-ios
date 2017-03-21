//
//  Mock.swift
//  Beholder
//
//  Created by Mikael Alfredsson on 20.03.17.
//  Copyright © 2017 Mikael Alfredsson. All rights reserved.
//

import Foundation

class Mock {

    static let factory = ComponentFactory()
    static var presenters: [Presenter] = []

    static func i() {
        factory.register(presenter: SingleLinePresenter.self, of: SingleLineView.self)
        factory.register(presenter: DualLinePresenter.self, of: DualLineView.self)

        presenters.append(SingleLinePresenter())
        presenters.append(DualLinePresenter())
        presenters.append(SingleLinePresenter())
    }
}
