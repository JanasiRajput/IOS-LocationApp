import SwiftUI
import Charts

struct AnalyticsDashboardView: View {
    @State private var locations: [Location] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                // Premium Background
                LinearGradient(gradient: Gradient(colors: [Color(UIColor.systemGroupedBackground), Color(UIColor.secondarySystemGroupedBackground)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Header Stats
                        HStack {
                            StatCard(title: "Total Searches", value: "\(locations.count)", icon: "magnifyingglass.circle.fill", color: .blue)
                            StatCard(title: "Unique Places", value: "\(Set(locations.map { $0.name }).count)", icon: "map.circle.fill", color: .green)
                        }
                        .padding(.horizontal)
                        
                        // Scatter Plot Chart (Map Distribution)
                        VStack(alignment: .leading) {
                            Text("Coordinate Distribution")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Chart(locations, id: \.id) { loc in
                                PointMark(
                                    x: .value("Longitude", loc.longitude),
                                    y: .value("Latitude", loc.latitude)
                                )
                                .foregroundStyle(by: .value("Name", loc.name))
                                .symbol(by: .value("Name", loc.name))
                            }
                            .frame(height: 300)
                            .chartXAxisLabel("Longitude")
                            .chartYAxisLabel("Latitude")
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)).shadow(color: Color.black.opacity(0.05), radius: 10, y: 5))
                        .padding(.horizontal)
                        
                        // Bar Chart: Latitude Extents
                        VStack(alignment: .leading) {
                            Text("Latitude Breakdown by Place")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Chart(locations.prefix(15), id: \.id) { loc in
                                BarMark(
                                    x: .value("Place", loc.name),
                                    y: .value("Latitude", loc.latitude)
                                )
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .bottom, endPoint: .top))
                                .cornerRadius(4)
                            }
                            .frame(height: 250)
                            .chartXAxis {
                                AxisMarks { _ in
                                    AxisValueLabel(centered: true)
                                }
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)).shadow(color: Color.black.opacity(0.05), radius: 10, y: 5))
                        .padding(.horizontal)
                        
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Analytics 📊")
            .onAppear {
                fetchData()
            }
        }
    }
    
    private func fetchData() {
        self.locations = DatabaseHelper.shared.getAllLocations()
    }
}

struct StatCard: View {
    var title: String
    var value: String
    var icon: String
    var color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)).shadow(color: Color.black.opacity(0.05), radius: 10, y: 5))
    }
}
