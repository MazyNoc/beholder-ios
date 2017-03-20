//
//  ViewController.swift
//  Beholder
//
//  Created by Mikael Alfredsson on 20.03.17.
//  Copyright © 2017 Mikael Alfredsson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var rootView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let factory = ComponentFactory()
        factory.register(presenter: SingleLinePresenter.self, of: SingleLineView.self)

        var presenters: [Presenter] = []
        presenters.append(SingleLinePresenter())
        presenters.append(SingleLinePresenter())
        presenters.append(SingleLinePresenter())


        presenters.forEach { pres in
            let view = factory.createHierarchy(pres, top: rootView)
            if let view = view {
                rootView.addArrangedSubview(view)
                print("adding")
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class SingleLinePresenter: Presenter {

}
