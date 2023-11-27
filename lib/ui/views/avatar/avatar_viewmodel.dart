import 'package:camera/camera.dart';
import 'package:stacked/stacked.dart';

class AvatarViewModel extends BaseViewModel {
  CameraController? cameraController;

  Future<void> initializeCamera() async {
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

    // Next, you need to initialize the controller. This returns a Future.
    await cameraController!.initialize();
    notifyListeners();
  }

  @override
  void dispose() {
    // Dispose of the controller when the view model is disposed.
    cameraController?.dispose();
    super.dispose();
  }
}
