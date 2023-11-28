import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'avatar_viewmodel.dart';

class AvatarView extends StackedView<AvatarViewModel> {
  const AvatarView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AvatarViewModel viewModel,
    Widget? child,
  ) {
    viewModel.initializeCamera();

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
              child: SizedBox(
                height: 350,
                width: 200,
                child: viewModel.cameraController == null ||
                        !viewModel.cameraController!.value.isInitialized
                    ? const Center(child: CircularProgressIndicator())
                    : ClipOval(
                        child: CameraPreview(viewModel.cameraController!),
                      ),
              ),
            ),
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
