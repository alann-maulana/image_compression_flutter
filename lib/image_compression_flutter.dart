import 'src/compressor.dart'
    if (dart.library.io) 'src/compressor_io.dart'
    if (dart.library.html) 'src/compressor_html.dart';
import 'src/interface.dart';

export 'src/configurations.dart';

final ImageCompressionFlutter compressor = getCompressor();
