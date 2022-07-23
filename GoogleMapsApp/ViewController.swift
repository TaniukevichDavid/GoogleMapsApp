
import UIKit
import GoogleMaps
import CoreLocation
import Alamofire

class ViewController: UIViewController {
    
    var coordinates = [Coordinates]()
    let manager = CLLocationManager()
    let mapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGMSMapView()
        getData(url: "https://fish-pits.krokam.by/api/rest/points/")
        configureLocationManager()
    }
    
    private func setUpGMSMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isMyLocationEnabled = true
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func getData(url: String) {
        Alamofire.request(url).responseJSON { responce in
            guard let result = responce.data else { return }
            do {
                self.coordinates = try JSONDecoder().decode([Coordinates].self, from: result)
                DispatchQueue.main.async {
                    self.createPoints(markers: self.coordinates)
                }
            } catch  {
                print(error.localizedDescription)
            }
        }
    }
    
    private func createPoints(markers: [Coordinates]) {
        for marker in markers {
            let position = CLLocationCoordinate2D(latitude: marker.point.lat, longitude: marker.point.lng)
            let marker = GMSMarker(position: position)
            marker.map = self.mapView
            mapView.animate(toLocation: CLLocationCoordinate2D(latitude: 53.893009, longitude: 27.567444))
            mapView.animate(toZoom: 6)
        }
    }
    
    private func configureLocationManager() {
        manager.startUpdatingLocation()
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
    }
}

