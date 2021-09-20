import UIKit

extension UISplitViewController: UISplitViewControllerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        show(.primary)
        delegate = self
    }
    
    public func splitViewController(_: UISplitViewController, topColumnForCollapsingToProposedTopColumn: Column) -> Column {
        .secondary
    }
}
