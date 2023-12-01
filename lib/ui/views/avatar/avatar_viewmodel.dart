import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'face_detector_painter.dart';
import 'camera_view.dart';

class AvatarViewModel extends BaseViewModel {
  // CameraController? cameraController;
  final FaceDetector faceDetector =
      FaceDetector(options: FaceDetectorOptions(enableClassification: true));
  bool canProcess = true;
  bool isBusy = false;
  CustomPaint? customPaint;
  String? text;
  var cameraLensDirection = CameraLensDirection.front;

  int size_is_good = 0;
  int smile = 0;
  Timer? _countdownTimer;
  int _countdownSeconds = 1;
  bool image_captured = false;

  void Function()? onCaptureRequested;

  Future<void> processImage(InputImage inputImage) async {
    if (!canProcess) return;
    if (isBusy) return;
    isBusy = true;
    text = '';
    rebuildUi();
    bool conditionsMet = false;
    final faces = await faceDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      for (final face in faces) {
        final Rect boundingBox = face.boundingBox;
        if ((boundingBox.height < 500 && boundingBox.width < 500)) {
          size_is_good = 2;
        } else if ((boundingBox.height > 700 && boundingBox.width > 700)) {
          size_is_good = 3;
        } else if ((boundingBox.height <= 700 && boundingBox.height >= 500) &&
            (boundingBox.width <= 700 && boundingBox.width >= 500)) {
          size_is_good = 1;
        } else {
          size_is_good = 0;
        }
        if (face.smilingProbability != null) {
          final double? smileProb = face.smilingProbability;
          if (smileProb! < 0.6) {
            smile = 1;
          } else if (smileProb >= 0.6) {
            smile = 2;
          } else {
            smile = 0;
          }
        }
        if (size_is_good == 1 && smile == 2) {
          conditionsMet = true;
          take_pic();
          break;
        }
      }
    }
    if (!conditionsMet) {
      // If conditions are not met, reset the countdown
      _resetCountdown();
    }
    isBusy = false;
    rebuildUi();
  }

  void take_pic() {
    if (size_is_good == 1 && smile == 2) {
      if (_countdownTimer == null || !_countdownTimer!.isActive) {
        // Start the countdown
        _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          if (_countdownSeconds > 0) {
            // Update the countdown
            _countdownSeconds--;
            rebuildUi(); // Notify the UI about the countdown change
          } else {
            // Countdown finished, take the picture
            _countdownTimer?.cancel();
            _countdownSeconds = 1; // Reset the countdown
            onCaptureRequested?.call();
            image_captured = true;
          }
        });
      }
    } else {
      // Reset the timer and countdown if conditions are not met
      _resetCountdown();
    }
  }

  void _resetCountdown() {
    _countdownTimer?.cancel();
    _countdownSeconds = 1;
  }

  @override
  void dispose() {
    canProcess = false;
    faceDetector.close();
    _countdownTimer?.cancel();
    // Dispose of the controller when the view model is disposed.
    // cameraController?.dispose();
    super.dispose();
  }
}
