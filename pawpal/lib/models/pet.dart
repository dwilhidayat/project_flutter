class Pet {
  String? submissionId;
  int?petId;
  String? petName;
  String? petType;
  String? category;
  String? description;
  String? latitude;
  String? longitude;
  String? imagePath;
  String? createdDate;
  

  Pet({
    this.submissionId,
    this.petId,
    this.petName,
    this.petType,
    this.category,
    this.description,
    this.latitude,
    this.longitude,
    this.imagePath,
    this.createdDate,
  });

  Pet.fromJson(Map<String, dynamic> json) {
    submissionId = json['submission_id'];
    petId = int.parse(json['pet_id'].toString());
    petName = json['pet_name'];
    petType = json['pet_type'];
    category = json['category'];
    description = json['description'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    imagePath = json['images'];
    createdDate = json['created_date'];
  }

  

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['submission_id'] = submissionId;
    data['pet_id'] = petId;
    data['pet_name'] = petName;
    data['pet_type'] = petType;
    data['category'] = category;
    data['description'] = description;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['images'] = imagePath;
    data['created_date'] = createdDate;
    return data;
  }
}
