//
//  UserProfilesListView.swift
//  FriendsListTrackman
//
//  Created by Ivan Jovanovik on 15.10.24.
//

import SwiftUI

struct UserProfilesListView: View {
    @StateObject private var viewModel = UserProfilesViewModel()
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                loadingView()
            } else if viewModel.showErrorView {
                errorView({
                    viewModel.getAllUserProfiles()
                })
            } else {
                mainContent()
            }
        }
    }
    
    private func errorView(_ retryAction: @escaping () -> Void) -> some View {
        AnyView(
            VStack {
                Text("An error occurred please try again later.")
                    .foregroundColor(.red)
                    .padding()
                Button("Retry") {
                    retryAction()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        )
    }
    
    private func loadingView() -> some View {
        ProgressView("Loading...")
            .progressViewStyle(CircularProgressViewStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func mainContent() -> some View {
        return VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                Text("Search by name, email or username")
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal)
            .frame(height: 40)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            .disabled(true)
            .padding(.top, 16)
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    
                    if !viewModel.friends.isEmpty {
                        sectionHeader("Recently Played", listOfUsers: viewModel.nonFriends)
                    }
                    
                    if !viewModel.nonFriends.isEmpty {
                        sectionHeader("Friends", listOfUsers: viewModel.friends)
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("FRIENDS")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
            }
        }
    }
    
    private func sectionHeader(_ title: String, listOfUsers: [UserProfile]) -> some View {
        return VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 8)
                .foregroundStyle(Color("SectionTextColor"))
            
            ForEach(Array(listOfUsers.enumerated()), id: \.element.id) { index, userProfile in
                NavigationLink(destination: UserProfileDetailView(userProfile: userProfile)) {
                    VStack {
                        UserProfileRow(userProfile: userProfile)
                        if index < listOfUsers.count - 1 {
                            Divider()
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        
    }
}

struct UserProfilesListView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfilesListView()
    }
}
