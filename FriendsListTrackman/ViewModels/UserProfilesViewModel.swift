//
//  UserProfilesViewModel.swift
//  FriendsListTrackman
//
//  Created by Ivan Jovanovik on 15.10.24.
//

import SwiftUI
import Combine

class UserProfilesViewModel: ObservableObject {

    @Published var allUserProfiles: [UserProfile] = []
    @Published var friends: [UserProfile] = []
    @Published var nonFriends: [UserProfile] = []
    @Published var isLoading = true
    @Published var showErrorView: Bool = false
    
    var fireErrorView: ((String) -> Void)?
    @Service var remoteLoaderService: UserListLoaderProtocol?
    private var cancellables = Set<AnyCancellable>()
        
    init() {
        self.getAllUserProfiles()
    }
       
    func getAllUserProfiles() {
        self.remoteLoaderService?.loadUserList {[weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let allUsers):
                self?.friends = allUsers.filter { $0.isFriend }
                self?.nonFriends =  allUsers.filter { !$0.isFriend }
                self?.showErrorView = false
            case .failure:
                    self?.showErrorView = true
            }
        }
    }
}
