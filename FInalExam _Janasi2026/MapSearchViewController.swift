import UIKit
import MapKit
import CoreLocation

class MapSearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: 43.6532, longitude: -79.3832) // Toronto
        centerMapOnLocation(location: initialLocation)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832)
        annotation.title = "Toronto"
        mapView.addAnnotation(annotation)
        
        searchButton.addTarget(self, action: #selector(performSearch), for: .touchUpInside)
        searchTextField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch()
        return true
    }

    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 10000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    @objc func performSearch() {
        guard let searchText = searchTextField.text, !searchText.isEmpty else { return }
        
        searchTextField.resignFirstResponder()
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchText) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    let errorAlert = UIAlertController(title: "Location Not Found", message: "Could not find any results for that search.", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(errorAlert, animated: true)
                    return
                }
                
                if let placemark = placemarks?.first, let location = placemark.location {
                    let name = placemark.name ?? searchText
                    let lat = location.coordinate.latitude
                    let lon = location.coordinate.longitude
                    
                    // Add annotation
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location.coordinate
                    annotation.title = name
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.mapView.addAnnotation(annotation)
                    self.centerMapOnLocation(location: location)
                    
                    // Save to database
                    DatabaseHelper.shared.insertLocation(name: name, latitude: lat, longitude: lon)
                    
                    let alert = UIAlertController(title: "Saved", message: "Location saved to database.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }

    @IBAction func unwindToMapSearch(_ unwindSegue: UIStoryboardSegue) {
        // Allows you to manually connect 'Exit' proxies back to this Map Search View Controller
    }
}
