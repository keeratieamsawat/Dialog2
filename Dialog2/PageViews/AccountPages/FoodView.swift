import SwiftUI

struct FoodView: View {
    @State private var carbsUnit: String = "Grams"
    @State private var bodyWeightUnit: String = "kg"
    @State private var bodyWeightTarget: Double = 65.0
    @State private var bodyHeightUnit: String = "cm"
    @State private var bodyHeight: Double = 170.0

    @State private var showWeightTargetPicker = false
    @State private var showHeightPicker = false

    var body: some View {
        NavigationView {
            ZStack {
                Color("Primary_Color")
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    // MARK: - Top Blue Border
                    Color("Primary_Color")
                        .frame(height: 100)

                    // MARK: - Content Section
                    VStack(spacing: 0) {
                        // Header Section
                        ZStack {
                            Color.white
                                .clipShape(RoundedCorners(tl: 0, tr: 0, bl: 20, br: 20))

                            VStack(spacing: 8) {
                                HStack {
                                    Button(action: {
                                        // Handle back button action
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.white)
                                            .font(.title2)
                                    }
                                    Spacer()
                                    Text("Food")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.top, -50)
                                    Spacer()
                                }
                                .padding(.bottom, 8)

                                Text("Healthy food choices and an active lifestyle can help you achieve your health goals.")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 20)
                            }
                            .padding(.top, -10)
                            .padding(.bottom, 8)
                        }
                        .frame(height: 120)

                        // MARK: - List of Options
                        List {
                            // Carbs Unit Section
                            Section {
                                Picker("Carbs Unit", selection: $carbsUnit) {
                                    Text("Grams").tag("Grams")
                                    Text("Calories").tag("Calories")
                                }
                                .pickerStyle(MenuPickerStyle())
                            }

                            // Body Weight Section
                            Section(header: Text("Body weight").font(.headline).foregroundColor(.black)) {
                                Picker("Body Weight Unit", selection: $bodyWeightUnit) {
                                    Text("kg").tag("kg")
                                    Text("lbs").tag("lbs")
                                }
                                .pickerStyle(MenuPickerStyle())
                                .onChange(of: bodyWeightUnit) { newValue in
                                    if newValue == "kg" {
                                        bodyWeightTarget = bodyWeightTarget / 2.205 // Convert lbs to kg
                                    } else if newValue == "lbs" {
                                        bodyWeightTarget = bodyWeightTarget * 2.205 // Convert kg to lbs
                                    }
                                }

                                Button(action: {
                                    showWeightTargetPicker = true
                                }) {
                                    HStack {
                                        Text("Body weight target")
                                            .font(.body)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text("\(bodyWeightTarget, specifier: "%.2f") \(bodyWeightUnit)")
                                            .font(.body)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }

                            // Body Height Section
                            Section(header: Text("Body height").font(.headline).foregroundColor(.black)) {
                                Picker("Body Height Unit", selection: $bodyHeightUnit) {
                                    Text("cm").tag("cm")
                                    Text("m").tag("m")
                                    Text("ft").tag("ft")
                                }
                                .pickerStyle(MenuPickerStyle())
                                .onChange(of: bodyHeightUnit) { newValue in
                                    if newValue == "cm" {
                                        bodyHeight = bodyHeight * 100 // Convert m to cm
                                    } else if newValue == "m" {
                                        bodyHeight = bodyHeight / 100 // Convert cm to m
                                    } else if newValue == "ft" {
                                        bodyHeight = bodyHeight / 30.48 // Convert cm to ft
                                    }
                                }

                                Button(action: {
                                    showHeightPicker = true
                                }) {
                                    HStack {
                                        Text("Body height")
                                            .font(.body)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text("\(bodyHeight, specifier: "%.2f") \(bodyHeightUnit)")
                                            .font(.body)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                        .frame(maxWidth: .infinity)
                        .offset(y: -10)
                    }
                    .background(Color(UIColor.systemGray6))

                    // MARK: - Bottom Blue Border
                    Color("Primary_Color")
                        .frame(height: 20)
                }
            }
            .navigationTitle("")
            .sheet(isPresented: $showWeightTargetPicker) {
                ScrollPickerSheetWithConversion(
                    title: "Body Weight Target",
                    unit: $bodyWeightUnit,
                    value: $bodyWeightTarget,
                    unitConversion: ["kg": 1.0, "lbs": 2.205],
                    rangeInKg: 30...200
                )
            }
            .sheet(isPresented: $showHeightPicker) {
                ScrollPickerSheetWithConversion(
                    title: "Body Height",
                    unit: $bodyHeightUnit,
                    value: $bodyHeight,
                    unitConversion: ["cm": 1.0, "m": 0.01, "ft": 0.0328084],
                    rangeInKg: 50...250
                )
            }
        }
    }
}

// MARK: - Scroll Picker with Conversion
struct ScrollPickerSheetWithConversion: View {
    let title: String
    @Binding var unit: String
    @Binding var value: Double
    let unitConversion: [String: Double]
    let rangeInKg: ClosedRange<Double> // Use kg or cm as the base unit

    var body: some View {
        NavigationView {
            VStack {
                Text(title)
                    .font(.headline)
                    .padding()

                Picker("", selection: $value) {
                    let conversionFactor = unitConversion[unit] ?? 1.0
                    ForEach(Array(stride(from: rangeInKg.lowerBound, through: rangeInKg.upperBound, by: 0.5)), id: \.self) { number in
                        let convertedValue = number * conversionFactor
                        Text("\(convertedValue, specifier: "%.2f") \(unit)")
                            .tag(convertedValue)
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
