//
//  ViewController.swift
//  ChallengeDay59
//
//  Created by Георгий Евсеев on 1.09.22.
//

import UIKit

class ViewController: UITableViewController {
    var cities = [City]()
    var citiesFilter: String = ""
    var citiesTitle = String()
    var citiesSearching: [City] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(openTapped))

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(startSearch))

        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)

                return
            }
        }
        performSelector(inBackground: #selector(submit), with: nil)
        showError()
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Cities of Belarus", message: nil, preferredStyle: .alert)

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonCities = try? decoder.decode(Cities.self, from: json) {
            cities = jsonCities.results
            citiesSearching = cities
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    @objc func startSearch() {
        let ac = UIAlertController(title: "Search...", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Open", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
        citiesSearching.removeAll()
    }

    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    @objc func submit(_ answer: String) {
        citiesFilter.append(answer)
        for city in cities {
            if city.title.contains(citiesFilter) {
                citiesSearching.append(city)
            }

            if citiesFilter.isEmpty {
                citiesSearching = cities
            }
        }

        tableView.reloadData()
        citiesFilter.removeAll()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesSearching.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let city = citiesSearching[indexPath.row]
        citiesTitle = city.title
        cell.textLabel?.text = city.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailTableViewController()
        vc.detailItem = cities[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
