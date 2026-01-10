class User {
  String? userId;
  String? userName;
  String? userEmail;
  String? userPassword;
  String? userPhone;
  String? userRegdate;
  String? userAddress;
  String? userLatitude;
  String? userLongitude;

  User(
      {this.userId,
      this.userName,
      this.userEmail,
      this.userPassword,
      this.userPhone,
      this.userRegdate,
      this.userAddress,
      this.userLatitude,
      this.userLongitude,
      });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userPassword = json['user_password'];
    userPhone = json['user_phone'];
    userRegdate = json['user_regdate'];
    userAddress = json['user_address'];
    userLatitude = json['user_latitude'];
    userLongitude = json['user_longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['user_email'] = userEmail;
    data['user_password'] = userPassword;
    data['user_phone'] = userPhone;
    data['user_regdate'] = userRegdate;
    data['user_address'] = userAddress;
    data['user_latitude'] = userLatitude;
    data['user_longitude'] = userLongitude;
    return data;
  }
}
