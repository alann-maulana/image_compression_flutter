import 'dart:async';
import 'dart:io';

import 'package:image_compression/image_compression.dart' as ic;
import 'package:image_compression_flutter/flutter_image_compress.dart';

import 'configurations.dart';
import 'dart_compressor.dart';
import 'extension.dart';
import 'flutter_compressor.dart';
import 'interface.dart';

ImageCompressionFlutter getCompressor() => ImageCompressionFlutterIO();

class ImageCompressionFlutterIO extends ImageCompressionFlutter {
  @override
  Future<ic.ImageFile> compressWebpThenJpg(ImageFileConfiguration param) async {
    return await dummyCallNativeCode(
      'compressWebpThenJpg',
      param.toMap(),
      () {
        if (Platform.isAndroid || Platform.isIOS) {
          return FlutterCompressor.compressWebpNativeAndroidIOS(
            param,
            CompressFormat.jpeg,
          );
        }

        return compressJpg(param);
      },
    );
  }

  @override
  Future<ic.ImageFile> compressWebpThenPng(ImageFileConfiguration param) async {
    return await dummyCallNativeCode(
      'compressWebpThenPng',
      param.toMap(),
      () {
        if (Platform.isAndroid || Platform.isIOS) {
          return FlutterCompressor.compressWebpNativeAndroidIOS(
            param,
            CompressFormat.png,
          );
        }

        return compressPng(param);
      },
    );
  }

  @override
  Future<ic.ImageFile> compressJpg(ImageFileConfiguration param) async {
    return await dummyCallNativeCode(
      'compressJpg',
      param.toMap(),
      () {
        if (param.config.useJpgPngNativeCompressor &&
            (Platform.isAndroid || Platform.isIOS)) {
          return FlutterCompressor.compressNativeAndroidIOS(
            param.input.rawBytes,
            param.config.quality,
            CompressFormat.jpeg,
          );
        }

        return DartCompressor.compressJpgDart(param);
      },
    );
  }

  @override
  Future<ic.ImageFile> compressPng(ImageFileConfiguration param) async {
    return await dummyCallNativeCode(
      'compressPng',
      param.toMap(),
      () {
        if (param.config.useJpgPngNativeCompressor &&
            (Platform.isAndroid || Platform.isIOS)) {
          return FlutterCompressor.compressNativeAndroidIOS(
            param.input.rawBytes,
            param.config.quality,
            CompressFormat.png,
          );
        }

        return DartCompressor.compressPngDart(param);
      },
    );
  }
}
