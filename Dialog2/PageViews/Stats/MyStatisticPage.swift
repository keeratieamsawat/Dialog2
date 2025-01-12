import SwiftUI

struct MyStatisticPage: View {
    @ObservedObject var glucoseData: GlucoseData // Shared data model for glucose statistics

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    // MARK: - Top Blue Bar
                    ZStack {
                        Color("Primary_Color")
                            .frame(height: 120)
                            .edgesIgnoringSafeArea(.top)
                        
                        Text("My Statistics")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 55)
                            .padding(.bottom, 10)
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
                                destination: GlucoseStatsView(glucoseData: glucoseData)
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
                            
                            // Calorie Intake
                            StatCard(
                                icon: "cart.fill",
                                title: "Calorie Intake",
                                description: "It is of utmost importance to eat properly!",
                                destination: CalorieIntakeStatView()
                            )
                            
                            // Carbohydrate Intake
                            StatCard(
                                icon: "fork.knife",
                                title: "Carbohydrate Intake",
                                description: "View only your carbohydrate intake.",
                                destination: CarbIntakeStatView()
                            )
                        }
                        .padding(15)
                    }
                    
                    // MARK: - Email Statistics Button
                    Button(action: {
                        print("Email statistics to doctor tapped")
                    }) {
                        Text("Email My Statistics to my doctor")
                            .foregroundColor(.red)
                            .font(.headline)
                    }
                    .padding()
                }
                .edgesIgnoringSafeArea(.all)
            }
            .navigationBarHidden(true)
        }
    }
    // MARK: - Stat Card Component
    struct StatCard<Destination: View>: View {
        var icon: String
        var title: String
        var description: String
        var destination: Destination

        var body: some View {
            NavigationLink(destination: destination) {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: icon)
                        .font(.title)
                        .foregroundColor(Color.blue)

                    VStack(alignment: .leading, spacing: 5) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
            }
        }
    }
}

// MARK: - Preview
struct MyStatisticPage_Previews: PreviewProvider {
    static var previews: some View {
        MyStatisticPage(glucoseData: GlucoseData())
    }
}
