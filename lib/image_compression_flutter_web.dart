import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:image_compression_flutter/src/compressor_html.dart';

import 'image_compression_flutter.dart';
import 'src/extension.dart';

/// A web implementation of the ImageCompressionFlutter plugin.
class ImageCompressionFlutterWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'image_compression_flutter',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = ImageCompressionFlutterWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    final compressor = getCompressor();
    final ImageFile output;

    switch (call.method) {
      case 'compress':
        final param = ImageFileConfigurationExtension.decode(call.arguments);

        switch (param.config.outputType) {
          case ImageOutputType.webpThenJpg:
            output = await compressor.compressWebpThenJpg(param);
            break;
          case ImageOutputType.webpThenPng:
            output = await compressor.compressWebpThenPng(param);
            break;
          case ImageOutputType.jpg:
            output = await compressor.compressJpg(param);
            break;
          case ImageOutputType.png:
            output = await compressor.compressPng(param);
            break;
        }
        break;
      case 'compressWebpThenJpg':
        final param = ImageFileConfigurationExtension.decode(call.arguments);
        output = await compressor.compressWebpThenJpg(param);
        break;
      case 'compressWebpThenPng':
        final param = ImageFileConfigurationExtension.decode(call.arguments);
        output = await compressor.compressWebpThenPng(param);
        break;
      case 'compressJpg':
        final param = ImageFileConfigurationExtension.decode(call.arguments);
        output = await compressor.compressJpg(param);
        break;
      case 'compressPng':
        final param = ImageFileConfigurationExtension.decode(call.arguments);
        output = await compressor.compressPng(param);
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'image_compression_flutter for web doesn\'t implement \'${call.method}\'',
        );
    }

    return output.toMap();
  }
}
