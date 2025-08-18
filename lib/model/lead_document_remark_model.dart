class QuotationLeadRemarkModel {
  bool? status;
  String? message;
  List<RemarkData>? data;

  QuotationLeadRemarkModel({this.status, this.message, this.data});

  QuotationLeadRemarkModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RemarkData>[];
      json['data'].forEach((v) {
        data!.add(new RemarkData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RemarkData {
  int? id;
  int? userId;
  int? leadQuoId;
  String? remarks;
  String? createdAt;
  String? updatedAt;
  String? userName;

  RemarkData(
      {this.id,
      this.userId,
      this.leadQuoId,
      this.remarks,
      this.createdAt,
      this.updatedAt,
      this.userName});

  RemarkData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    leadQuoId = json['lead_quo_id'];
    remarks = json['remarks'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['lead_quo_id'] = this.leadQuoId;
    data['remarks'] = this.remarks;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_name'] = this.userName;
    return data;
  }
}
