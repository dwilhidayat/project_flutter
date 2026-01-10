
class Donation {
  int? donationId;
  int? userId;
  int? petId;
  String?petName;
  String? donationType;
  String? amount;
  String? description;
  String? createdAt;

  Donation({
    this.donationId,
    this.userId,
    this.petId,
    this.petName,
    this.donationType,
    this.amount,
    this.description,
    this.createdAt,
  });

  Donation.fromJson(Map<String, dynamic> json) {
    donationId = int.parse(json['donation_id'].toString());
    userId = int.parse(json['user_id'].toString());
    petId = int.parse(json['pet_id'].toString());
    petName = json['pet_name'];
    donationType = json['donation_type'];
    amount = json['amount'];
    description = json['description'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['donation_id'] = donationId;
    data['user_id'] = userId;
    data['pet_id'] = petId;
    data['pet_name'] = petName;
    data['donation_type'] = donationType;
    data['amount'] = amount;
    data['description'] = description;
    data['created_at'] = createdAt;
    return data;
  }
}
