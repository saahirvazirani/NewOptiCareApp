import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            if let user = viewModel.currentUser {
                List {
                    Section {
                        HStack {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color.blue.opacity(0.8))
                                .clipShape(Circle())
                                .shadow(radius: 5)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullname)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                Text(user.email)
                                    .font(.footnote)
                                    .foregroundStyle(Color(.gray))
                            }
                        }
                        .padding(.vertical)
                    }

                    Section("General") {
                        settingsRow(imageName: "gear", title: "Version", detail: "1.0.0")
                    }

                    Section("Account") {
                        Button {
                            viewModel.signout()
                        } label: {
                            settingsRow(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                        }
                        Button {
                            print("Delete account..")
                        } label: {
                            settingsRow(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .navigationTitle("Profile")
    }

    private func settingsRow(imageName: String, title: String, detail: String = "", tintColor: Color = .gray) -> some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(tintColor)
            Text(title)
                .font(.subheadline)
            Spacer()
            if !detail.isEmpty {
                Text(detail)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
