class UploadedFileModel {
  int? id;
  String? fileUrl;
  int? uploadTime;

  UploadedFileModel(
    this.id,
    this.fileUrl,
    this.uploadTime,
  );
  UploadedFileModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    fileUrl = map['fileUrl'];
    uploadTime = map["uploadTime"];
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'fileUrl': fileUrl,
      'uploadTime': uploadTime,
    };
    return map;
  }
}
