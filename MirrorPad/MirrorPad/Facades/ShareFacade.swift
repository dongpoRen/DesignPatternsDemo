import UIKit

public class ShareFacade {
  public unowned var entireDrawing: UIView
  public unowned var inputDrawing: UIView
  public unowned var parentViewController: UIViewController
  
  private var imageRenderer = ImageRenderer()
  
  public init(entireDrawing: UIView,
              inputDrawing: UIView,
              parentViewController: UIViewController) {
    self.entireDrawing = entireDrawing
    self.inputDrawing = inputDrawing
    self.parentViewController = parentViewController
  }
  
  public func presentShareController() {
    let selectionViewController =
      DrawingSelectionViewController.createInstance(
      entireDrawing: entireDrawing,
      inputDrawing: inputDrawing,
      delegate: self)
    parentViewController.present(selectionViewController, animated: true)
  }
}

extension ShareFacade: DrawingSelectionViewControllerDelegate {
  public func drawingSelectionViewControllerDidCancel(_ viewController: DrawingSelectionViewController) {
    parentViewController.dismiss(animated: true)
  }
  
  public func drawingSelectionViewController(_ viewController: DrawingSelectionViewController, didSelectView view: UIView) {
    parentViewController.dismiss(animated: false)
    let image = imageRenderer.convertViewToImage(view)
    let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    parentViewController.present(activityController, animated: true)
  }
}
