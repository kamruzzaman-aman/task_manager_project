class UserAuthModel {
    String email;
    String firstName;
    String lastName;
    String mobile;
    String photo;

    UserAuthModel({
        required this.email,
        required this.firstName,
        required this.lastName,
        required this.mobile,
        required this.photo,
    });

    factory UserAuthModel.fromJson(Map<String, dynamic> json) => UserAuthModel(
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobile: json["mobile"],
        photo: json["photo"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "photo": photo,
    };
}