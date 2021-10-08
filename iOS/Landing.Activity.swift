import SwiftUI

extension Landing {
    struct Activity: View {
        @State private var date: Date?
        @State private var display = false
        
        var body: some View {
            Button {
                display = true
            } label: {
                Section("Activity") {
                    HStack {
                        Label("Since", systemImage: "chart.xyaxis.line")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.primary, Color("Dawn"))
                            .imageScale(.large)
                            .font(.callout)
                        if let date = date {
                            Text(verbatim: date.formatted(.relative(presentation: .named, unitsStyle: .wide)))
                                .foregroundStyle(.secondary)
                                .font(.footnote)
                                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        }
                    }
                    .animation(.none, value: date)
                    .padding()
                    .modifier(Card())
                    .padding(.horizontal)
                }
                .animation(.none, value: date)
                .allowsHitTesting(false)
            }
            .onReceive(cloud) {
                date = $0.events.since
            }
            .sheet(isPresented: $display) {
                NavigationView {
                    Privacy.Activity()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    display = false
                                } label: {
                                    Text("Done")
                                        .font(.callout)
                                        .foregroundColor(.init("Shades"))
                                        .padding(.leading)
                                        .allowsHitTesting(false)
                                        .contentShape(Rectangle())
                                }
                            }
                        }
                }
                .navigationViewStyle(.stack)
            }
        }
    }
}
