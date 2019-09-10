/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
import CoreLocation
import YelpAPI

public class YelpSearchCollegue {
  public let category: YelpCategory
  public private(set) var selectedBusiness: YLPBusiness?
  
  private var collegueCoordinate: CLLocationCoordinate2D?
  private unowned let mediator: SearchCollegueMediating
  private var userCoordinate: CLLocationCoordinate2D?
  private let yelpClient: YLPClient
  
  private static let defaultQueryLimit = UInt(20)
  private static let defaultQuerySort = YLPSortType.bestMatched
  private var queryLimit = defaultQueryLimit
  private var querySort = defaultQuerySort
  
  public init(category: YelpCategory,
              mediator: SearchCollegueMediating) {
    self.category = category
    self.mediator = mediator
    self.yelpClient = YLPClient(apiKey: YelpAPIKey)
  }
}

extension YelpSearchCollegue: SearchCollegue {

  public func fellowCollegue(_ collegue: SearchCollegue, didSelect business: YLPBusiness) {
    collegueCoordinate = CLLocationCoordinate2D(
      business.location.coordinate)
    queryLimit /= 2
    querySort = .distance
    performSearch()
  }
  
  public func update(userCoordinate: CLLocationCoordinate2D) {
    self.userCoordinate = userCoordinate
    performSearch()
  }

  public func reset() {
    collegueCoordinate = nil
    queryLimit = YelpSearchCollegue.defaultQueryLimit
    querySort = YelpSearchCollegue.defaultQuerySort
    selectedBusiness = nil
    performSearch()
  }

  private func performSearch() {
    guard selectedBusiness == nil,
      let coordinate = collegueCoordinate ?? userCoordinate
      else { return }
    
    let yelpCoordinate = YLPCoordinate(
      latitude: coordinate.latitude,
      longitude: coordinate.longitude)
    let query = YLPQuery(coordinate: yelpCoordinate)
    query.categoryFilter = [category.rawValue]
    query.limit = queryLimit
    query.sort = querySort
    
    yelpClient.search(with: query) { [weak self] (search, error) in
      guard let self = self else { return }
      guard let search = search else {
        self.mediator.searchCollegue(self, searchFailed: error)
        return
      }
      var set: Set<BusinessMapViewModel> = []
      for business in search.businesses {
        guard let coordinate = business.location.coordinate
          else { continue }
        let viewModel = BusinessMapViewModel(
          business: business,
          coordinate: coordinate,
          primaryCategory: self.category,
          onSelect: { [weak self] business in
            guard let self = self else { return }
            self.selectedBusiness = business
            self.mediator.searchCollegue(self, didSelect: business)
        })
        set.insert(viewModel)
      }
      
      DispatchQueue.main.async {
        self.mediator.searchCollegue(self, didCreate: set)
      }
    }
  }
}
