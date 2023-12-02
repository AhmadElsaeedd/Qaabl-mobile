import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private let channelName = "com.qaabl/native_image_processor"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)

    methodChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      // Handle image processing
      if call.method == "processImage" {
        self?.handleProcessImage(call: call, result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    private func handleProcessImage(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let imagePath = args["imagePath"] as? String,
              let image = UIImage(contentsOfFile: imagePath) else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Image path not provided", details: nil))
            return
        }

        Task {
            do {
                let backgroundRemoved = try await removeBackground(of: image)
                if let data = backgroundRemoved.pngData() {
                    let tempDir = NSTemporaryDirectory()
                    
                    // Generate a unique file name for each processed image
                    let uniqueFileName = "processed_image_\(UUID().uuidString).png"
                    let imageFileURL = URL(fileURLWithPath: tempDir).appendingPathComponent(uniqueFileName)
                    
                    try data.write(to: imageFileURL)
                    
                    // Return the unique file path to Flutter
                    result(imageFileURL.path)
                }
            } catch {
                // Handle errors
                result(FlutterError(code: "PROCESSING_ERROR", message: "Failed to process image", details: error.localizedDescription))
            }
        }
    }


}
