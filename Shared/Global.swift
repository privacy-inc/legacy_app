import Archivable
import Specs

let cloud = Cloud<Archive>.new(identifier: "iCloud.privacy")

#if os(iOS) || os(macOS)
let favicon = Favicon()
var store = Store()
#endif
