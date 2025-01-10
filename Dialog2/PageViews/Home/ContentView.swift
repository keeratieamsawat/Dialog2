import SwiftUI

struct ContentView: View {
    @State private var isFirstTimeUser: Bool = UserDefaults.standard.bool(forKey: "isFirstTimeUser") != false
    @State private var isSignedIn: Bool = UserDefaults.standard.bool(forKey: "isSignedIn")

    var body: some View {
        if isFirstTimeUser {
            MainPageView()
        } else if isSignedIn {
            HomePageView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
