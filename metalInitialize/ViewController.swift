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
    private let device = MTLCreateSystemDefaultDevice()!
    private var commandQueue: MTLCommandQueue!
    private var texture: MTLTexture!
    
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        print("\(self.classForCoder)/" + #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Metalのセットアップ
        setUpMetal()
        
        // 画像を読み込む
        loadTexture()
        
        mtkView.enableSetNeedsDisplay = true
        mtkView.framebufferOnly = false
        
        // ビューの更新依頼
        mtkView.setNeedsDisplay()
        
    }
    
    private func setUpMetal() {
        // MTLCommandQueueを初期化
        commandQueue = device.makeCommandQueue()
        
        // MTKViewのセットアップ
        mtkView.device = device
        mtkView.delegate = self
    }
    
    private func loadTexture(){
        // MTKTextureLoaderを初期化
        let textureLoader = MTKTextureLoader(device: device)
        
        // テクスチャをロード
        texture = try! textureLoader.newTexture(name: "BigSur",
                                                scaleFactor: view.contentScaleFactor,
                                                bundle: nil)
        
        // ピクセルフォーマットを合わせる
        mtkView.colorPixelFormat = texture.pixelFormat
    }
    
    func draw(in view: MTKView){
        // ドローアブルを取得
        guard let drawable = view.currentDrawable else{return}
        
        // コマンドバッファの作成
        let commandBuffer = commandQueue.makeCommandBuffer()!
        
        // コピーするサイズを計算
        let w = min(texture.width,drawable.texture.width)
        let h = min(texture.height,drawable.texture.height)
        
        // MTLBlitCommandEncoderを作成
        let blitEncoder = commandBuffer.makeBlitCommandEncoder()!
        
        // コピーコマンドをエンコード
        blitEncoder.copy(from: texture,             // コピー元テクスチャから
                         sourceSlice: 0,
                         sourceLevel: 0,
                         sourceOrigin: MTLOrigin(x: 0, y: 0, z: 0),
                         sourceSize: MTLSizeMake(w, h, texture.depth),
                         to: drawable.texture,      // コピー先テクスチャへ
                         destinationSlice: 0,
                         destinationLevel: 0,
                         destinationOrigin: MTLOrigin(x: 0, y: 0, z: 0)
                         )
        
        // エンコードを完了
        blitEncoder.endEncoding()
        
        // 表示するドローアブルを登録
        commandBuffer.present(drawable)
        
        // コマンドバッファをコミット(エンキューする)
        commandBuffer.commit()
    }


}

