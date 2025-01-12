
import SwiftUI

struct ContentView: View {
    var body: some View {
        HomePageView(diabetesData:DiabetesDetailsData())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(diabetesData:DiabetesDetailsData())
    }
}
