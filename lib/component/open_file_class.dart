import 'dart:io';
import 'package:get/get.dart';
import 'package:task_management/view/widgets/image_screen.dart';
import 'package:task_management/view/widgets/pdf_screen.dart';

class OpenFileClass {
  void openFile(File file) {
    String fileExtension = file.path.split('.').last.toLowerCase();
    print('jshd8u8 3iu398y ${file}');
    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Get.to(() => ImageScreen(file: file));
    } else if (fileExtension == 'pdf') {
      Get.to(() => PDFScreen(file: file));
    } else if (['xls', 'xlsx', 'docs'].contains(fileExtension)) {
      Get.to(() => PDFScreen(file: file));
    } else {}
  }

  void openUrl(String file) {
    String fileExtension = file.split('.').last.toLowerCase();
    print('jshd8u8 3iu398y ${file}');
    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Get.to(() => NetworkImageScreen(file: file));
    } else if (fileExtension == 'pdf') {
      Get.to(() => NetworkPDFScreen(file: file));
    } else if (['xls', 'xlsx', 'docx'].contains(fileExtension)) {
      // Get.to(() => PDFScreen(file: file));
      // OpenFilex.open(file);
    } else {}
  }
}
