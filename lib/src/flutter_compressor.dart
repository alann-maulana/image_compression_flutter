import 'dart:typed_data';

import 'package:image_compression/image_compression.dart' as ic;
import 'package:image_compression_flutter/flutter_image_compress.dart';

import 'configurations.dart';

class FlutterCompressor {
  static Future<ic.ImageFile> compressNativeAndroidIOS(
    Uint8List input,
    int quality,
    CompressFormat format,
  ) async {
    final rawBytes = await FlutterImageCompress.compressWithList(
      input,
      quality: quality,
      format: format,
    );

    return ic.ImageFile(
      filePath: '',
      rawBytes: rawBytes,
    );
  }

  static Future<ic.ImageFile> compressWebpNativeAndroidIOS(
    ImageFileConfiguration param,
    CompressFormat thenFormat,
  ) async {
    final input = param.input;
    final config = param.config;

    Uint8List rawBytes;
    try {
      rawBytes = await FlutterImageCompress.compressWithList(
        input.rawBytes,
        quality: config.quality,
        format: CompressFormat.webp,
      );
    } catch (_) {
      rawBytes = await FlutterImageCompress.compressWithList(
        input.rawBytes,
        quality: config.quality,
        format: thenFormat,
      );
    }

    return ic.ImageFile(
      filePath: '',
      rawBytes: rawBytes,
    );
  }
}
