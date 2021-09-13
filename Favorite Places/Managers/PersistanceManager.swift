//
//  PersistanceManager.swift
//  Favorite Places
//
//  Created by Donat Kabashi on 9/12/21.
//

import Foundation
import RxRelay

class PersistenceManager {
    private let defaults = UserDefaults.standard
    private var currentActionType = PersistenceActionType.add
    enum Keys { static let favorites = "favorites" }
    let failedToPersistWithError = PublishRelay<FavoritePlacesError>()
    let persistanceSucceded = PublishRelay<PersistenceActionType>()
    
    func updateWith(favorite: FavoritePlace, actionType: PersistenceActionType) {
        retrieveFavorites { result in
            self.currentActionType = actionType
            switch result {
            case .success(var favorites):
                
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        self.failedToPersistWithError.accept(.alreadyInFavorites)
                        return
                    }
                    
                    favorites.append(favorite)
                    
                case .remove:
                    favorites.removeAll { $0.latitude == favorite.latitude && $0.longitude == favorite.longitude && $0.user.email == favorite.user.email }
                case .edit:
                    #warning("implement")
                }
                self.save(favorites: favorites)
                
            case .failure(let error):
                self.failedToPersistWithError.accept(error)
            }
        }
    }
    
    
    func retrieveFavorites(completed: @escaping (Result<[FavoritePlace], FavoritePlacesError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([FavoritePlace].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    
    func save(favorites: [FavoritePlace]) {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            persistanceSucceded.accept(currentActionType)
        } catch {
            failedToPersistWithError.accept(.unableToFavorite)
        }
    }
}

