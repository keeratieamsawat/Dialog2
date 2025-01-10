import SwiftUI

struct BloodSugarTestingView: View {
    @State private var bloodSugarUnit: String = "mmol/L"
    @State private var hyperValue: Double = 10.0
    @State private var hypoValue: Double = 3.9
    @State private var targetRangeLower: Double = 5.0
    @State private var targetRangeUpper: Double = 8.9

    // NumberFormatter for one decimal place
    private var decimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        return formatter
    }

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
                                    Text("Blood Sugar Testing")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.top, -50)
                                    Spacer()
                                }
                                .padding(.bottom, 8)
                                
                                Text("Settings for checking and understanding your blood sugar.")
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
                            // Blood Sugar Unit Section
                            Section {
                                HStack {
                                    Text("Blood sugar unit")
                                        .font(.body)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Picker("", selection: $bloodSugarUnit) {
                                        Text("mmol/L").tag("mmol/L")
                                        Text("mg/dL").tag("mg/dL")
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .onChange(of: bloodSugarUnit) { newValue in
                                        // Adjust values based on the unit
                                        if newValue == "mg/dL" {
                                            hyperValue = hyperValue * 18.0
                                            hypoValue = hypoValue * 18.0
                                            targetRangeLower = targetRangeLower * 18.0
                                            targetRangeUpper = targetRangeUpper * 18.0
                                        } else {
                                            hyperValue = hyperValue / 18.0
                                            hypoValue = hypoValue / 18.0
                                            targetRangeLower = targetRangeLower / 18.0
                                            targetRangeUpper = targetRangeUpper / 18.0
                                        }
                                    }
                                }
                            }
                            
                            // Hypers and Hypos Section
                            Section(header: Text("Hypers and hypos").foregroundColor(.green)) {
                                // Hyper
                                HStack {
                                    Label("Hyper", systemImage: "triangle.fill")
                                        .foregroundColor(.red)
                                    Spacer()
                                    TextField("Hyper Value", value: $hyperValue, formatter: decimalFormatter)
                                        .keyboardType(.decimalPad)
                                        .multilineTextAlignment(.trailing)
                                    Text(bloodSugarUnit)
                                        .foregroundColor(.gray)
                                }
                                
                                // Target Range
                                VStack(alignment: .leading, spacing: 8) {
                                    Label("Target range", systemImage: "circle.fill")
                                        .foregroundColor(.green)
                                    HStack {
                                        Text("Lower")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        TextField("Lower Bound", value: $targetRangeLower, formatter: decimalFormatter)
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.trailing)
                                        Text(bloodSugarUnit)
                                            .foregroundColor(.gray)
                                    }
                                    HStack {
                                        Text("Upper")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        TextField("Upper Bound", value: $targetRangeUpper, formatter: decimalFormatter)
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.trailing)
                                        Text(bloodSugarUnit)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                // Hypo
                                HStack {
                                    Label("Hypo", systemImage: "triangle.fill")
                                        .foregroundColor(.red)
                                    Spacer()
                                    TextField("Hypo Value", value: $hypoValue, formatter: decimalFormatter)
                                        .keyboardType(.decimalPad)
                                        .multilineTextAlignment(.trailing)
                                    Text(bloodSugarUnit)
                                        .foregroundColor(.gray)
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
        }
    }
}

struct BloodSugarTestingView_Previews: PreviewProvider {
    static var previews: some View {
        BloodSugarTestingView()
    }
}
