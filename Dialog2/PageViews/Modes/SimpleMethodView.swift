import SwiftUI

struct SimpleMethodData: Codable {
    let selectedDate: String
    let bloodSugarTime: String
    let bloodSugarLevel: String
    let noteBloodSugar: String
    
    let foodTime: String
    let food: String
    let portionSize: String
    let carbohydrateIntake: String
    let noteFood: String
    let selectedTab: String
}

struct SimpleMethodView: View {
    
    @Environment(\.presentationMode) var presentationMode // For home page navigation

    @State private var selectedTab: String = "" // Initially empty
    @State private var selectedDate = Date()
    @State private var bloodSugarTime = Date()
    @State private var bloodSugarLevel: String = ""
    @State private var noteBloodSugar: String = ""
    
    @State private var foodTime = Date()
    @State private var food: String = ""
    @State private var portionSize: String = ""
    @State private var carbohydrateIntake: String = ""
    @State private var noteFood: String = ""

    let tabs = ["Breakfast", "Lunch", "Dinner", "Snack"]

    var body: some View {
        VStack(spacing: 0) {
            // Top Blue Bar
            ZStack {
                Color("Primary_Color")
                    .frame(height: 120)
                    .edgesIgnoringSafeArea(.top)

                HStack {
                    // Close Icon on the Left
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .frame(width: 50) // Ensure consistent spacing
                    Spacer()
                    // Title in the Middle
                    Text("Simple Method")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.leading, 10)
                    Spacer()
                    // Invisible Button to Balance Layout
                    Button(action: {}) {}
                        .frame(width: 50)
                }
                .padding(.horizontal, 13)
                .padding(.top, 40)
                .frame(height: 120)
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

                    // Blood Sugar Section
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
                            Text("BLOOD SUGAR TIME:").foregroundColor(.white)
                            Spacer()
                            DatePicker("", selection: $bloodSugarTime, displayedComponents: .hourAndMinute)
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
                            TextField("Optional", text: $noteBloodSugar)
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
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .background(selectedTab == tab ? Color.green : Color.clear)
                                    .foregroundColor(selectedTab == tab ? .white : .green)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 1))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .onTapGesture {
                                        selectedTab = tab
                                    }
                            }
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "clock")
                                Text("FOOD TIME:")
                                Spacer()
                                DatePicker("", selection: $foodTime, displayedComponents: .hourAndMinute)
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
                                Spacer()
                                TextField("", text: $carbohydrateIntake)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                            HStack {
                                Image(systemName: "pencil")
                                Text("NOTE:")
                                Spacer()
                                TextField("Optional", text: $noteFood)
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
                        sendDataToBackend()
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
                .padding(.bottom, 10)
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

    private func formattedTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }

    private func saveDataToJSON() -> Data? {
        let dataModel = SimpleMethodData(
            selectedDate: formattedDate(),
            bloodSugarTime: formattedTime(bloodSugarTime),
            bloodSugarLevel: bloodSugarLevel,
            noteBloodSugar: noteBloodSugar,
            foodTime: formattedTime(foodTime),
            food: food,
            portionSize: portionSize,
            carbohydrateIntake: carbohydrateIntake,
            noteFood: noteFood,
            selectedTab: selectedTab
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(dataModel)
            return jsonData
        } catch {
            print("Error encoding JSON: \(error)")
            return nil
        }
    }

    private func sendDataToBackend() {
        guard let jsonData = saveDataToJSON() else {
            print("Failed to create JSON data")
            return
        }
        
        guard let url = URL(string: "https://your-backend-api-url.com/endpoint") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending data to backend: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Backend response status: \(httpResponse.statusCode)")
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Backend response: \(responseString)")
            }
        }
        task.resume()
    }
}

struct SimpleMethodView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleMethodView()
    }
}

