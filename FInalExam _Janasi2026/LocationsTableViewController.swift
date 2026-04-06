import UIKit

protocol LocationSelectionDelegate: AnyObject {
    func didSelectLocation(_ location: Location)
}

class LocationsTableViewController: UITableViewController {
    
    var locations: [Location] = []
    weak var delegate: LocationSelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LocationCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locations = DatabaseHelper.shared.getAllLocations()
        tableView.reloadData()
        
        if let first = locations.first, delegate == nil, let split = splitViewController, let detailNC = split.viewControllers.last as? UINavigationController, let detailVC = detailNC.topViewController as? LocationDetailViewController {
            self.delegate = detailVC
            delegate?.didSelectLocation(first)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let location = locations[indexPath.row]
        cell.textLabel?.text = "ID: \(location.id) - \(location.name)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        
        if let split = splitViewController {
            let detailNavigationController = split.viewControllers.last as? UINavigationController
            if let detailViewController = detailNavigationController?.topViewController as? LocationDetailViewController {
                delegate = detailViewController
                delegate?.didSelectLocation(location)
            } else if let detailViewController = split.viewControllers.last as? LocationDetailViewController {
                 delegate = detailViewController
                 delegate?.didSelectLocation(location)
            }
        }
    }

    @IBAction func unwindToSavedLocations(_ unwindSegue: UIStoryboardSegue) {
        // Allows you to manually connect 'Exit' proxies back to this Split View Locations Controller
    }
}
