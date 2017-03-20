//
//  DualLineView.swift
//  Beholder
//
//  Created by Mikael Alfredsson on 20.03.17.
//  Copyright © 2017 Mikael Alfredsson. All rights reserved.
//

import Foundation
import UIKit


class DualLinePresenter: Presenter {
    var title: String = "A Title"
    var text: String = "Some text that belongs to a title"
}

class DualLineView: ViewHolder<DualLinePresenter> {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var text: UILabel!
   
    required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateData(presenter: DualLinePresenter) {
        title.text = presenter.title
        text.text = presenter.text
    }
    
}
