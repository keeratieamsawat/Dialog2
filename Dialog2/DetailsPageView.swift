// this file contains:
// details of the user's diabetes conditions

import SwiftUI

// for these pages, use NavigationLink with a binding condition
// to enable automatically entering the next page when user input and saved their details
// the binding condition is of type "Bool"

struct DetailsPageView: View {
    var body: some View {
        VStack(){
            Text("We'll need some details about your condition...")
                .font(.headline)
                .bold()
            Spacer()
        }
        .padding(20)
    }
}

#Preview {
    DetailsPageView()
}
