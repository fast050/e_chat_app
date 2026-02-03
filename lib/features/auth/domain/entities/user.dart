class User {
  final String id;
  final String name;
  final String? imageURL;
  final String? phoneNumber;
  final String? email;

  const User({
    required this.id,
    required this.name,
    this.imageURL, 
    this.phoneNumber, 
    this.email,
  });

  @override
  String toString() {
    return "{ id : $id, name : $name, imageURL : $imageURL, phoneNumber : $phoneNumber}";
  }
}
