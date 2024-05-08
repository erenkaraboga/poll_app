class ImageResponseModel {
  List<String>? imageUrls;

  ImageResponseModel({this.imageUrls});

  ImageResponseModel.fromJson(Map<String, dynamic> json) {
    imageUrls = json['imageUrls'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrls'] = this.imageUrls;
    return data;
  }
}