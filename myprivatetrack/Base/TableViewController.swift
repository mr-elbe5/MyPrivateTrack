/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

open class TableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    public var headerView : UIView? = nil
    public var tableView = UITableView()
    
    override open func loadView() {
        super.loadView()
        let guide = view.safeAreaLayoutGuide
        setupHeaderView()
        if let headerView = headerView{
            view.addSubview(headerView)
            headerView.setAnchors(top: guide.topAnchor, leading: guide.leadingAnchor, trailing: guide.trailingAnchor, insets: .zero)
        }
        view.addSubview(tableView)
        tableView.setAnchors(leading: guide.leadingAnchor, trailing: guide.trailingAnchor, bottom: guide.bottomAnchor, insets: .zero)
            .top(headerView?.bottomAnchor ?? guide.topAnchor, inset: 1)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    open func setupHeaderView(){
        
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
}
