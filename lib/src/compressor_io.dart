import 'dart:async';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_compression/image_compression.dart' as ic;

import 'configurations.dart';
import 'dart_compressor.dart';
import 'flutter_compressor.dart';
import 'interface.dart';

export 'configurations.dart';

ImageCompressionFlutter getCompressor() => ImageCompressionFlutterIO();

class ImageCompressionFlutterIO extends ImageCompressionFlutter {
  @override
  Future<ic.ImageFile> compressWebpThenJpg(ImageFileConfiguration param) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await FlutterCompressor.compressWebpNativeAndroidIOS(
        param,
        CompressFormat.jpeg,
      );
    }

    return await compressJpg(param);
  }

  @override
  Future<ic.ImageFile> compressWebpThenPng(ImageFileConfiguration param) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await FlutterCompressor.compressWebpNativeAndroidIOS(
        param,
        CompressFormat.png,
      );
    }

    return await compressPng(param);
  }

  @override
  Future<ic.ImageFile> compressJpg(ImageFileConfiguration param) async {
    if (param.config.useJpgPngNativeCompressor &&
        (Platform.isAndroid || Platform.isIOS)) {
      return await FlutterCompressor.compressNativeAndroidIOS(
        param.input.rawBytes,
        param.config.quality,
        CompressFormat.jpeg,
      );
    }

    return await DartCompressor.compressJpgDart(param);
  }

  @override
  Future<ic.ImageFile> compressPng(ImageFileConfiguration param) async {
    if (param.config.useJpgPngNativeCompressor &&
        (Platform.isAndroid || Platform.isIOS)) {
      return await FlutterCompressor.compressNativeAndroidIOS(
        param.input.rawBytes,
        param.config.quality,
        CompressFormat.png,
      );
    }

    return await DartCompressor.compressPngDart(param);
  }
}
