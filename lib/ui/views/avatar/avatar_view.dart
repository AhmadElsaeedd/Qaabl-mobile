import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
              child: Text(
                "Your Avatar",
                textAlign: TextAlign.center,
                style: GoogleFonts.lexend(
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
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  if (viewModel.size_is_good == 0 &&
                      viewModel.image_captured == false) ...[
                    Text(
                      "we'd love ur face on camera!",
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else if ((viewModel.size_is_good == 1 &&
                          viewModel.image_captured == false) &&
                      viewModel.smile == 2) ...[
                    Text(
                      "yes, perfect!",
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else if ((viewModel.size_is_good == 1 &&
                          viewModel.image_captured == false) &&
                      viewModel.smile == 1) ...[
                    Text(
                      "we'd love a smile from u!",
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else if (viewModel.size_is_good == 2 &&
                      viewModel.image_captured == false) ...[
                    Text(
                      "come closer pls :)",
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else if (viewModel.size_is_good == 3 &&
                      viewModel.image_captured == false) ...[
                    Text(
                      "give the phone some space pls :)",
                      style: GoogleFonts.lexend(
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
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // ClipOval(
                        //   child:
                        DetectorView(
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
                        // ),
                        if (viewModel.size_is_good == 1 &&
                            viewModel.smile == 2 &&
                            viewModel.image_captured != true) ...[
                          Positioned(
                            top:
                                20, // You can adjust this value to position the countdown
                            child: viewModel.countdownSeconds > 0
                                ? Text(
                                    '${viewModel.countdownSeconds}',
                                    style: TextStyle(
                                      fontSize:
                                          48, // Large font size for visibility
                                      color: Colors
                                          .white, // Assuming a dark background; change as needed
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : SizedBox
                                    .shrink(), // Empty widget when countdown is not active
                          ),
                        ]
                      ],
                    ),
                  ),
                  Text(
                    "your images won't be stored anywhere.",
                    style: GoogleFonts.lexend(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
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
