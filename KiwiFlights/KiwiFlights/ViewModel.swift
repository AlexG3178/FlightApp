//
//  ViewModel.swift
//  KiwiFlights
//
//  Created by Alexandr Grigoriev on 22.08.2022.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    
    @Published var isLoading: Bool = true
    @Published var response = [FlightData]()
    var randomLocations = [FlightData]()
    var existingLocations: [String] = []
    var currency: String = ""
    let key = "apikey"
    let token = "biIH4vb5A9KSIt9lkpVFLadwYJXxBUg1"
    let todayDateString = Date().getTodayDateString()
    let tomorrowDateString = Date().getTomorrowDateString()
    let countryCodeFrom: String = NSLocale.current.regionCode ?? "US"
    let countryCodesTo: String = "anywhere"
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        loadData()
    }
    
    // MARK: - Combine
    
    func loadData() {
        
        guard let url = URL(string: "https://tequila-api.kiwi.com/v2/search?fly_from=\(String(describing: countryCodeFrom))&fly_to=\(countryCodesTo)&dateFrom=\(todayDateString)&dateTo=\(todayDateString)") else {
            print("Invalid URL")
            return
        }

//        guard let url = URL(string: "https://tequila-api.kiwi.com/v2/search?fly_from=\(String(describing: countryCodeFrom))&fly_to=\(countryCodesTo)&dateFrom=\(todayDateString)&dateTo=\(tomorrowDateString)") else {
//            print("Invalid URL")
//            return
//        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: key)

        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300
                else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: Result.self, decoder: JSONDecoder())
            .sink { completion in
            } receiveValue: { [weak self] receivedData in
                self?.manageData(receivedData)
            }
            .store(in: &cancellables)
    }
    
    func manageData(_ result: Result) {

        for dataItem in result.data {
            if self.randomLocations.count >= 5 {
                break
            }
            if !self.existingLocations.contains(dataItem.countryTo.code) {
                self.randomLocations.append(dataItem)
                self.existingLocations.append(dataItem.countryTo.code)
            }
        }
        response = randomLocations
        currency = result.currency
        isLoading = false
    }
    
    
    // MARK: - Escaping closure
    
//    func loadData() {
//
//        guard let url = URL(string: "https://tequila-api.kiwi.com/v2/search?fly_from=\(String(describing: countryCodeFrom))&fly_to=\(countryCodesTo)&dateFrom=\(todayDateString)&dateTo=\(todayDateString)") else {
//            print("Invalid URL")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue(token, forHTTPHeaderField: key)
//
//        fetchData(withRequest: request) { returnedData in
//            if let data = returnedData {
//                guard let response = try? JSONDecoder().decode(Result.self, from: data) else { return }
//                for result in response.data {
//                    if self.randomLocations.count >= 5 {
//                        break
//                    }
//                    if !self.existingLocations.contains(result.countryTo.code) {
//                        self.randomLocations.append(result)
//                        self.existingLocations.append(result.countryTo.code)
//                    }
//                }
//                DispatchQueue.main.async {
//                    self.response = self.randomLocations
//                    self.currency = response.currency
//                    self.isLoading = false
//                }
//            } else {
//                print("No Data")
//            }
//        }
//    }
    
//    func fetchData(withRequest request: URLRequest, completion: @escaping (_ data: Data?) -> ()) {
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard
//                let data = data,
//                error == nil,
//                let response = response as? HTTPURLResponse,
//                response.statusCode >= 200 && response.statusCode < 300
//            else {
//                print("Fetch Error")
//                completion(nil)
//                return
//            }
//
//            completion(data)
//
//        }.resume()
//    }
    
    
    // MARK: - Async request
    
//        func loadData() async {
//            guard let url = URL(string: "https://tequila-api.kiwi.com/v2/search?fly_from=\(String(describing: countryCodeFrom))&fly_to=\(countryCodesTo)&dateFrom=\(todayDateString)&dateTo=\(todayDateString)") else {
//                print("Invalid URL")
//                return
//            }
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//            request.setValue(token, forHTTPHeaderField: key)
//
//            URLSession.shared.dataTask(with: request) { [self] data, response, error in
//                guard let data = data else {
//                    return
//                }
//                do {
//                    let response = try JSONDecoder().decode(Result.self, from: data)
//
//                    for result in response.data {
//                        if self.randomLocations.count >= 5 {
//                            break
//                        }
//                        if !self.existingLocations.contains(result.countryTo.code) {
//                            self.randomLocations.append(result)
//                            self.existingLocations.append(result.countryTo.code)
//                        }
//                    }
//
//                    DispatchQueue.main.async {
//                        self.response = self.randomLocations
//                        self.currency = response.currency
//                        self.isLoading = false
//                    }
//
//                } catch {
//                    print("Invalid data")
//                }
//            }.resume()
//        }
}
