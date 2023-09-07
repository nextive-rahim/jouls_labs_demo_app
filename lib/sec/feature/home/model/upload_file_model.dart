class UploadedFileModel {
  int? id;
  String? fileUrl;
  int? uploadTime;
  String? userName;
  String? profileImage;
  String? email;

  UploadedFileModel({
    this.id,
    this.fileUrl,
    this.uploadTime,
    this.userName,
    this.profileImage,
    this.email,
  });
  UploadedFileModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    fileUrl = map['fileUrl'];
    uploadTime = map["uploadTime"];
    userName = map['userName'];
    profileImage = map['profileImage'];
    email = map["email"];
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'fileUrl': fileUrl,
      'uploadTime': uploadTime,
      'userName': userName,
      'profileImage': profileImage,
      'email': email,
    };
    return map;
  }
}
