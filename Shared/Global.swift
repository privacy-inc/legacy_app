import Archivable
import Specs

let cloud = Cloud<Archive>.new(identifier: "iCloud.privacy")

#if os(iOS) || os(macOS)
let favicon = Favicon()
let store = Store()
#endif
