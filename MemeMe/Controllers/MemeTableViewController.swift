//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Edgar Cobos on 2019-08-12.
//  Copyright © 2019 Edgar Cobos. All rights reserved.
//

import UIKit
import PureLayout

class MemeTableViewController: UITableViewController {

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setEmptyView(message: "You don't have any memes yet. All your memes will show up here.")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    @IBAction func addMeme(_ sender: Any) {
        let memeEditor = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController")
        present(memeEditor, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if memes.count == 0 {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
        }
        else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }
        
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as! MemeTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.tableImageView?.image = meme.memedImage
        cell.topLabel.text = meme.topText
        cell.bottomLabel.text = meme.bottomText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }

}

extension UITableView {
    
    func setEmptyView(message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let label = UILabel.newAutoLayout()
        label.textColor = UIColor.gray
        label.font = UIFont(name: "HelveticaNeue-Regular", size: 18)
        emptyView.addSubview(label)
        label.autoAlignAxis(toSuperviewAxis: .vertical)
        label.autoAlignAxis(toSuperviewAxis: .horizontal)
        label.autoSetDimension(.width, toSize: 300)
        label.text = message
        label.numberOfLines = 0
        label.textAlignment = .center
        self.backgroundView = emptyView
    }
    
}
