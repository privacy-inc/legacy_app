import Archivable
import Specs
import CloudKit

let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.privacy")

#if os(iOS) || os(macOS)
let favicon = Favicon()
var store = Store()
#endif
