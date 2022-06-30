
//  Explore GIFs.swift
//  GIFMaker
//
//  Created by csuftitan on 6/28/22.
//

import Foundation
import SwiftUI

struct Explore_GIFs: View {
    @StateObject private var GIFList = GIFListViewModel()
    @State private var searchText: String = ""
    
    @AppStorage("name") var currentUserName: String?
    var body: some View {
        VStack(spacing: 20) {
            Text(currentUserName ?? "Add Name Here")

            Button("Click Here".uppercased()) {
                let name = "This Feature is Created By Rushik"
                currentUserName = name
            }
        }
        
        NavigationView {
            List(GIFList.movies, id: \.imdbId) { movie in
                HStack {
                    AsyncImage(url: movie.poster,
                               content: { image in
                                   image.resizable()
                                       .aspectRatio(contentMode: .fit)
                                       .frame(maxWidth: 100)
                               }, placeholder: {
                                   ProgressView()
                               })
                    Text(movie.title)
                }
            }.listStyle(.plain)
                .searchable(text: $searchText)
                .onChange(of: searchText) { value in
                    async {
                        if !value.isEmpty, value.count > 3 {
                            await GIFList.search(name: value)
                        } else {
                            GIFList.movies.removeAll()
                        }
                    }
                }
                .navigationTitle("Explore GIFs")
        }
    }
}

struct MovieResponse: Decodable {
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movies = "Search"
    }
}

struct Movie: Decodable {
    let imdbID: String
    let title: String
    let poster: String
    
    private enum CodingKeys: String, CodingKey {
        case imdbID
        case title = "Title"
        case poster = "Poster"
    }
}

// GIFListViewModel

@MainActor
class GIFListViewModel: ObservableObject {
    @Published var movies: [MovieViewModel] = []
    
    func search(name: String) async {
        do {
            let movies = try await Webservice().getMovies(searchTerm: name)
            self.movies = movies.map(MovieViewModel.init)
            
        } catch {
            print(error)
        }
    }
}

struct MovieViewModel {
    let movie: Movie
    
    var imdbId: String {
        movie.imdbID
    }
    
    var title: String {
        movie.title
    }
    
    var poster: URL? {
        URL(string: movie.poster)
    }
}

// String + Extension

extension String {
    func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// Web Service

enum NetworkError: Error {
    case badURL
    case badID
}

class Webservice {
    func getMovies(searchTerm: String) async throws -> [Movie] {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "omdbapi.com"
        components.queryItems = [
            URLQueryItem(name: "s", value: searchTerm.trimmed()),
            URLQueryItem(name: "apikey", value: "564727fa")
        ]
        
        guard let url = components.url else {
            throw NetworkError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badID
        }
        
        let movieResponse = try? JSONDecoder().decode(MovieResponse.self, from: data)
        return movieResponse?.movies ?? []
    }
}

struct Explore_GIFs_Previews: PreviewProvider {
    static var previews: some View {
        Explore_GIFs()
    }
}
