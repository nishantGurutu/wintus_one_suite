import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/costom_select_attachment.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/priority_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/project_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/model/all_project_list_model.dart';
import 'package:task_management/model/priority_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/view/widgets/add_contact.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_timer.dart';
import 'package:task_management/view/widgets/department_list_widget.dart';
import 'package:task_management/view/widgets/image_screen.dart';
import 'package:task_management/view/widgets/pdf_screen.dart';
import 'package:task_management/view/widgets/responsible_person_list.dart';
import 'package:task_management/view/widgets/task_contact_list.dart' show TaskContactList;
import 'package:task_management/view/widgets/to_assign_user_list.dart';

class EditTask extends StatefulWidget {
  final RxList<PriorityData> priorityList;
  final RxList<CreatedByMe> allProjectDataList;
  final RxList<ResponsiblePersonData> responsiblePersonList;
  final dynamic newTaskListId;
  final TextEditingController taskNameController3;
  final TextEditingController remarkController3;
  final TextEditingController startDateController3;
  final TextEditingController dueDateController3;
  final TextEditingController dueTimeController3;
  final dynamic assignedTo;
  final dynamic reviewer;
  final dynamic priority;
  final dynamic attachment;
  const EditTask(
    this.priorityList,
    this.allProjectDataList,
    this.responsiblePersonList,
    this.newTaskListId,
    this.taskNameController3,
    this.remarkController3,
    this.startDateController3,
    this.dueDateController3,
    this.dueTimeController3,
    this.assignedTo,
    this.reviewer,
    this.priority,
    this.attachment, {
    super.key,
  });

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final TaskController taskController = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int selectedProjectId = 0;
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController dueTimeController = TextEditingController();
  final TextEditingController menuController = TextEditingController();
  final TextEditingController timeTextEditingController =
      TextEditingController();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final PriorityController priorityController = Get.find();
  final ProjectController projectController = Get.find();
  final ProfileController profileController = Get.find();
  final HomeController homeController = Get.find();
  RxList<String> assignUserList = <String>[].obs;
  RxList<String> reviewerUserList = <String>[].obs;
  @override
  void initState() {
    assignUserList.assignAll(widget.assignedTo.toString().split(','));
    reviewerUserList.assignAll(widget.reviewer.toString().split(','));
    if (reviewerUserList.isNotEmpty) {
      taskController.reviewerUserId.addAll(reviewerUserList);
    }
    if (assignUserList.isNotEmpty) {
      taskController.assignedUserId.addAll(assignUserList);
    }
    super.initState();
    updateData();
  }

  var isLoading = false.obs;
  void updateData() async {
    isLoading.value = true;
    for (int i = 0; i < priorityController.priorityList.length; i++) {
      if (widget.priority.toString() ==
          priorityController.priorityList[i].id.toString()) {
        priorityController.selectedPriorityData.value =
            priorityController.priorityList[i];
      }
    }
    isLoading.value = false;
  }

  @override
  void dispose() {
    super.dispose();
    taskController.profilePicPath.value = '';
    taskController.assignedUserId.clear();
    taskController.toAssignedPersonCheckBox.clear();
    taskController.reviewerUserId.clear();
    taskController.responsiblePersonSelectedCheckBox2.clear();
  }

  Future<void> takePhoto() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        String? filePath = result.files.single.path;

        if (filePath == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: File path is null')));
          return;
        }

        final File file = File(filePath);
        taskController.pickedFile.value = File(file.path);
        taskController.profilePicPath.value = file.path.toString();
        print(
          'selected file path from device is ${taskController.pickedFile.value}',
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No file selected.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error uploading file: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      width: double.infinity,
      height: 680.h,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Obx(
            () =>
                isLoading.value == true
                    ? Center(
                      child: CircularProgressIndicator(
                        color: primaryButtonColor,
                      ),
                    )
                    : ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 680.h),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Update Task',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              TaskCustomTextField(
                                controller: widget.taskNameController3,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                data: taskName,
                                hintText: taskName,
                                labelText: taskName,
                                index: 0,
                                focusedIndexNotifier: focusedIndexNotifier,
                              ),
                              SizedBox(height: 10.h),
                              TaskCustomTextField(
                                controller: widget.remarkController3,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                data: enterRemark,
                                hintText: enterRemark,
                                labelText: enterRemark,
                                index: 1,
                                maxLine: 3,
                                focusedIndexNotifier: focusedIndexNotifier,
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 161.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          selectProject,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 3.w),
                                        Obx(
                                          () => DropdownButtonHideUnderline(
                                            child: DropdownButton2<CreatedByMe>(
                                              isExpanded: true,
                                              items:
                                                  taskController
                                                      .allProjectDataList
                                                      .map((CreatedByMe item) {
                                                        return DropdownMenuItem<
                                                          CreatedByMe
                                                        >(
                                                          value: item,
                                                          child: Text(
                                                            item.name ?? "",
                                                            style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .none,
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  darkGreyColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 16.sp,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        );
                                                      })
                                                      .toList(),
                                              value:
                                                  taskController
                                                      .selectedAllProjectListData
                                                      .value,
                                              onChanged: (CreatedByMe? value) {
                                                taskController
                                                    .selectedAllProjectListData
                                                    .value = value;
                                              },
                                              buttonStyleData: ButtonStyleData(
                                                height: 47.h,
                                                width: double.infinity,
                                                padding: EdgeInsets.only(
                                                  left: 14.w,
                                                  right: 14.w,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        14.r,
                                                      ),
                                                  border: Border.all(
                                                    color: lightBorderColor,
                                                  ),
                                                  color: whiteColor,
                                                ),
                                              ),
                                              hint: Text(
                                                'Select Project'.tr,
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontFamily: 'Roboto',
                                                  color: darkGreyColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.sp,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              iconStyleData: IconStyleData(
                                                icon: Image.asset(
                                                  'assets/images/png/Vector 3.png',
                                                  color: secondaryColor,
                                                  height: 8.h,
                                                ),
                                                iconSize: 14.sp,
                                                iconEnabledColor:
                                                    lightGreyColor,
                                                iconDisabledColor:
                                                    lightGreyColor,
                                              ),
                                              dropdownStyleData: DropdownStyleData(
                                                maxHeight: 200.h,
                                                width: 161.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        14.r,
                                                      ),
                                                  color: whiteColor,
                                                  border: Border.all(
                                                    color: lightBorderColor,
                                                  ),
                                                ),
                                                offset: const Offset(0, 0),
                                                scrollbarTheme: ScrollbarThemeData(
                                                  radius: Radius.circular(40.r),
                                                  thickness:
                                                      WidgetStateProperty.all<
                                                        double
                                                      >(6),
                                                  thumbVisibility:
                                                      WidgetStateProperty.all<
                                                        bool
                                                      >(true),
                                                ),
                                              ),
                                              menuItemStyleData:
                                                  MenuItemStyleData(
                                                    height: 40.h,
                                                    padding: EdgeInsets.only(
                                                      left: 14.w,
                                                      right: 14.w,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 161.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          selectDepartment,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 3.w),
                                        SizedBox(
                                          width: 161.w,
                                          child: DepartmentList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder:
                                            (context) => Padding(
                                              padding: EdgeInsets.only(
                                                bottom:
                                                    MediaQuery.of(
                                                      context,
                                                    ).viewInsets.bottom,
                                              ),
                                              child: AddContactIntask(),
                                            ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: chatColor,
                                          size: 20.sp,
                                        ),
                                        SizedBox(width: 3.w),
                                        Text(
                                          'Add Contact',
                                          style: changeTextColor(
                                            heading7,
                                            chatColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 15.w),
                                  Obx(
                                    () =>
                                        taskController
                                                .addTaskContactList
                                                .isNotEmpty
                                            ? InkWell(
                                              onTap: () {
                                                Get.to(
                                                  () => TaskContactList(
                                                    taskController
                                                        .addTaskContactList,
                                                  ),
                                                );
                                              },
                                              child: SizedBox(
                                                width: 100.w,
                                                height: 30.h,
                                                child: Stack(
                                                  children: List.generate(
                                                    taskController
                                                                .addTaskContactList
                                                                .length >
                                                            3
                                                        ? 4
                                                        : taskController
                                                            .addTaskContactList
                                                            .length,
                                                    (index) {
                                                      if (index < 3) {
                                                        final contact =
                                                            taskController
                                                                .addTaskContactList[index];
                                                        final firstChar =
                                                            contact
                                                                    .name!
                                                                    .isNotEmpty
                                                                ? contact
                                                                    .name![0]
                                                                : '?';
                                                        final leftPosition =
                                                            index == 0
                                                                ? 0.0
                                                                : (index == 1
                                                                    ? 22.w
                                                                    : 44.w);
                                                        final bgColor =
                                                            index == 0
                                                                ? redColor
                                                                : index == 1
                                                                ? blueColor
                                                                : secondaryColor;

                                                        return Positioned(
                                                          left: leftPosition,
                                                          child: Container(
                                                            height: 30.h,
                                                            width: 30.w,
                                                            decoration: BoxDecoration(
                                                              color: bgColor,
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                    Radius.circular(
                                                                      15.r,
                                                                    ),
                                                                  ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                firstChar,
                                                                style:
                                                                    changeTextColor(
                                                                      heading9,
                                                                      whiteColor,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        final extraCount =
                                                            taskController
                                                                .addTaskContactList
                                                                .length -
                                                            3;
                                                        return Positioned(
                                                          left: 65.w,
                                                          child: Container(
                                                            height: 30.h,
                                                            width: 30.w,
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  primaryButtonColor,
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                    Radius.circular(
                                                                      15.r,
                                                                    ),
                                                                  ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                '+$extraCount',
                                                                style:
                                                                    changeTextColor(
                                                                      heading9,
                                                                      whiteColor,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            )
                                            : SizedBox(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Obx(
                                () => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            takePhoto();
                                          },
                                          child: Container(
                                            width: 115.w,
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(7.r),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                                vertical: 11.2.h,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Attachment",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: whiteColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5.w),
                                                  Image.asset(
                                                    'assets/images/png/attachment_rounded.png',
                                                    color: whiteColor,
                                                    height: 16.sp,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Badge(
                                          backgroundColor:
                                              secondaryPrimaryColor,
                                          isLabelVisible:
                                              assignUserList.isNotEmpty ||
                                              taskController
                                                  .assignedUserId
                                                  .isNotEmpty,
                                          label: Text(
                                            taskController
                                                    .assignedUserId
                                                    .isNotEmpty
                                                ? "${taskController.assignedUserId.length}"
                                                : "${assignUserList.length}",
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                builder:
                                                    (context) => Padding(
                                                      padding: EdgeInsets.only(
                                                        bottom:
                                                            MediaQuery.of(
                                                              context,
                                                            ).viewInsets.bottom,
                                                      ),
                                                      child: ToAssignUserList(
                                                        widget.assignedTo,
                                                      ),
                                                    ),
                                              );
                                            },
                                            child: Container(
                                              width: 100.w,
                                              decoration: BoxDecoration(
                                                color: secondaryColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(7.r),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 11.2.h,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Assigned To",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: whiteColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Badge(
                                          backgroundColor:
                                              secondaryPrimaryColor,
                                          isLabelVisible:
                                              reviewerUserList.isNotEmpty ||
                                              taskController
                                                  .reviewerUserId
                                                  .isNotEmpty,
                                          label: Text(
                                            taskController
                                                    .reviewerUserId
                                                    .isNotEmpty
                                                ? "${taskController.reviewerUserId.length}"
                                                : "${reviewerUserList.length}",
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder:
                                                    (context) => Padding(
                                                      padding: EdgeInsets.only(
                                                        bottom:
                                                            MediaQuery.of(
                                                              context,
                                                            ).viewInsets.bottom,
                                                      ),
                                                      child:
                                                          ResponsiblePersonList(
                                                            'reviewer',
                                                            widget.reviewer,
                                                          ),
                                                    ),
                                              );
                                            },
                                            child: Container(
                                              width: 95.w,
                                              decoration: BoxDecoration(
                                                color: blueColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(7.r),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 11.2.h,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Reviewer",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: whiteColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    (taskController
                                                .profilePicPath
                                                .value
                                                .isEmpty &&
                                            widget.attachment == null)
                                        ? SizedBox()
                                        : widget.attachment != null
                                        ? InkWell(
                                          onTap: () {
                                            networkOpenFile(
                                              taskController
                                                  .profilePicPath
                                                  .value,
                                            );
                                          },
                                          child: Container(
                                            height: 40.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: lightGreyColor,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.r),
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              child: Image.network(
                                                widget.attachment,
                                                fit: BoxFit.cover,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return Center(
                                                    child: Text(
                                                      "Invalid Image",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        )
                                        : InkWell(
                                          onTap: () {
                                            openFile(
                                              File(
                                                taskController
                                                    .profilePicPath
                                                    .value,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 40.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: lightGreyColor,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.r),
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              child: Image.file(
                                                File(
                                                  taskController
                                                      .profilePicPath
                                                      .value,
                                                ),
                                                fit: BoxFit.cover,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return Center(
                                                    child: Text(
                                                      "Invalid Image",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 161.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${startDate} *",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 3.w),
                                        CustomCalender(
                                          hintText: dateFormate,
                                          controller:
                                              widget.startDateController3,
                                          from: 'startDate',
                                          otherController: dueDateController,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 161.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${dueDate} *",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 3.w),
                                        CustomCalender(
                                          hintText: dateFormate,
                                          controller: widget.dueDateController3,
                                          from: 'dueDate',
                                          otherController: startDateController,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${dueTime} *",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      "${selectPriority} *",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3.w),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 43.h,
                                      child: CustomTimer(
                                        hintText: "",
                                        controller: widget.dueDateController3,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: SizedBox(
                                      height: 43.h,
                                      child: Obx(
                                        () => DropdownButtonHideUnderline(
                                          child: DropdownButton2<PriorityData>(
                                            isExpanded: true,
                                            items:
                                                priorityController.priorityList
                                                    .map((PriorityData item) {
                                                      return DropdownMenuItem<
                                                        PriorityData
                                                      >(
                                                        value: item,
                                                        child: Text(
                                                          item.priorityName ??
                                                              "",
                                                          style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            fontFamily:
                                                                'Roboto',
                                                            color:
                                                                darkGreyColor,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14.sp,
                                                          ),
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                        ),
                                                      );
                                                    })
                                                    .toList(),
                                            value:
                                                priorityController
                                                            .selectedPriorityData
                                                            .value ==
                                                        null
                                                    ? null
                                                    : priorityController
                                                        .selectedPriorityData
                                                        .value,
                                            onChanged: (
                                              PriorityData? value,
                                            ) async {
                                              priorityController
                                                  .selectedPriorityData
                                                  .value = value;
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              height: 30.h,
                                              width: double.infinity,
                                              padding: EdgeInsets.only(
                                                left: 14,
                                                right: 14,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: lightBorderColor,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(14.r),
                                                color: whiteColor,
                                              ),
                                            ),
                                            hint: Text(
                                              'Select Lead Type'.tr,
                                              style: TextStyle(
                                                decoration: TextDecoration.none,
                                                fontFamily: 'Roboto',
                                                color: darkGreyColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            iconStyleData: IconStyleData(
                                              icon: Image.asset(
                                                'assets/images/png/Vector 3.png',
                                                color: secondaryColor,
                                                height: 8.h,
                                              ),
                                              iconSize: 14,
                                              iconEnabledColor: lightGreyColor,
                                              iconDisabledColor: lightGreyColor,
                                            ),
                                            dropdownStyleData: DropdownStyleData(
                                              maxHeight: 200.h,
                                              width: 330.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                color: whiteColor,
                                                border: Border.all(
                                                  color: boxBorderColor,
                                                ),
                                              ),
                                              offset: const Offset(0, 0),
                                              scrollbarTheme:
                                                  ScrollbarThemeData(
                                                    radius:
                                                        const Radius.circular(
                                                          40,
                                                        ),
                                                    thickness:
                                                        WidgetStateProperty.all<
                                                          double
                                                        >(6),
                                                    thumbVisibility:
                                                        WidgetStateProperty.all<
                                                          bool
                                                        >(true),
                                                  ),
                                            ),
                                            menuItemStyleData:
                                                MenuItemStyleData(
                                                  height: 30.h,
                                                  padding: EdgeInsets.only(
                                                    left: 14,
                                                    right: 14,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 160.w,
                                    height: 43.h,
                                    child: CustomTextField(
                                      controller: timeTextEditingController,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      hintText: alarmReminder,
                                      keyboardType: TextInputType.number,
                                      prefixIcon: Icon(Icons.lock_clock),
                                      data: alarmReminder,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'^[0-9]*$'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 160.w,
                                    height: 44.h,
                                    child: Obx(
                                      () => DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          items:
                                              homeController.alarmTypeList.map((
                                                String item,
                                              ) {
                                                return DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: TextStyle(
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontFamily: 'Roboto',
                                                      color: darkGreyColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16.sp,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                );
                                              }).toList(),
                                          value:
                                              homeController
                                                      .selectedAlarmTypeTime!
                                                      .value
                                                      .isEmpty
                                                  ? null
                                                  : homeController
                                                      .selectedAlarmTypeTime
                                                      ?.value,
                                          onChanged: (String? value) {
                                            homeController
                                                .selectedAlarmTypeTime
                                                ?.value = value ?? '';
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            height: 50.h,
                                            width: double.infinity,
                                            padding: EdgeInsets.only(
                                              left: 14.w,
                                              right: 14.w,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14.r),
                                              border: Border.all(
                                                color: lightBorderColor,
                                              ),
                                              color: whiteColor,
                                            ),
                                          ),
                                          hint: Text(
                                            'Alarm type',
                                            style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: 'Roboto',
                                              color: darkGreyColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.sp,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          iconStyleData: IconStyleData(
                                            icon: Image.asset(
                                              'assets/images/png/Vector 3.png',
                                              color: secondaryColor,
                                              height: 8.h,
                                            ),
                                            iconSize: 14.sp,
                                            iconEnabledColor: lightGreyColor,
                                            iconDisabledColor: lightGreyColor,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 200.h,
                                            width: 160.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14.r),
                                              color: whiteColor,
                                              border: Border.all(
                                                color: lightBorderColor,
                                              ),
                                            ),
                                            offset: const Offset(0, 0),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness:
                                                  WidgetStateProperty.all<
                                                    double
                                                  >(6),
                                              thumbVisibility:
                                                  WidgetStateProperty.all<bool>(
                                                    true,
                                                  ),
                                            ),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                                height: 40,
                                                padding: EdgeInsets.only(
                                                  left: 14,
                                                  right: 14,
                                                ),
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              SizedBox(
                                height: 47.h,
                                child: Obx(
                                  () => DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      items:
                                          homeController.timeList.map((
                                            String item,
                                          ) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontFamily: 'Roboto',
                                                  color: darkGreyColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.sp,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          }).toList(),
                                      value:
                                          homeController
                                                  .selectedTime!
                                                  .value
                                                  .isEmpty
                                              ? null
                                              : homeController
                                                  .selectedTime
                                                  ?.value,
                                      onChanged: (String? value) {
                                        homeController.selectedTime?.value =
                                            value ?? '';
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 50.h,
                                        width: double.infinity,
                                        padding: EdgeInsets.only(
                                          left: 14.w,
                                          right: 14.w,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            14.r,
                                          ),
                                          border: Border.all(
                                            color: lightBorderColor,
                                          ),
                                          color: whiteColor,
                                        ),
                                      ),
                                      hint: Text(
                                        'Select type',
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontFamily: 'Roboto',
                                          color: darkGreyColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16.sp,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      iconStyleData: IconStyleData(
                                        icon: Image.asset(
                                          'assets/images/png/Vector 3.png',
                                          color: secondaryColor,
                                          height: 8.h,
                                        ),
                                        iconSize: 14.sp,
                                        iconEnabledColor: lightGreyColor,
                                        iconDisabledColor: lightGreyColor,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 200.h,
                                        width: 330.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            14.r,
                                          ),
                                          color: whiteColor,
                                          border: Border.all(
                                            color: lightBorderColor,
                                          ),
                                        ),
                                        offset: const Offset(0, 0),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness:
                                              WidgetStateProperty.all<double>(
                                                6,
                                              ),
                                          thumbVisibility:
                                              WidgetStateProperty.all<bool>(
                                                true,
                                              ),
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                            height: 40,
                                            padding: EdgeInsets.only(
                                              left: 14,
                                              right: 14,
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.h),
                              Obx(
                                () => CustomButton(
                                  onPressed: () {
                                    if (taskController.isTaskAdding.value ==
                                        false) {
                                      if (_formKey.currentState!.validate()) {
                                        taskController.editTask(
                                          widget.taskNameController3.text,
                                          widget.remarkController3.text,
                                          projectController
                                              .selectedAllProjectListData
                                              .value
                                              ?.id,
                                          profileController
                                              .selectedDepartMentListData
                                              .value
                                              ?.id,
                                          taskController.assignedUserId,
                                          taskController.reviewerUserId,
                                          widget.startDateController3.text,
                                          widget.dueDateController3.text,
                                          widget.dueTimeController3.text,
                                          priorityController
                                              .selectedPriorityData
                                              .value
                                              ?.id,
                                          widget.newTaskListId,
                                          timeTextEditingController.text,
                                          homeController.selectedTime?.value ??
                                              '',
                                          homeController
                                              .selectedAlarmTypeTime
                                              ?.value,
                                        );
                                      }
                                    }
                                  },
                                  text:
                                      taskController.isTaskEditing.value == true
                                          ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                color: whiteColor,
                                              ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                loading,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: whiteColor,
                                                ),
                                              ),
                                            ],
                                          )
                                          : Text(
                                            "Update",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: whiteColor,
                                            ),
                                          ),
                                  width: double.infinity,
                                  color: primaryColor,
                                  height: 45.h,
                                ),
                              ),
                              SizedBox(height: 6.h),
                            ],
                          ),
                        ),
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  void openFile(File file) {
    String fileExtension = file.path.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ImageScreen(file: file)),
      );
    } else if (fileExtension == 'pdf') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PDFScreen(file: file)),
      );
    } else if (['xls', 'xlsx'].contains(fileExtension)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excel file viewing not supported yet.')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unsupported file type.')));
    }
  }

  void networkOpenFile(String file) {
    String fileExtension = file.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NetworkImageScreen(file: file)),
      );
    } else if (fileExtension == 'pdf') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NetworkPDFScreen(file: file)),
      );
    } else if (['xls', 'xlsx'].contains(fileExtension)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excel file viewing not supported yet.')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unsupported file type.')));
    }
  }
}
