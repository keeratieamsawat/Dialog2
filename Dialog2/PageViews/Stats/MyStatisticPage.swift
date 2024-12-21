import SwiftUI

struct MyStatisticPage: View {
    @ObservedObject var glucoseData: GlucoseData // Shared data model for glucose statistics

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header Section
            ZStack {
                Color("Primary_Color")
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .edgesIgnoringSafeArea(.top)
                
                VStack(spacing: 10) {
                    Text("My Statistics")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, -50)
                }
            }
            
            // MARK: - Time Range Picker
            VStack(alignment: .leading, spacing: 15) {
                Text("Choose a time range...")
                    .font(.headline)
                    .padding(.leading)
                
                // "From" Section
                HStack {
                    Text("From")
                        .font(.subheadline)
                        .frame(width: 50, alignment: .leading)
                        .padding(10)
                    
                    DatePicker("", selection: .constant(Date()), displayedComponents: .date)
                        .labelsHidden()
                        .padding(.horizontal)

                    DatePicker("", selection: .constant(Date()), displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .padding(.horizontal)
                }
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                // "To" Section
                HStack {
                    Text("To")
                        .font(.subheadline)
                        .frame(width: 50, alignment: .leading)
                        .padding(10)
                    
                    DatePicker("", selection: .constant(Date()), displayedComponents: .date)
                        .labelsHidden()
                        .padding(.horizontal)

                    DatePicker("", selection: .constant(Date()), displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .padding(.horizontal)
                }
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding()


            
            // MARK: - Stat Buttons
            ScrollView {
                VStack(spacing: 15) {
                    // Blood Sugar Fluctuations
                    StatCard(
                        icon: "chart.bar",
                        title: "Blood Sugar Fluctuations",
                        description: "See your blood sugar fluctuation trends during the chosen time period.",
                        destination: MeasuredStatView(glucoseData: glucoseData)
                    )

                    // Exercises & Change in Weight
                    StatCard(
                        icon: "figure.walk",
                        title: "Exercises & Change in Weight",
                        description: "Keeping a record of physical exercises you’ve done and any weight changes.",
                        destination: ExerciseStatView()
                    )

                    // Insulin Intake
                    StatCard(
                        icon: "pencil.tip.crop.circle",
                        title: "Insulin Intake",
                        description: "Check your detailed insulin intake - type of insulin and dose.",
                        destination: InsulinStatView()
                    )

                    // Other Medicine
                    StatCard(
                        icon: "pills.fill",
                        title: "Other Medicine",
                        description: "Other types of medicine you have taken - name and dose.",
                        destination: MedicationStatView()
                    )

                    // Food Intake
                    StatCard(
                        icon: "cart.fill",
                        title: "Food Intake",
                        description: "It is of utmost importance to eat properly!",
                        destination: CalorieIntakeStatView()
                    )
                }
            }

            // MARK: - Email Statistics
            Button(action: {
                print("Email statistics to doctor tapped")
            }) {
                Text("Email My Statistics to my doctor")
                    .foregroundColor(.red)
                    .font(.headline)
            }
            .padding()
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Stat Card Component
struct StatCard<Destination: View>: View {
    let icon: String
    let title: String
    let description: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 20) {
                Image(systemName: icon)
                    .font(.largeTitle)
                    .foregroundColor(Color("Primary_Color"))

                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.black)
                        .fontWeight(.bold)

                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .shadow(radius: 2)
        }
    }
}

// MARK: - Preview
struct MyStatisticPage_Previews: PreviewProvider {
    static var previews: some View {
        MyStatisticPage(glucoseData: GlucoseData())
    }
}
