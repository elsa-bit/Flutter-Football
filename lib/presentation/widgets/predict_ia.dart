import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

Future<String> predict(String imagePath) async {
  // Load TFLite model
  final interpreter =
      await Interpreter.fromAsset('assets/ia/model_obscene_real2.tflite');

  // Load and process the image
  img.Image image = img.decodeImage(File(imagePath).readAsBytesSync())!;

  // Resize the image to 200x200
  img.Image resizedImage = img.copyResize(image, width: 200, height: 200);

  // Convert image to 3 channels (RGB)
  if (resizedImage.numChannels == 4) {
    img.Image rgbImage = img.Image(width: 200, height: 200);
    img.compositeImage(rgbImage, resizedImage);
    resizedImage = rgbImage;
  } else if (resizedImage.numChannels == 1) {
    img.Image rgbImage = img.Image(width: 200, height: 200);
    img.compositeImage(rgbImage, resizedImage);
    resizedImage = rgbImage;
  }

  // Normalize the image
  List input = imageToByteListFloat32(resizedImage, 200);

  // Run inference
  var output = List.filled(6, 0.0).reshape([1, 6]);
  interpreter.run(input, output);

  // Get the output
  List<double> predictions = output[0].cast<double>();
  List<String> classLabels = [
    'Control',
    'Gore',
    'Gun',
    'Insulting Gesture',
    'Knife',
    'Pornography'
  ];
  int predictedIndex = predictions.indexWhere(
      (value) => value == predictions.reduce((a, b) => a > b ? a : b));

  return classLabels[predictedIndex];
}

// Helper function to convert image to byte list
Uint8List imageToByteListFloat32(img.Image image, int inputSize) {
  var buffer = Uint8List(inputSize * inputSize * 3 * 4).buffer;
  var byteData = ByteData.view(buffer);
  int pixelIndex = 0;

  for (int y = 0; y < inputSize; y++) {
    for (int x = 0; x < inputSize; x++) {
      final pixel = image.getPixel(x, y);
      byteData.setFloat32(pixelIndex * 4, (pixel.r / 255.0), Endian.little);
      byteData.setFloat32(pixelIndex * 4 + 4, (pixel.g / 255.0), Endian.little);
      byteData.setFloat32(pixelIndex * 4 + 8, (pixel.b / 255.0), Endian.little);
      pixelIndex++;
    }
  }

  return buffer.asUint8List();
}
