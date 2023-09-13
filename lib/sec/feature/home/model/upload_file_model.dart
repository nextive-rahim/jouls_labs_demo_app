class UploadedFileModel {
  int? id;
  String? fileName;
  String? fileUrl;
  int? createdAt;
  String? userName;
  String? profileImage;
  String? email;

  UploadedFileModel({
    this.id,
    this.fileName,
    this.fileUrl,
    this.createdAt,
    this.userName,
    this.profileImage,
    this.email,
  });
  UploadedFileModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    fileName = map['fileName'];
    fileUrl = map['fileUrl'];
    createdAt = map["createdAt"];
    userName = map['userName'];
    profileImage = map['profileImage'];
    email = map["email"];
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'createdAt': createdAt,
      'userName': userName,
      'profileImage': profileImage,
      'email': email,
    };
    return map;
  }
}
