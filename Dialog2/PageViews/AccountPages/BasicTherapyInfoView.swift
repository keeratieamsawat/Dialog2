import SwiftUI

struct BasicTherapyInfoView: View {
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
                            
                            VStack(spacing: 10) {
                                HStack {
                                    Button(action: {
                                        // Handle back button action
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.white)
                                            .font(.title2)
                                    }
                                    Spacer()
                                    Text("Basic Therapy Info")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.top, -60)
                                    Spacer()
                                }
                                .padding(.bottom, 10)
                                
                                Text("Change your therapy details if needed.")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                                 
                                
                                Spacer()
                            }
                            .padding()
                        }
                        .frame(height: 80) // Reduced height for header
                        
                        // MARK: - List of Options
                        List {
                            Section {
                                HStack {
                                    Text("Diabetes type")
                                        .font(.body)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text("Type 2")
                                        .font(.body)
                                        .foregroundColor(.gray)
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .contentShape(Rectangle()) // Makes the row tappable
                                
                                HStack {
                                    Text("Sex")
                                        .font(.body)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text("-")
                                        .font(.body)
                                        .foregroundColor(.gray)
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .contentShape(Rectangle()) // Makes the row tappable
                                
                                HStack {
                                    Text("Year of diagnosis")
                                        .font(.body)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text("-")
                                        .font(.body)
                                        .foregroundColor(.gray)
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .contentShape(Rectangle()) // Makes the row tappable
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                        .frame(maxWidth: .infinity)
                        .offset(y: -10)
                    }
                    .background(Color(UIColor.systemGray6))
                    
                    // MARK: - Bottom Blue Border
                    Color("Primary_Color")
                        .frame(height: 20) // Small blue border height
                }
            }
            .navigationTitle("")
        }
    }
}

struct BasicTherapyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        BasicTherapyInfoView()
    }
}
