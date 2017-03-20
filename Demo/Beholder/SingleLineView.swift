//
//  SingleLineView.swift
//  Beholder
//
//  Created by Mikael Alfredsson on 20.03.17.
//  Copyright © 2017 Mikael Alfredsson. All rights reserved.
//

import Foundation
import UIKit

class SingleLineView: ViewHolder {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var label: UILabel!
    
    required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupComponent(nibName: "SingleLineView")
    }
    
    override func setPresenter(_ presenter: Presenter){
        super.setPresenter(presenter)
        label.text = "testing"
    }
    
    override func getRoot() -> UIView {
        return self
    }
}
