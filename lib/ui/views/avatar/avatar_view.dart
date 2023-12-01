import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qaabl_mobile/ui/views/avatar/detector_view.dart';
import 'package:stacked/stacked.dart';

import 'avatar_viewmodel.dart';

class AvatarView extends StackedView<AvatarViewModel> {
  AvatarView({Key? key}) : super(key: key);

  final GlobalKey detectorKey = GlobalKey();

  @override
  Widget builder(
    BuildContext context,
    AvatarViewModel viewModel,
    Widget? child,
  ) {
    viewModel.onCaptureRequested = () {
      // Use the correct key type and method call.
      final DetectorViewState? detectorViewState =
          detectorKey.currentState as DetectorViewState?;
      detectorViewState?.captureImage();
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Positioned Text at the top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: const Text(
                "Your Avatar",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            // Centered Camera Preview
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (viewModel.image_captured == true) ...[
                  Text(
                    "working our magic!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (viewModel.size_is_good == 0 &&
                    viewModel.image_captured == false) ...[
                  Text(
                    "bring ur face on camera!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ] else if (viewModel.size_is_good == 1 &&
                    viewModel.image_captured == false) ...[
                  Text(
                    "yes, perfect!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ] else if (viewModel.size_is_good == 2 &&
                    viewModel.image_captured == false) ...[
                  Text(
                    "come closer pls :)",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ] else if (viewModel.size_is_good == 3 &&
                    viewModel.image_captured == false) ...[
                  Text(
                    "give the phone some space pls :)",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                    height: 500,
                    width: 350,
                    child: ClipOval(
                      child: DetectorView(
                        key: detectorKey,
                        title: 'Face Detector',
                        customPaint: viewModel.customPaint,
                        text: viewModel.text,
                        onImage: viewModel.processImage,
                        initialCameraLensDirection:
                            viewModel.cameraLensDirection,
                        onCameraLensDirectionChanged: (value) =>
                            viewModel.cameraLensDirection = value,
                      ),
                    )),
                SizedBox(
                  height: 5,
                ),
                if (viewModel.smile == 0) ...[
                  Text(""),
                ] else if (viewModel.smile == 1 &&
                    viewModel.image_captured == false) ...[
                  Text(
                    "we'd love a smile from u!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ] else if (viewModel.smile == 2 &&
                    viewModel.image_captured == false) ...[
                  Text(
                    "yes, beautiful!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]
              ],
            )),
          ],
        ),
      ),
    );
  }

  @override
  AvatarViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AvatarViewModel();
}
