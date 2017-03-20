//
//  BeholderTableController.swift
//  Beholder
//
//  Created by Mikael Alfredsson on 20.03.17.
//  Copyright © 2017 Mikael Alfredsson. All rights reserved.
//

import UIKit


class BeholderForceRefresh {
    static var callbacks = [() -> ()]()
    
    static func addCallback(f: @escaping ()->()){
        callbacks.append(f)
    }
    
    static func alert(){
        callbacks.forEach{a in a()}
    }
}


class BeholderTableController: UITableViewController {

    let usedIdentifiers: Set<String> = Set();
    var factory: ComponentFactory?
    var data:[Presenter]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 44.0;
        BeholderForceRefresh.addCallback {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let presenter = data[indexPath.row]
        let identifier = presenter.deepLayoutIdentifier()
        if !usedIdentifiers.contains(identifier) {
            tableView.register(BeholderTableViewCell.self, forCellReuseIdentifier: identifier)
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ComponentTableViewCell
        cell.preparePresenter(presenter, identifier: identifier);
        return cell
    }

}


class BeholderTableViewCell: UITableViewCell {

    var prepared = false
    var identifier = ""
    let debug = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func preparePresenter(_ presenter: Presenter, identifier: String, with factory: ComponentFactory) {
        if(prepared) {
            guard self.identifier == identifier else { preconditionFailure("not the same identifier") }
            debug.text = "reused, id:\(identifier)"
            if let component = contentView as? Component {
                component.bindPresenter(presenter);
            }

        } else {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            let viewsDict = ["view": contentView]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: viewsDict))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: viewsDict))

            if let view = factory.createHierarchy(presenter, top: contentView) {
                addComponent(view: view)
            }

            self.identifier = identifier
            prepared = true

            #if (arch(i386) || arch(x86_64)) && os(iOS)
                if ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil {
                    createDebugView()
                }
            #endif
        }
    }

    func addComponent(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(view, at: 0)
        let viewsDict = ["view": view]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: viewsDict))
    }

    func createDebugView() {
        debug.text = "new initialized, id:\(identifier)"
        debug.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3548085387)
        debug.translatesAutoresizingMaskIntoConstraints = false
        debug.font = debug.font.withSize(8.0)
        contentView.addSubview(debug)
        let viewsDict = ["view": debug]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]", options: [], metrics: nil, views: viewsDict))

    }

}

