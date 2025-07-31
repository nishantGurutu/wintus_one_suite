class StatusModel {
  bool? status;
  String? message;
  List<StatusData>? data;

  StatusModel({this.status, this.message, this.data});

  StatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StatusData>[];
      json['data'].forEach((v) {
        data!.add(new StatusData.fromJson(v));
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

class StatusData {
  int? id;
  String? statusName;
  int? status;
  String? createdAt;
  String? updatedAt;

  StatusData(
      {this.id, this.statusName, this.status, this.createdAt, this.updatedAt});

  StatusData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    statusName = json['status_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status_name'] = this.statusName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
