import AppKit
import WebKit
import Combine

extension Downloads {
    final class Item: NSView {
        let download: WKDownload
        private weak var title: Text!
        private weak var stop: Control.Symbol!
        private weak var again: Control.Symbol!
        private weak var show: Control.Symbol!
        private var data: Data?
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(download: WKDownload) {
            self.download = download
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let title = Text(vibrancy: true)
            title.font = .preferredFont(forTextStyle: .callout)
            title.textColor = .labelColor
            title.lineBreakMode = .byTruncatingTail
            title.maximumNumberOfLines = 1
            title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            self.title = title
            
            let base = NSView()
            base.translatesAutoresizingMaskIntoConstraints = false
            
            let bar = Separator()
            bar.layer!.cornerRadius = 3
            base.addSubview(bar)
            
            let progress = NSView()
            progress.translatesAutoresizingMaskIntoConstraints = false
            progress.wantsLayer = true
            progress.layer!.cornerRadius = bar.layer!.cornerRadius
            progress.layer!.backgroundColor = NSColor.systemBlue.cgColor
            base.addSubview(progress)
            
            let weight = Text(vibrancy: true)
            weight.font = .monospacedDigitSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .caption1).pointSize, weight: .regular)
            weight.textColor = .labelColor
            weight.maximumNumberOfLines = 1
            weight.alignment = .right
            base.addSubview(weight)
            
            let stop = Control.Symbol("xmark.circle.fill", point: 18, size: 28, weight: .regular, hierarchical: true)
            stop
                .click
                .sink { [weak self] in
                    Task { [weak self] in
                        self?.cancel(data: await download.cancel())
                    }
                }
                .store(in: &subs)
            self.stop = stop
            
            let again = Control.Symbol("arrow.clockwise.circle.fill", point: 18, size: 28, weight: .regular, hierarchical: true)
            again.state = .hidden
            again
                .click
                .sink { [weak self] in
                    Task { [weak self] in
                        let downloads = (self?.window as? Window)?.downloads
                        
                        if let data = self?.data,
                           let resume = await download.webView?.resumeDownload(fromResumeData: data) {
                            
                            resume.delegate = download.webView as? Web
                            resume.progress.fileURL = download.progress.fileURL
                            downloads?.add(download: resume)
                        }
                        
                        if let self = self {
                            downloads?.remove(item: self)
                        }
                    }
                }
                .store(in: &subs)
            self.again = again
            
            let show = Control.Symbol("magnifyingglass.circle.fill", point: 18, size: 28, weight: .regular, hierarchical: true)
            show.state = .hidden
            show
                .click
                .sink { [weak self] in
                    guard let url = self?.download.progress.fileURL else { return }
                    NSWorkspace.shared.activateFileViewerSelecting([url])
                }
                .store(in: &subs)
            self.show = show
            
            let stack = Stack(views: [title, base, stop, again, show])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.distribution = .fill
            stack.alignment = .centerY
            addSubview(stack)
            
            let separator = Separator()
            addSubview(separator)
            
            heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            base.widthAnchor.constraint(equalToConstant: 180).isActive = true
            base.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            weight.rightAnchor.constraint(equalTo: base.rightAnchor).isActive = true
            weight.bottomAnchor.constraint(equalTo: bar.topAnchor, constant: -3).isActive = true
            
            bar.bottomAnchor.constraint(equalTo: base.bottomAnchor, constant: -11).isActive = true
            bar.leftAnchor.constraint(equalTo: base.leftAnchor).isActive = true
            bar.rightAnchor.constraint(equalTo: base.rightAnchor).isActive = true
            bar.heightAnchor.constraint(equalToConstant: 6).isActive = true
            
            progress.topAnchor.constraint(equalTo: bar.topAnchor).isActive = true
            progress.leftAnchor.constraint(equalTo: bar.leftAnchor).isActive = true
            progress.bottomAnchor.constraint(equalTo: bar.bottomAnchor).isActive = true
            
            separator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1).isActive = true
            separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
            stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            stack.widthAnchor.constraint(lessThanOrEqualToConstant: 500).isActive = true
            let expand = stack.widthAnchor.constraint(equalToConstant: 500)
            expand.priority = .defaultLow
            expand.isActive = true

            download
                .progress
                .publisher(for: \.localizedAdditionalDescription)
                .removeDuplicates()
                .sink {
                    weight.stringValue = $0
                }
                .store(in: &subs)
            
            download
                .progress
                .publisher(for: \.fractionCompleted)
                .removeDuplicates()
                .sink {
                    progress.animator().frame.size.width = 180 * $0
                }
                .store(in: &subs)
            
            download
                .progress
                .publisher(for: \.isFinished)
                .combineLatest(download
                    .progress
                    .publisher(for: \.localizedDescription))
                .sink { finished, localizedDescription in
                    if finished {
                        title.stringValue = download.progress.fileURL?.lastPathComponent ?? "Download finished"
                        show.state = .on
                        again.state = .hidden
                        stop.state = .hidden
                    } else {
                        title.stringValue = localizedDescription ?? "Downloading..."
                    }
                }
                .store(in: &subs)
        }
        
        @MainActor func cancel(data: Data?) {
            self.data = data
            title.stringValue = download.originalRequest?.url?.absoluteString ?? "Download failed..."
            again.state = .on
            stop.state = .hidden
            show.state = .hidden
        }
    }
}
