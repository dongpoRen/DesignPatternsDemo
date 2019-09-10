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

import YelpAPI
import CoreLocation

public class SearchClient: Mediator<SearchCollegue> {

  // MARK: - Instance Properties
  public weak var delegate: SearchClientDelegate?

  // MARK: - Object Lifecycle
  public init(delegate: SearchClientDelegate) {
    self.delegate = delegate
    super.init()
    setupColleagues()
  }

  private func setupColleagues() {
    let restaurantCollegue = YelpSearchCollegue(category: .restaurants,
                                                mediator: self)
    addColleague(restaurantCollegue)
    
    let barCollegue = YelpSearchCollegue(category: .bars,
                                         mediator: self)
    addColleague(barCollegue)
    
    let movieCollegue = YelpSearchCollegue(category: .movieTheaters,
                                           mediator: self)
    addColleague(movieCollegue)
  }

  // MARK: - Instance Methods
  public func update(userCoordinate: CLLocationCoordinate2D) {
    invokeColleagues { collegue in
      collegue.update(userCoordinate: userCoordinate)
    }
  }

  public func reset() {
    invokeColleagues { collegue in
      collegue.reset()
    }
  }
}

extension SearchClient: SearchCollegueMediating {
  public func searchCollegue(_ searchCollegue: SearchCollegue,
                             didSelect business: YLPBusiness) {
    delegate?.searchClient(self,
                           didSelect: business,
                           for: searchCollegue.category)
    
    invokeColleagues(by: searchCollegue) { collegue in
      collegue.fellowCollegue(collegue, didSelect: business)
    }
  
  }
  
  private func notifyDelegateIfAllBusinessesSelected() {
    guard let delegate = delegate else { return }
    var categoryToBusiness: [YelpCategory: YLPBusiness] = [:]
    for collegue in colleagues {
      guard let business = collegue.selectedBusiness else { return }
      categoryToBusiness[collegue.category] = business
    }
    delegate.searchClient(self, didCompleteSelection: categoryToBusiness)
  }
  
  public func searchCollegue(_ searchCollegue: SearchCollegue, didCreate viewModels: Set<BusinessMapViewModel>) {
    delegate?.searchClient(self,
                           didCreate: viewModels,
                           for: searchCollegue.category)
  }
  
  public func searchCollegue(_ searchCollegue: SearchCollegue,
                             searchFailed error: Error?) {
    delegate?.searchClient(self,
                           failedFor: searchCollegue.category,
                           error: error)
  }
}
