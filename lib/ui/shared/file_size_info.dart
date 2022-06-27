import 'dart:io';
import 'dart:math' as m;

class FileSizeInfo {
  const FileSizeInfo(
    this.bytes,
    this.title,
  );

  static const _suffixes = [
    'B',
    'KB',
    'MB',
    'GB',
    'TB',
    'PB',
    'EB',
    'ZB',
    'YB'
  ];

  final int bytes;
  final String title;

  static Future<FileSizeInfo> getSize(
    String filePath, {
    int decimals = 2,
  }) async {
    final file = File(filePath);
    final bytes = await file.length();
    if (bytes <= 0) {
      return const FileSizeInfo(0, '0 B');
    }

    final i = (m.log(bytes) / m.log(1024)).floor();
    final title =
        '${(bytes / m.pow(1024, i)).toStringAsFixed(decimals)} ${_suffixes[i]}';

    return FileSizeInfo(bytes, title);
  }

  @override
  String toString() => title;
}
