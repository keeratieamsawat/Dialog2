import SwiftUI

struct MyInfoPage: View {
    var body: some View {
        ZStack {
            Color("Primary_Color") // Background for blue borders
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // MARK: - Top Blue Border
                Color("Primary_Color")
                    .frame(height: 100) // Small blue border height

                // MARK: - Content Section
                VStack(spacing: 0) {
                    // Header Section
                    ZStack {
                        Color.white
                            .clipShape(RoundedCorners(tl: 0, tr: 0, bl: 20, br: 20)) // Apply rounded corners to bottom-left and bottom-right

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
                                Text("Account & Settings")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.top,-90)
                                Spacer()
                            }
                            .padding(.bottom, 10)

                            HStack(spacing: 20) {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Text("U")
                                            .foregroundColor(.white)
                                            .font(.largeTitle)
                                    )
                                    .overlay(
                                        Image(systemName: "camera")
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                            .offset(x: 20, y: 20),
                                        alignment: .bottomTrailing
                                    )

                                VStack(alignment: .leading) {
                                    Text("User Name")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    Text("dialog@gmail.com")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    .frame(height: 180)

                    // MARK: - List of Options
                    List {
                        Section {
                            NavigationLink(destination: Text("Basic Therapy Info")) {
                                InfoRow(iconName: "circle.fill", iconColor: .blue, title: "Basic therapy info")
                            }
                            NavigationLink(destination: Text("Blood Sugar Testing")) {
                                InfoRow(iconName: "drop.fill", iconColor: .orange, title: "Blood sugar testing")
                            }
                            NavigationLink(destination: Text("Insulin Therapy")) {
                                InfoRow(iconName: "drop.triangle.fill", iconColor: .teal, title: "Insulin therapy")
                            }
                            NavigationLink(destination: Text("Food")) {
                                InfoRow(iconName: "applelogo", iconColor: .orange, title: "Food")
                            }
                            NavigationLink(destination: Text("My Monster")) {
                                InfoRow(iconName: "face.smiling", iconColor: .green, title: "My monster")
                            }
                            NavigationLink(destination: Text("Other Settings")) {
                                InfoRow(iconName: "gearshape", iconColor: .gray, title: "Other settings")
                            }
                            NavigationLink(destination: Text("Change Password")) {
                                InfoRow(iconName: "lock.fill", iconColor: .gray, title: "Change password")
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .frame(maxWidth: .infinity)

                    // MARK: - Log Out Button
                    VStack {
                        Button(action: {
                            // Handle log out action
                        }) {
                            Text("Log out")
                                .foregroundColor(.red)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                }
                .background(Color(UIColor.systemGray6))

                // MARK: - Bottom Blue Border
                Color("Primary_Color")
                    .frame(height: 20) // Small blue border height
            }
        }
    }
}

// MARK: - InfoRow Component
struct InfoRow: View {
    var iconName: String
    var iconColor: Color
    var title: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Custom Corner Radius Shape
struct RoundedCorners: Shape {
    var tl: CGFloat = 0
    var tr: CGFloat = 0
    var bl: CGFloat = 0
    var br: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + tl))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - bl))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - br))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + tr))
        path.closeSubpath()
        return path
    }
}

// MARK: - Preview
struct MyInfoPage_Previews: PreviewProvider {
    static var previews: some View {
        MyInfoPage()
    }
}
