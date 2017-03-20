//
//  SingleLineView.swift
//  Beholder
//
//  Created by Mikael Alfredsson on 20.03.17.
//  Copyright © 2017 Mikael Alfredsson. All rights reserved.
//

import Foundation
import UIKit


class SingleLinePresenter: Presenter {
    var text: String = "my text"
}

class SingleLineView: ViewHolder<SingleLinePresenter> {

    @IBOutlet var view: UIView!
    @IBOutlet weak var label: UILabel!

    required init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func updateData(presenter: SingleLinePresenter) {
        label.text = presenter.text
    }

}
