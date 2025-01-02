import SwiftUI

struct MyInfoPage: View {
    var userName: String = "User Name"
    
    var body: some View {
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
                                Text("Account & Settings")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.top,-70)
                                Spacer()
                            }
                            .padding(.bottom, 10)

                            HStack(spacing: 40) {
                                Circle()
                                    .fill(Color("Primary_Color"))
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Text(String(userName.prefix(1)))
                                            .foregroundColor(.white)
                                            .font(.system(size: 50, weight: .bold))
                                    )
                                    .overlay(
                                        Image(systemName: "camera")
                                            .foregroundColor(.gray)
                                            .padding(6)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                            .offset(x: 25, y: 25), // Adjusted position for larger avatar
                                        alignment: .bottomTrailing
                                    )
                                    .offset(y: -20)

                                VStack(alignment: .leading) {
                                    Text(userName)
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.black)
                                    Text("dialog@gmail.com")
                                        .font(.system(size: 18, weight: .regular))
                                        .foregroundColor(.gray)
                                }
                                .offset(x:-10, y: -20)
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
                            NavigationLink(destination: Text("Change Password")) {
                                InfoRow(iconName: "lock.fill", iconColor: .gray, title: "Change password")
                            }
                            NavigationLink(destination: Text("App Data")) {
                                InfoRow(iconName: "square.and.arrow.up", iconColor: .blue, title: "App Data")
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .frame(maxWidth: .infinity)
                    .offset(y:-10)

                    // MARK: - Log Out Button
                    VStack {
                        Button(action: {
                            // Handle log out action
                        }) {
                            Text("Log out")
                                .foregroundColor(.red)
                                .font(.system(size: 18, weight: .medium))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        .offset(y: -17)
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
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 10)
        .background(Color.white)
        .cornerRadius(8)
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
