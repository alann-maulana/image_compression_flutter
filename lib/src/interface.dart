import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_compression/image_compression.dart' as ic;

import 'configurations.dart';
import 'extension.dart';

/// Image compression engine
abstract class ImageCompressionFlutter {
  static const MethodChannel _channel =
      const MethodChannel('image_compression_flutter');

  @protected
  Future dummyCallNativeCode(
    String method,
    Map<String, dynamic> data,
    Future<ic.ImageFile> Function() callback,
  ) async {
    try {
      // Invoke will work only on Web, otherwise it will execute callback
      final result = await _channel.invokeMethod(method, data);
      if (result is Map) {
        return ImageFileExtension.decode(result);
      }

      return null;
    } on MissingPluginException catch (_) {
      return await callback();
    }
  }

  /// Compressing image into supported format
  Future<ic.ImageFile> compress(ImageFileConfiguration param) async {
    return await dummyCallNativeCode(
      'compress',
      param.toMap(),
      () {
        switch (param.config.outputType) {
          case ImageOutputType.webpThenJpg:
            return compressWebpThenJpg(param);
          case ImageOutputType.webpThenPng:
            return compressWebpThenPng(param);
          case ImageOutputType.jpg:
            return compressJpg(param);
          case ImageOutputType.png:
            return compressPng(param);
        }
      },
    );
  }

  /// Compressing image into WEBP if platform supported, otherwise JPG
  ///
  /// The [ImageOutputType] is set automatically to [ImageOutputType.webpThenJpg]
  Future<ic.ImageFile> compressWebpThenJpg(ImageFileConfiguration param);

  /// Compressing image into WEBP if platform supported, otherwise PNG
  ///
  /// The [ImageOutputType] is set automatically to [ImageOutputType.webpThenPng]
  Future<ic.ImageFile> compressWebpThenPng(ImageFileConfiguration param);

  /// Compressing image into JPG
  ///
  /// The [ImageOutputType] is set automatically to [ImageOutputType.jpg]
  Future<ic.ImageFile> compressJpg(ImageFileConfiguration param);

  /// Compressing image into PNG
  ///
  /// The [ImageOutputType] is set automatically to [ImageOutputType.png]
  Future<ic.ImageFile> compressPng(ImageFileConfiguration param);
}
