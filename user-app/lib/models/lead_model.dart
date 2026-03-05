class LeadModel {
  final String name;
  final String phone;
  final String email;
  final List<String> service;
  final String message;

  const LeadModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.service,
    required this.message,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'email': email,
    'service': service,
    'message': message,
  };
}
