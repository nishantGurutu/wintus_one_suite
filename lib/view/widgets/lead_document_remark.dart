import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/lead_controller.dart';

class LeadDocumentRemarkList extends StatefulWidget {
  final dynamic id;
  const LeadDocumentRemarkList({super.key, required this.id});

  @override
  State<LeadDocumentRemarkList> createState() => _LeadDocumentRemarkListState();
}

class _LeadDocumentRemarkListState extends State<LeadDocumentRemarkList> {
// storeLeadRemarkLoading
  final LeadController leadController = Get.find();
  @override
  void initState() {
    super.initState();
    leadController.storeLeadRemarkLoading(
      id: widget.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.all(
          Radius.circular(8.r),
        ),
      ),
      child: Obx(
        () => Column(
          children: [
            SizedBox(
              height: 5.h,
            ),
            Text(
              "Remark List",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5.h,
            ),
            Expanded(
              child: leadController.isLeadremarkLoading.value == true
                  ? Center(child: CircularProgressIndicator())
                  : leadController.remarkListData.isEmpty
                      ? Center(child: Text("No remark available"))
                      : ListView.builder(
                          itemCount: leadController.remarkListData.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 8.w),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  border: Border.all(color: borderColor),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.r),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 5.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${leadController.remarkListData[index].remarks ?? ""}',
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'Remark added by ${leadController.remarkListData[index].userName ?? ""}',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
