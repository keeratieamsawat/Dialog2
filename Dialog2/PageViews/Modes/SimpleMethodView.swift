import SwiftUI

struct SimpleMethodView: View {
    @State private var selectedTab: String = "" // Initially empty
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()

    @State private var bloodSugarLevel: String = ""
    @State private var note: String = ""
    @State private var food: String = ""
    @State private var portionSize: String = ""
    @State private var carbohydrateIntake: String = ""

    let tabs = ["Breakfast", "Lunch", "Dinner", "Snack"]

    var body: some View {
        VStack(spacing: 0) {
            // Top Blue Bar
            ZStack {
                Color("Primary_Color")
                    .frame(height: 100)
                    .edgesIgnoringSafeArea(.top)

                Text("Simple Method")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 55)
                    .padding(.bottom, 10)
            }

            // Scrollable Content
            ScrollView {
                VStack(spacing: 10) {
                    // Main Content
                    
                    Text("Ideal for those with stable treatment plans or a low risk of hypoglycemia")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 20)

                    // Blue Section for Date, Time, and Blood Sugar
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: "calendar").foregroundColor(.white)
                            Text("DATE:").foregroundColor(.white)
                            Spacer()
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .labelsHidden()
                        }
                        HStack {
                            Image(systemName: "clock").foregroundColor(.white)
                            Text("TIME:").foregroundColor(.white)
                            Spacer()
                            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                        HStack {
                            Image(systemName: "drop.fill").foregroundColor(.yellow)
                            Text("BLOOD SUGAR LEVEL:").foregroundColor(.white)
                                .lineLimit(1)
                                .layoutPriority(1)
                            Spacer()
                            TextField("", text: $bloodSugarLevel)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 150)
                        }
                        
                        HStack {
                            Image(systemName: "pencil").foregroundColor(.white)
                            Text("NOTE:").foregroundColor(.white)
                            Spacer()
                            TextField("Optional", text: $note)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 200)
                            
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.5)))
                    .padding(.horizontal)

                    // Food Section
                    VStack(spacing: 10) {
                        HStack {
                            Spacer()
                            Text("FOOD")
                                .font(.headline)
                                .foregroundColor(.green)
                            Spacer()
                        }
                        HStack(spacing: 10) {
                            ForEach(tabs, id: \.self) { tab in
                                Text(tab)
                                    .fontWeight(.semibold) // Optional: to emphasize the tab text
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .lineLimit(1) // Ensures text is on one line
                                    .minimumScaleFactor(0.5) // Shrinks text to fit if needed
                                    .background(selectedTab == tab ? Color.green : Color.clear)
                                    .foregroundColor(selectedTab == tab ? .white : .green)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 1))
                                    .frame(minWidth: 0, maxWidth: .infinity) // Makes tabs equal width
                                    .onTapGesture {
                                        selectedTab = tab
                                    }
                            }
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "clock")
                                Text("Time:")
                                Spacer()
                                DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                            HStack {
                                Image(systemName: "fork.knife")
                                Text("Food:")
                                Spacer()
                                TextField("", text: $food)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                            HStack {
                                Image(systemName: "chart.bar")
                                Text("Portion Size:")
                                Spacer()
                                TextField("", text: $portionSize)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                            HStack {
                                
                                Text("Carbohydrate Intake:")
                                    .lineLimit(1)
                                    .layoutPriority(1)
                                Spacer()
                                TextField("", text: $carbohydrateIntake)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                            HStack {
                                Image(systemName: "pencil")
                                Text("NOTE:")
                                Spacer()
                                TextField("Optional", text: $note)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                                
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.green.opacity(0.1)))
                    .padding(.horizontal)

                    // Apply Button
                    Button(action: {
                        print("Date: \(formattedDate())")
                        print("Time: \(formattedTime())")
                    }) {
                        Text("APPLY")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("Primary_Color"))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom, 10) // Avoid overlap with bottom bar
            }
            .edgesIgnoringSafeArea([.leading, .trailing])

            // Bottom Blue Bar
            ZStack {
                Color("Primary_Color")
                    .frame(height: 80)
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDate)
    }

    private func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: selectedTime)
    }
}

struct SimpleMethodView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleMethodView()
    }
}

