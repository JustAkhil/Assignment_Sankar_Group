class UserModel {
  String email;
  String name;

  UserModel({required this.email, required this.name});
  factory UserModel.fromMap(Map<String,dynamic>data){
    return UserModel(
      email: data["email"],
      name: data["name"],
    );
  }
  Map<String,dynamic>toDoc(){
    return {
      "email":email,
      "name":name,
    };
  }
}
