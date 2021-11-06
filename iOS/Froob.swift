import SwiftUI

struct Froob: View {
    @State private var learn = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Image("Logo")
                        .frame(maxWidth: .greatestFiniteMagnitude)
                        .padding(.top)
                    Text("\(Text("Privacy").font(.title2.weight(.medium))) \(Image(systemName: "plus"))")
                        .foregroundColor(.primary)
                        .font(.title.weight(.ultraLight))
                        .imageScale(.large)
                        .frame(maxWidth: .greatestFiniteMagnitude)
                }
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
                .listRowBackground(Color.clear)
                
                Section {
                    Text(.init(Copy.froob))
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundStyle(.secondary)
                        .font(.callout)
                }
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
                .listRowBackground(Color.clear)
                .allowsHitTesting(false)
                
                Section {
                    Button {
                        learn = true
                    } label: {
                        Text("Learn more")
                            .frame(height: 28)
                            .frame(maxWidth: .greatestFiniteMagnitude)
                            .allowsHitTesting(false)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $learn) {
                dismiss()
            } content: {
                NavigationView {
                    Plus()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    learn = false
                                } label: {
                                    Text("Close")
                                        .font(.callout)
                                        .foregroundColor(.secondary)
                                        .padding(.leading)
                                        .frame(height: 34)
                                        .allowsHitTesting(false)
                                        .contentShape(Rectangle())
                                }
                            }
                        }
                }
                .navigationViewStyle(.stack)
            }
        }
        .navigationViewStyle(.stack)
    }
}
