import AppKit

extension Plus {
    final class Purchased: NSView {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            
            let check = Image(icon: "checkmark.circle.fill", vibrancy: false)
            check.symbolConfiguration = .init(textStyle: .largeTitle)
                .applying(.init(hierarchicalColor: .init(named: "Shades")!))
            
            addSubview(check)
            
            check.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
            check.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            
//            Section {
//                Image(systemName: "checkmark.circle.fill")
//                    .font(.largeTitle)
//                    .symbolRenderingMode(.multicolor)
//                    .frame(maxWidth: .greatestFiniteMagnitude)
//
//                Group {
//                    Text("We received your support\n")
//                        .foregroundColor(.secondary)
//                    + Text("Thank you!")
//                        .foregroundColor(.primary)
//                }
//                .font(.footnote)
//                .multilineTextAlignment(.center)
//                .fixedSize(horizontal: false, vertical: true)
//                .frame(maxWidth: .greatestFiniteMagnitude)
//                .padding(.bottom)
//            }
//            .listRowSeparator(.hidden)
//            .listSectionSeparator(.hidden)
//            .listRowBackground(Color.clear)
//            .allowsHitTesting(false)
        }
    }
}
