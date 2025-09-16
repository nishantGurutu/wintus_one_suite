import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/customExpensetextfiel.dart';
import 'package:task_management/view/widgets/add_item.dart';
import 'package:task_management/view/widgets/custom_calender.dart';

class CreateQuotationScreen extends StatefulWidget {
  final dynamic leadId;
  final String? leadNumber;
  const CreateQuotationScreen(
      {super.key, required this.leadId, this.leadNumber});

  @override
  State<CreateQuotationScreen> createState() => _CreateQuotationScreenState();
}

class _CreateQuotationScreenState extends State<CreateQuotationScreen> {
  final TextEditingController leadTextController = TextEditingController();
  final TextEditingController transactionDateController =
      TextEditingController();
  final TextEditingController validTillController = TextEditingController();
  final TextEditingController quotationTypeController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController securityPriceController = TextEditingController();
  final TextEditingController advanceMonthController = TextEditingController();
  final LeadController leadController = Get.put(LeadController());

  final Color backgroundColor = Colors.grey.shade100;
  final Color whiteColor = Colors.white;
  final Color textColor = Colors.black;
  final Color secondaryColor = Colors.blue;
  final Color lightBorderColor = Colors.grey;
  final Color darkGreyColor = Colors.grey.shade600;
  final Color lightGreyColor = Colors.grey.shade400;
  final Color primaryButtonColor = Colors.blue;
  final TextStyle rubikRegular = const TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );

  @override
  void initState() {
    leadController.selectedQuotation.value = '';
    leadTextController.text = widget.leadNumber ?? '';
    print("lead data in all lead ${widget.leadId}");
    print("lead data in all lead ${widget.leadNumber}");
    leadController.items.clear();
    Future.microtask(() {
      leadController.productListApi();
    });
    super.initState();
  }

  @override
  void dispose() {
    leadTextController.dispose();
    transactionDateController.dispose();
    validTillController.dispose();
    quotationTypeController.dispose();
    rateController.dispose();
    securityPriceController.dispose();
    advanceMonthController.dispose();
    leadController.items.clear();
    super.dispose();
  }
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Add Quotation",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text(
                  'Lead Id',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5.h),
                CustomExpanseTextField(
                  controller: leadTextController,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  data: 'Lead',
                  hintText: 'Lead',
                  enable: true,
                  readOnly: true,
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transaction Date',
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 5.h),
                          CustomCalender(
                            hintText: 'Transaction Date',
                            controller: transactionDateController,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Valid Till',
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 5.h),
                          CustomCalender(
                            hintText: 'Valid Till',
                            controller: validTillController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quotation Type',
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 5.h),
                          Obx(
                            () => DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                items: leadController.quotationType
                                    .map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: 'Roboto',
                                        color: darkGreyColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                value:
                                    leadController.selectedQuotation.value.isEmpty
                                        ? null
                                        : leadController.selectedQuotation.value,
                                onChanged: (String? value) {
                                  leadController.selectedQuotation.value =
                                      value ?? '';
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.only(left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    border: Border.all(color: lightBorderColor),
                                    color: whiteColor,
                                  ),
                                ),
                                hint: Text(
                                  'Select quotation type',
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontFamily: 'Roboto',
                                    color: darkGreyColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                iconStyleData: IconStyleData(
                                  icon: Image.asset(
                                    'assets/images/png/Vector 3.png',
                                    color: lightBorderColor,
                                    height: 8.h,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: lightGreyColor,
                                  iconDisabledColor: lightGreyColor,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  width: 165.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: whiteColor,
                                    border: Border.all(color: lightBorderColor),
                                  ),
                                  offset: const Offset(0, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness: WidgetStateProperty.all<double>(6),
                                    thumbVisibility:
                                        WidgetStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rate/Mtr/Pcs',
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 5.h),
                          CustomExpanseTextField(
                            controller: rateController,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.number,
                            data: 'Rate/Mtr/Pcs',
                            hintText: 'Rate/Mtr/Pcs',
                            enable: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Advance Month',
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 5.h),
                          CustomExpanseTextField(
                            controller: advanceMonthController,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.number,
                            data: 'Advance Month',
                            hintText: 'Advance Month',
                            enable: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Security Price',
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 5.h),
                          CustomExpanseTextField(
                            controller: securityPriceController,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.number,
                            data: 'Security Price',
                            hintText: 'Security Price',
                            enable: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Container(
                  height: 40.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(8.r)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Add Items",
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w400),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: AddItemShet(rate: rateController.text),
                              ),
                            );
                          },
                          child: Container(
                            height: 30.h,
                            width: 30.w,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.r)),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Container(
                  color: whiteColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Name',
                              style: TextStyle(fontSize: 13.sp, color: textColor),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Qty',
                              style: TextStyle(fontSize: 13.sp, color: textColor),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Rate',
                              style: TextStyle(fontSize: 13.sp, color: textColor),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Action',
                              style: TextStyle(fontSize: 13.sp, color: textColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => leadController.items.isEmpty
                        ? const Center(child: Text("No items added"))
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: leadController.items.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.h),
                                child: Container(
                                  color: whiteColor,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.h),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              '${leadController.items[index].productName ?? ''}',
                                              style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: textColor),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  decrementQuantity(index);
                                                },
                                                child: Container(
                                                  height: 20.h,
                                                  width: 20.w,
                                                  decoration: BoxDecoration(
                                                    color: backgroundColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10.r),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5.0),
                                                    child: SvgPicture.asset(
                                                      'assets/image/svg/minus_icon.svg',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 5.w),
                                              Text(
                                                '${leadController.items[index].quantity ?? ''}',
                                                style: TextStyle(
                                                    fontSize: 13.sp,
                                                    color: textColor),
                                              ),
                                              SizedBox(width: 5.w),
                                              GestureDetector(
                                                onTap: () {
                                                  incrementQuantity(index);
                                                },
                                                child: Container(
                                                  height: 20.h,
                                                  width: 20.w,
                                                  decoration: BoxDecoration(
                                                    color: backgroundColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10.r),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5.0),
                                                    child: SvgPicture.asset(
                                                      'assets/image/svg/add_icon.svg',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              '${leadController.items[index].rate ?? ''}',
                                              style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: textColor),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () {
                                                leadController.items
                                                    .removeAt(index);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                CustomButton(
                  text: Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: whiteColor,
                    ),
                  ),
                  onPressed: () {
                    if (leadController.isQuotationAdding.value == false) {
                      int advanceValue =
                          int.tryParse(advanceMonthController.text) ?? 0;
                      int securityValue =
                          int.tryParse(securityPriceController.text) ?? 0;
                          if(_formKey.currentState!.validate()){
                            if(transactionDateController.text.isNotEmpty && validTillController.text.isNotEmpty){
                            if(leadController.selectedQuotation.value.isNotEmpty){
                          if(leadController.items.isNotEmpty){
                      leadController.addQuotationApi(
                        leadId: widget.leadId,
                        lead: leadTextController.text,
                        transaction: transactionDateController.text,
                        valid: validTillController.text,
                        type: leadController.selectedQuotation.value,
                        rate: rateController.text,
                        advance: advanceValue,
                        security: securityValue,
                      );
                          }else{
                            CustomToast().showCustomToast("Please add at least one item");
                          }
                       }else{
                        CustomToast().showCustomToast("Please select quotation type");}
                          }
                          }else{
                            CustomToast().showCustomToast("Please select transaction and valid date");
                          }
                    }
                  },
                  color: primaryButtonColor,
                  width: double.infinity,
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void incrementQuantity(int index) {
    if (index >= 0 && index < leadController.items.length) {
      leadController.items[index].quantity =
          int.parse(leadController.items[index].quantity.toString()) + 1;
      leadController.items.refresh();
    }
  }

  void decrementQuantity(int index) {
    if (index >= 0 &&
        index < leadController.items.length &&
        (leadController.items[index].quantity ?? 0) > 1) {
      leadController.items[index].quantity =
          (leadController.items[index].quantity ?? 0) - 1;
      leadController.items.refresh();
    }
  }
}
