import CloudKit
import Archivable
import Specs

let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.privacy")

#if os(iOS) || os(macOS)
let favicon = Favicon()
var store = Store()
#endif
