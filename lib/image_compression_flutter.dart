import 'src/compressor.dart'
    if (dart.library.io) 'src/compressor_io.dart'
    if (dart.library.html) 'src/compressor_html.dart';
import 'src/interface.dart';

export 'package:cross_file/cross_file.dart' show XFile;
export 'package:image_compression/image_compression.dart' show ImageFile;

export 'src/configurations.dart';
export 'src/extension.dart' show XFileExtension;

/// Global singleton instance for image compressor
final ImageCompressionFlutter compressor = getCompressor();
