import SwiftUI

struct FoodView: View {
    @State private var bodyWeightTarget: Double = 65.0
    @State private var bodyHeight: Double = 170.0

    @State private var showWeightTargetPicker = false
    @State private var showHeightPicker = false
    
    // Recommended daily carb intake (grams) calculation
    var recommendedCarbIntake: Int {
        let tdee = 25.0 * bodyWeightTarget // Rough estimate: 25 calories per kg of body weight
        let carbCalories = tdee * 0.50 // Assume 50% of calories from carbs
        return Int(carbCalories / 4) // Convert carb calories to grams (1g carbs = 4 calories)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // MARK: - Top Blue Bar
                ZStack {
                    Color("Primary_Color")
                        .frame(height: 100)
                        .edgesIgnoringSafeArea(.top)

                    Text("Food")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 55)
                        .padding(.bottom, 10)
                }

                // MARK: - Content Section
                VStack(spacing: 0) {
                    // Header Section
                    ZStack {
                        Color.white

                        VStack(spacing: 8) {
                            Text("Healthy food choices and an active lifestyle can help you achieve your health goals.")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 16)
                        }
                        .padding()
                    }
                    .frame(height: 80)

                    // MARK: - List of Options
                    List {
                        // Body Weight Section
                        Section(header: Text("Body weight").font(.headline).foregroundColor(.black)) {
                            Button(action: {
                                showWeightTargetPicker = true
                            }) {
                                HStack {
                                    Text("Body weight target")
                                        .font(.body)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text("\(bodyWeightTarget, specifier: "%.2f") kg")
                                        .font(.body)
                                        .foregroundColor(.gray)
                                }
                            }
                        }

                        // Body Height Section
                        Section(header: Text("Body height").font(.headline).foregroundColor(.black)) {
                            Button(action: {
                                showHeightPicker = true
                            }) {
                                HStack {
                                    Text("Body height")
                                        .font(.body)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text("\(bodyHeight, specifier: "%.2f") cm")
                                        .font(.body)
                                        .foregroundColor(.gray)
                                }
                            }
                        }

                        // Recommended Carb Intake Section
                        Section(header: Text("Recommended Daily Carb Intake").font(.headline).foregroundColor(.black)) {
                            HStack {
                                Text("Based on your height and weight")
                                    .font(.body)
                                    .foregroundColor(.black)
                                Spacer()
                                Text("\(recommendedCarbIntake) g")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .frame(maxWidth: .infinity)
                    .offset(y: -10)
                }
                .background(Color(UIColor.systemGray6))

                // MARK: - Bottom Blue Bar
                ZStack {
                    Color("Primary_Color")
                        .frame(height: 80)
                        .edgesIgnoringSafeArea(.bottom)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .sheet(isPresented: $showWeightTargetPicker) {
            ScrollPickerSheet(
                title: "Body Weight Target",
                value: $bodyWeightTarget,
                range: 30...200,
                unit: "kg"
            )
        }
        .sheet(isPresented: $showHeightPicker) {
            ScrollPickerSheet(
                title: "Body Height",
                value: $bodyHeight,
                range: 50...250,
                unit: "cm"
            )
        }
    }
}

// MARK: - Scroll Picker Sheet
struct ScrollPickerSheet: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let unit: String

    var body: some View {
        NavigationView {
            VStack {
                Text(title)
                    .font(.headline)
                    .padding()

                Picker("", selection: $value) {
                    ForEach(Array(stride(from: range.lowerBound, through: range.upperBound, by: 0.5)), id: \.self) { number in
                        Text("\(number, specifier: "%.2f") \(unit)")
                            .tag(number)
                    }
                }
                .labelsHidden()
                .pickerStyle(WheelPickerStyle())
                .frame(height: 200)

                Spacer()
            }
            .navigationTitle(title)
            .navigationBarItems(
                trailing: Button("Done") {
                    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                }
            )
        }
    }
}

// MARK: Preview
struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView()
    }
}
