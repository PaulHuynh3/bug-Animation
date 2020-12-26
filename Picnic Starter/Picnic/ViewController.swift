// https://www.raywenderlich.com/5255-basic-uiview-animation-tutorial-getting-started

import UIKit
import AVFoundation

class ViewController: UIViewController {
  
  @IBOutlet weak var basketTop: UIImageView!
  @IBOutlet weak var basketBottom: UIImageView!
  
  @IBOutlet weak var fabricTop: UIImageView!
  @IBOutlet weak var fabricBottom: UIImageView!
  
  @IBOutlet weak var basketTopConstraint : NSLayoutConstraint!
  @IBOutlet weak var basketBottomConstraint : NSLayoutConstraint!
  
  @IBOutlet weak var bug: UIImageView!

  var isBugDead = false
  var tap: UITapGestureRecognizer!

  let squishPlayer: AVAudioPlayer

  
  required init?(coder aDecoder: NSCoder) {
    let squishURL = Bundle.main.url(forResource: "squish", withExtension: "caf")!
    squishPlayer = try! AVAudioPlayer(contentsOf: squishURL)
    squishPlayer.prepareToPlay()

    super.init(coder: aDecoder)
    tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
  }
  
  override func viewDidAppear(_ animated: Bool) {
    openBasket()
    openNapkins()
    moveBugLeft()
    view.addGestureRecognizer(tap)
  }

  // basketTop, basketBottom has constraints which makes it harder to animate

  func openBasket() {
    //this can be outside uiview.animate or inside no difference... just need to call layoutIfNeeded
    basketTopConstraint.constant -= basketTop.frame.size.height
    basketBottomConstraint.constant -= basketBottom.frame.size.height

    UIView.animate(withDuration: 0.7, delay: 1.0, options: .curveEaseOut, animations: {
      self.view.layoutIfNeeded()
    }, completion: { finished in
      print("Basket doors opened!")
    })
  }

  // FabricTop, FabricBottom has no constraints
  func openNapkins() {
    UIView.animate(withDuration: 1.0, delay: 1.2, options: .curveEaseOut, animations: {
      var fabricTopFrame = self.fabricTop.frame
      fabricTopFrame.origin.y -= fabricTopFrame.size.height

      var fabricBottomFrame = self.fabricBottom.frame
      fabricBottomFrame.origin.y += fabricBottomFrame.size.height

      self.fabricTop.frame = fabricTopFrame
      self.fabricBottom.frame = fabricBottomFrame
    }, completion: { finished in
      print("Napkins opened!")
    })
  }

  //Bug has no constraint
  func moveBugLeft() {
    if isBugDead { return }
    UIView.animate(withDuration: 1.0,
                   delay: 2.0,
                   options: [.curveEaseInOut , .allowUserInteraction],
                   animations: {
                    self.bug.center = CGPoint(x: 75, y: 200)
    },
                   completion: { finished in
                    print("Bug moved left!")
                    self.faceBugRight()
    })
  }

  func faceBugRight() {
    if isBugDead { return }
    UIView.animate(withDuration: 1.0,
                   delay: 0.0,
                   options: [.curveEaseInOut , .allowUserInteraction],
                   animations: {
                    self.bug.transform = CGAffineTransform(rotationAngle: .pi)
    },
                   completion: { finished in
                    print("Bug faced right!")
                    self.moveBugRight()
    })
  }

  func moveBugRight() {
    if isBugDead { return }
    UIView.animate(withDuration: 1.0,
                   delay: 2.0,
                   options: [.curveEaseInOut , .allowUserInteraction],
                   animations: {
                    self.bug.center = CGPoint(x: self.view.frame.width - 75, y: 250)
    },
                   completion: { finished in
                    print("Bug moved right!")
                    self.faceBugLeft()
    })
  }

  func faceBugLeft() {
    if isBugDead { return }
    UIView.animate(withDuration: 1.0,
                   delay: 0.0,
                   options: [.curveEaseInOut , .allowUserInteraction],
                   animations: {
                    self.bug.transform = CGAffineTransform(rotationAngle: 0.0)
    },
                   completion: { finished in
                    print("Bug faced left!")
                    self.moveBugLeft()
    })
  }

  //Need to check the bug.layer.Presentation().frame to see if the bug is there because this is where the bug is at this given moment... if i was to check the bug.layer.frame it would not update with animation quick enough
  @objc func handleTap(_ gesture: UITapGestureRecognizer) {
    let tapLocation = gesture.location(in: bug.superview)
    if (bug.layer.presentation()?.frame.contains(tapLocation))! {
      print("Bug tapped!")
      if isBugDead { return }
      view.removeGestureRecognizer(tap)
      isBugDead = true
      squishPlayer.play()
      UIView.animate(withDuration: 0.7, delay: 0.0,
                     options: [.curveEaseOut , .beginFromCurrentState], animations: {
        self.bug.transform = CGAffineTransform(scaleX: 1.25, y: 0.75)
      }, completion: { finished in
        UIView.animate(withDuration: 2.0, delay: 2.0, options: [], animations: {
          self.bug.alpha = 0.0
        }, completion: { finished in
          self.bug.removeFromSuperview()
        })
      })
    } else {
      print("Bug not tapped!")
    }
  }

}
