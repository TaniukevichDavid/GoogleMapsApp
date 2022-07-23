
import Foundation

struct Coordinates: Codable {
    let point: Point
    var lang_id = 3
    
    struct Point: Codable {
        let lat: Double
        let lng: Double
    }
}
