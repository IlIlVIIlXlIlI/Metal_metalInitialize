//
//  ViewController.swift
//  metalInitialize
//
//  Created by Shogo Nobuhara on 2021/01/21.
//

import UIKit
import MetalKit

class ViewController: UIViewController,MTKViewDelegate{

    @IBOutlet private weak var mtkView: MTKView!
    
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize){}

    
    /**
     @method drawInMTKView:
     @abstract Called on the delegate when it is asked to render into the view
     @discussion Called on the delegate when it is asked to render into the view
     */
    func draw(in view: MTKView){}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

