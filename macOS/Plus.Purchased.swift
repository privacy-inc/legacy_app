import AppKit

extension Plus {
    final class Purchased: NSView {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            
            let check = Image(icon: "checkmark.circle.fill", vibrancy: false)
            check.symbolConfiguration = .init(pointSize: 30, weight: .regular)
                .applying(.init(hierarchicalColor: .init(named: "Shades")!))
            addSubview(check)
            
            let text = Text(vibrancy: true)
            text.attributedStringValue = .init(message.with(alignment: .center))
            text.font = .preferredFont(forTextStyle: .body)
            addSubview(text)
            
            check.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
            check.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            text.topAnchor.constraint(equalTo: check.bottomAnchor, constant: 15).isActive = true
            
            
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
        
        private var message: AttributedString {
            .init("We received your support\n", attributes: .init([
                .foregroundColor: NSColor.secondaryLabelColor]))
            + .init("Thank you!", attributes: .init([
                .foregroundColor: NSColor.labelColor]))
        }
    }
}
