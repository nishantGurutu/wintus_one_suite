import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/lead_controller.dart';

class LeadOverviewDocumentListBotomsheet extends StatefulWidget {
  final dynamic leadId;
  final dynamic quotationId;
  const LeadOverviewDocumentListBotomsheet(
      {super.key, required this.leadId, this.quotationId});

  @override
  State<LeadOverviewDocumentListBotomsheet> createState() =>
      _LeadOverviewDocumentListBotomsheet();
}

class _LeadOverviewDocumentListBotomsheet
    extends State<LeadOverviewDocumentListBotomsheet> {
  final LeadController leadController = Get.find();

  @override
  void initState() {
    leadController.documentType();

    leadController.leadpickedFile.value = File("");
    leadController.profilePicPath.value = "";
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    leadController.isDocumentCheckBoxSelected.clear();
    leadController.leadpickedFile.value = File("");
    leadController.profilePicPath.value = "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 620.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SafeArea(
          child: Obx(
            () => leadController.isDocumentTypeLoading.value == true
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Document List",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: textColor),
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: SizedBox(
                              width: 25.w,
                              height: 35.h,
                              child: SvgPicture.asset(
                                  'assets/images/svg/cancel.svg'),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: leadController.documentTypeListData.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${index + 1}. ${leadController.documentTypeListData[index].name ?? ''}",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                          width: 40.w,
                                          height: 30.h,
                                          child: Icon(
                                            Icons.download,
                                            size: 30.sp,
                                          )),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        width: 40.w,
                                        height: 30.h,
                                        child: Icon(
                                          Icons.preview,
                                          size: 30.sp,
                                        ),
                                      ),
                                    ),
                                    Obx(
                                      () => Checkbox(
                                        value: leadController
                                            .isDocumentCheckBoxSelected[index],
                                        onChanged: (value) {
                                          leadController
                                                  .isDocumentCheckBoxSelected[
                                              index] = value!;
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      // if (widget.from == "quotation")
                      //   CustomButton(
                      //     onPressed: () {
                      //       if (leadController.isDocumentUploading.value ==
                      //           false) {
                      //         leadController.documentUploading(
                      //           documentId: leadController.documentIdList,
                      //           ducument: leadController.documentUplodedList,
                      //           leadId: widget.leadId,
                      //           quotationId: widget.quotationId,
                      //         );
                      //       }
                      //     },
                      //     text: Text(
                      //       'Submit',
                      //       style: changeTextColor(rubikBlack, whiteColor),
                      //     ),
                      //     color: primaryColor,
                      //     height: 45.h,
                      //     width: double.infinity,
                      //   ),
                      // if (widget.from == "quotation")
                      //   SizedBox(
                      //     height: 10.h,
                      //   ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> takeDocument({int? documentId}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        String? filePath = result.files.single.path;

        if (filePath == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: File path is null')),
          );
          return;
        }

        final File file = File(filePath);
        leadController.leadpickedFile.value = File(file.path);
        leadController.profilePicPath.value = file.path.toString();
        leadController.documentIdList.add(documentId ?? 0);
        leadController.documentUplodedList
            .add(leadController.leadpickedFile.value);
        print(
            'selected file path from device is ${leadController.leadpickedFile.value}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No file selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }
}
