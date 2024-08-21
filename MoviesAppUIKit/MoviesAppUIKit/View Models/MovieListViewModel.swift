//
//  MovieListViewModel.swift
//  MoviesAppUIKit
//
//  Created by Vivek Tusiyad on 21/08/24.
//

import Foundation
import Combine

class MovieListViewModel {
    
    @Published private(set) var movies : [Movie] = []
    @Published var loadingCompleted: Bool = false
    
    private let httpClient : HTTPClient
    
    private var cancellable: Set<AnyCancellable> = []
    
    private var searchSubject = CurrentValueSubject<String, Never>("") //Used CVSubject bcoz it will retain previous value
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
        
        setupSearchPublisher()
    }
    
    private func setupSearchPublisher(){
        
        //subscribe to publisher
        searchSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)  //added debounce of 0.5s to wait for user to type and limit api hits
            .sink { [weak self] searchText in
                self?.loadMovies(searchText: searchText)
            }.store(in: &cancellable)
    }
    
    //set searchSubject Publisher to search text from Viewcontroller
    func setSearchText(_ searchText: String) {
        searchSubject.send(searchText)
    }
    
    func loadMovies(searchText: String) {
        
        httpClient.fetchMovies(searchText)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.loadingCompleted = true                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }.store(in: &cancellable)

    }
}
