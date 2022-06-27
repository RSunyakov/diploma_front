import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import '../../core/safe_coding/src/either.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/core/extended_errors.dart';
import 'file_extension.dart';
import 'file_size_info.dart';

class ImageCompressor {
  static Future<Either<ExtendedErrors, File?>> compress(
    String imagePath,
    int maxSizeInBytes,
  ) async {
    final file = File(imagePath);

    final ext = p.extension(file.path);
    if (ext.isEmpty) {
      return left(ExtendedErrors.simple('ext is empty'));
    }

    final size = await FileSizeInfo.getSize(imagePath);
    if (size.bytes <= maxSizeInBytes) {
      loggerSimple.i('File $size less then $maxSizeInBytes B');
      return right(file);
    }

    // const comeKoeff = 2;
    final diff = size.bytes - maxSizeInBytes; // 5 MB - 1 MB = 4 MB
    final diffPercent = (diff * 100) / size.bytes; // 90%
    final nextQuality = (100 - diffPercent).floor(); // 20%

    // w > 8000px
    // resize
    // crop  512X512
    loggerSimple.i(' => start compress for quality $nextQuality');

    final compressedFile =
        await _compress(nextQuality, imagePath, ext, maxSizeInBytes);

    return right(compressedFile);
  }

  static Future<File?> _compress(
    int quality,
    String path,
    String ext,
    int maxSize,
  ) async {
    final outPath = path.replaceAll(ext, '_out_$quality$ext');

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      path,
      outPath,
      quality: quality,
      format: _chooseCompressFormat(path),
    );

    final fileSize = await FileSizeInfo.getSize(outPath);
    if (fileSize.bytes > maxSize) {
      final nextQuality = quality - 20;
      loggerSimple.i(' => next quality $nextQuality');
      if (nextQuality <= 0) {
        return null;
      }
      return _compress(nextQuality, outPath, ext, maxSize);
    }

    return compressedFile;
  }

  static CompressFormat _chooseCompressFormat(String filepath) {
    final ext = FilePathExtensions.getExtension(filepath);
    switch (ext) {
      case FileExtension.jpeg:
        return CompressFormat.jpeg;
      case FileExtension.png:
        return CompressFormat.png;
      default:
        return CompressFormat.jpeg;
    }
  }
}
