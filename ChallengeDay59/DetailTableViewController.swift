//
//  DetailTableViewController.swift
//  ChallengeDay59
//
//  Created by Георгий Евсеев on 3.09.22.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var detailItem: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = detailItem?.body

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Detail", for: indexPath)
//        let city = detailItem?.[indexPath.row]
//        citiesTitle = city.title
        cell.textLabel?.text = detailItem?.title
        return cell
    }

    

}
