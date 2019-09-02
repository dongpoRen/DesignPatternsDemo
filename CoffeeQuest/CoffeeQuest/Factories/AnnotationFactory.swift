import UIKit
import MapKit
import YelpAPI

public class AnnotationFactory {
  
  public func createBusinessMapViewModel(
    for business: Business) -> BusinessMapViewModel? {
    
    let name = business.name
    let rating = business.rating
    let image: UIImage
    
    switch rating {
    case 0.0..<3.5:
    image = UIImage(named: "terrible")!
    case 3.5..<4.0:
      image = UIImage(named: "bad")!
    case 4.0..<4.75:
      image = UIImage(named: "good")!
    case 4.75..<5.0:
      image = UIImage(named: "great")!
    default:
      image = UIImage(named: "bad")!
    }
    return BusinessMapViewModel(coordinate: business.location,
                                name: name,
                                rating: rating,
                                image: image)
  }
}
