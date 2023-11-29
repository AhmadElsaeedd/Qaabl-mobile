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
  CameraController? cameraController;
  final FaceDetector faceDetector =
      FaceDetector(options: FaceDetectorOptions(enableClassification: true));
  bool canProcess = true;
  bool isBusy = false;
  CustomPaint? customPaint;
  String? text;
  var cameraLensDirection = CameraLensDirection.front;

  int size_is_good = 0;
  int smile = 0;

  void Function()? onCaptureRequested;

  Future<void> processImage(InputImage inputImage) async {
    if (!canProcess) return;
    if (isBusy) return;
    isBusy = true;
    text = '';
    rebuildUi();
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
          if (smileProb! < 0.5) {
            smile = 1;
          } else if (smileProb >= 0.5) {
            smile = 2;
            take_pic();
          } else {
            smile = 0;
          }
        }
      }
    }
    isBusy = false;
    rebuildUi();
  }

  void take_pic() {
    if (true) {
      onCaptureRequested?.call();
    }
  }

  @override
  void dispose() {
    canProcess = false;
    faceDetector.close();
    // Dispose of the controller when the view model is disposed.
    cameraController?.dispose();
    super.dispose();
  }
}
