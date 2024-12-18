// this file contains:
// details of the user's diabetes conditions

import SwiftUI

// for these pages, use NavigationLink with a binding condition
// to enable automatically entering the next page when user input and saved their details
// the binding condition is of type "Bool"

struct DetailsPageView: View {
    var body: some View {
        // alignment: aligning the VStack to the left
        VStack(alignment: .leading, spacing: 20) {
            Text("We'll need some details about your condition...")
                .font(.headline)
                .bold()
                .padding(.leading, 20) // padding from the left
                .padding(.top, 40) // padding from the top
            Text("First off, when were you diagnosed, and what diabetes type are you diagnosed with?")
                .font(.title3)
                .bold()
                .padding(.leading, 20)
                .padding(.top, 20)
            
            
            Spacer()
        }
        .padding(10) // padding for the whole VStack
    }
}

#Preview {
    DetailsPageView()
}
