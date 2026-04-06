import UIKit
import MapKit

class LocationDetailViewController: UIViewController, LocationSelectionDelegate {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didSelectLocation(_ location: Location) {
        idLabel?.text = "ID: \(location.id)"
        nameLabel?.text = "Name: \(location.name)"
        latitudeLabel?.text = "Latitude: \(location.latitude)"
        longitudeLabel?.text = "Longitude: \(location.longitude)"
        
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        
        // Remove existing annotations
        if let map = mapView {
            map.removeAnnotations(map.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = location.name
            map.addAnnotation(annotation)
            
            let regionRadius: CLLocationDistance = 5000
            let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            map.setRegion(coordinateRegion, animated: true)
        }
    }
}
