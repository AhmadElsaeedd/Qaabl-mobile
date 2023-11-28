import 'package:camera/camera.dart';
import 'package:stacked/stacked.dart';

class AvatarViewModel extends BaseViewModel {
  CameraController? cameraController;
  bool _is_camera_initialized = false;

  Future<void> initializeCamera() async {
    if (_is_camera_initialized) {
      // Camera is already initialized.
      print("camera is already initialized");
      return;
    }

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Find the front camera.
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    // Initialize the controller with the front camera.
    cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );

    // Initialize the controller.
    await cameraController!.initialize();
    _is_camera_initialized = true;
    print("Camera initialized");
    rebuildUi();
  }

  @override
  void dispose() {
    // Dispose of the controller when the view model is disposed.
    cameraController?.dispose();
    super.dispose();
  }
}
