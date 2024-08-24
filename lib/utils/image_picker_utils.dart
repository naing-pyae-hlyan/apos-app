import 'package:apos_app/lib_exp.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  static final ImagePicker _imagePicker = ImagePicker();
  static Future<AttachmentFile?> pickImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    XFile? pickedFile;
    try {
      pickedFile = await _imagePicker.pickImage(
        source: source,
        maxHeight: 720,
        maxWidth: 720,
      );
    } catch (e) {
      throw UnimplementedError(e.toString());
    }

    if (pickedFile == null) return null;

    try {
      String extension = pickedFile.name.split(".").last;
      if (extension.trim().isEmpty) {
        extension = 'jpg';
      }

      return AttachmentFile(
        filename: pickedFile.name.split('.').first,
        extension: extension,
        data: await pickedFile.readAsBytes(),
        path: pickedFile.path,
      );
    } catch (e) {
      throw UnimplementedError(e.toString());
    }
  }
}
