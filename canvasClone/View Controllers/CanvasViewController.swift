//
//  CanvasViewController.swift
//  canvasClone
//
//  Created by Kyle Mamiit (New) on 11/22/18.
//  Copyright © 2018 Kyle Mamiit. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!

    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        trayDownOffset = 160
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
    }
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        var velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            trayOriginalCenter = trayView.center;
        } else if sender.state == .changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y);
        } else if sender.state == .ended {

            if velocity.y > 0 { // Moving down
                UIView.animate(withDuration: 0.3) {
                    self.trayView.center = self.trayDown
                }
            } else { //Moving up
                UIView.animate(withDuration: 0.3) {
                    self.trayView.center = self.trayUp
                }
            }
        }
    }
    
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        var translation = sender.translation(in: view)
        
        if sender.state == .began {
            var imageView = sender.view as! UIImageView;
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            UIView.animate(withDuration: 0.3, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            })
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.4, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            
            newlyCreatedFace.isUserInteractionEnabled = true
            let newGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didNewPanFace(sender:)));
            newlyCreatedFace.isUserInteractionEnabled = true;
            newlyCreatedFace.addGestureRecognizer(newGestureRecognizer);
        }
    }
    
    @objc func didNewPanFace(sender: UIPanGestureRecognizer){
        var translation = sender.translation(in: view)

        if sender.state == .began {
            newlyCreatedFace = sender.view as! UIImageView // to get the face that we panned on.
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center // so we can offset by translation later.

            UIView.animate(withDuration: 0.3, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            })
        }
            
        else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
            
        else if sender.state == .ended {            
            UIView.animate(withDuration: 0.4, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
