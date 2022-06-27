import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/safe_coding/src/either.dart';
import '../../../domain/core/extended_errors.dart';

class ImagePickerService extends GetxService {
  final _picker = ImagePicker();

  Future<Either<ExtendedErrors, String?>> getGalleryFile() async {
    try {
      final pickedGalleryFile =
          await _picker.pickImage(source: ImageSource.gallery);
      return Right(pickedGalleryFile?.path ?? '');
    } on Exception catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    }
  }

  Future<Either<ExtendedErrors, String?>> getCameraFile() async {
    try {
      final pickedCameraFile =
          await _picker.pickImage(source: ImageSource.camera);
      return Right(pickedCameraFile?.path ?? '');
    } on Exception catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    }
  }
}
