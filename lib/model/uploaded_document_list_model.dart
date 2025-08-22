class UploadedDocumentListModel {
  bool? status;
  String? message;
  List<UploadedDocumentData>? data;

  UploadedDocumentListModel({this.status, this.message, this.data});

  UploadedDocumentListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UploadedDocumentData>[];
      json['data'].forEach((v) {
        data!.add(new UploadedDocumentData.fromJson(v));
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

class UploadedDocumentData {
  dynamic id;
  dynamic documentType;
  dynamic approvedBy;
  dynamic fileName;
  dynamic status;
  dynamic mmIsRead;
  dynamic bhIsRead;
  dynamic cmoIsRead;
  dynamic ceoIsRead;
  dynamic fileUrl;
  dynamic uploadedAt;

  UploadedDocumentData(
      {this.id,
      this.documentType,
      this.approvedBy,
      this.fileName,
      this.status,
      this.mmIsRead,
      this.bhIsRead,
      this.cmoIsRead,
      this.ceoIsRead,
      this.fileUrl,
      this.uploadedAt});

  UploadedDocumentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    documentType = json['document_type'];
    approvedBy = json['approved_by'];
    fileName = json['file_name'];
    status = json['status'];
    mmIsRead = json['mm_is_read'];
    bhIsRead = json['bh_is_read'];
    cmoIsRead = json['cmo_is_read'];
    ceoIsRead = json['ceo_is_read'];
    fileUrl = json['file_url'];
    uploadedAt = json['uploaded_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['document_type'] = this.documentType;
    data['approved_by'] = this.approvedBy;
    data['file_name'] = this.fileName;
    data['status'] = this.status;
    data['mm_is_read'] = this.mmIsRead;
    data['bh_is_read'] = this.bhIsRead;
    data['cmo_is_read'] = this.cmoIsRead;
    data['ceo_is_read'] = this.ceoIsRead;
    data['file_url'] = this.fileUrl;
    data['uploaded_at'] = this.uploadedAt;
    return data;
  }
}
