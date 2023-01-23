//
//  ContentView.swift
//  testImgly
//
//  Created by Mostafa ALZOUBI on 18/01/2023.
//

import SwiftUI


class Example: NSObject {
    /// The view controller that this example is being invoked from.
    weak var presentingViewController: UIViewController?

    func invokeExample() {
    }
}
struct ContentView: View {
    @State var presentVideoEditor = false
    var body: some View {
        VStack {

            Button {
              presentVideoEditor = true
            } label: {
                Text("try imgley")
            }

        }
        .padding()
        .sheet(isPresented: $presentVideoEditor) {
            VideoEditorSwiftUIView(video: Video(url: Bundle.main.url(forResource: "30 Minute Timer", withExtension: "mp4")!))
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


import SwiftUI
import UIKit
import VideoEditorSDK
import ImglyKit
import AVFoundation
import Foundation
import UniformTypeIdentifiers

class ShowVideoEditorSwiftUISwift: Example, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  override func invokeExample() {

      let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.mediaTypes = [UTType.movie.identifier]

        // Setting `videoExportPreset` to passthrough will not reencode the video before passing it to
        // the delegate methods.
        imagePicker.videoExportPreset = AVAssetExportPresetPassthrough
      imagePicker.modalPresentationStyle = .fullScreen
        // Present the image picker modally.
    presentingViewController?.present(imagePicker, animated: true, completion: nil)
  }
}

// A `View` that hosts the `VideoEditor` in order
// to use it in this `UIKit` example application.
struct VideoEditorSwiftUIView: View {
  // The action to dismiss the view.
  internal var dismissAction: (() -> Void)?

  // The video being edited.
  let video: Video

  var body: some View {
    VideoEditor(video: video)
      .onDidSave { result in
        // The user exported a new video successfully and the newly generated video is located at `result.output.url` of the returned `VideoEditorResult`. Dismissing the editor.
        print("Received video at \(result.output.url.absoluteString)")
        dismissAction?()
      }
      .onDidCancel {
        // The user tapped on the cancel button within the editor. Dismissing the editor.
        dismissAction?()
      }
      .onDidFail { error in
        // There was an error generating the video.
        print("Editor finished with error: \(error.localizedDescription)")
        // Dismissing the editor.
        dismissAction?()
      }
      // In order for the editor to fill out the whole screen it needs
      // to ignore the safe area.
      .ignoresSafeArea()
  }
}

