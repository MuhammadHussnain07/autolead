import 'package:cloud_firestore/cloud_firestore.dart';

enum LeadStatus { newLead, contacted, done, cancelled }

extension LeadStatusExt on LeadStatus {
  String get displayName {
    switch (this) {
      case LeadStatus.newLead:
        return 'New';
      case LeadStatus.contacted:
        return 'Contacted';
      case LeadStatus.done:
        return 'Done';
      case LeadStatus.cancelled:
        return 'Cancelled';
    }
  }
}

LeadStatus _parseStatus(String s) {
  switch (s.toLowerCase()) {
    case 'contacted':
      return LeadStatus.contacted;
    case 'done':
      return LeadStatus.done;
    case 'cancelled':
      return LeadStatus.cancelled;
    default:
      return LeadStatus.newLead;
  }
}

class LeadModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String service;
  final String message;
  final LeadStatus status;
  final DateTime createdAt;

  const LeadModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.service,
    required this.message,
    required this.status,
    required this.createdAt,
  });

  static String _sanitize(dynamic value) {
    if (value == null) return '';
    String s = value.toString();
    if (s.startsWith('=')) {
      return s.substring(1).trim();
    }
    return s.trim();
  }

  factory LeadModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parsedDate = DateTime.now();

    // ✅ Handle n8n 'Date' field (String format)
    if (map['Date'] != null) {
      parsedDate = DateTime.tryParse(map['Date'].toString()) ?? DateTime.now();
    }
    // ✅ Handle Firestore Timestamp (if added manually)
    else if (map['createdAt'] != null && map['createdAt'] is Timestamp) {
      parsedDate = (map['createdAt'] as Timestamp).toDate();
    }

    return LeadModel(
      id: id,
      name: _sanitize(map['Name'] ?? map['name']),
      phone: _sanitize(map['Phone'] ?? map['phone']),
      email: _sanitize(map['Email'] ?? map['email']),
      service: _sanitize(map['Service'] ?? map['service']),
      message: _sanitize(map['Message'] ?? map['message']),
      status: _parseStatus(_sanitize(map['Status'] ?? map['status'] ?? 'new')),
      createdAt: parsedDate,
    );
  }

  Map<String, dynamic> toMap() => {
    'Name': name,
    'Phone': phone,
    'Email': email,
    'Service': service,
    'Message': message,
    'Status': status.displayName,
    'Date': FieldValue.serverTimestamp(),
  };

  LeadModel copyWith({LeadStatus? status}) => LeadModel(
    id: id,
    name: name,
    phone: phone,
    email: email,
    service: service,
    message: message,
    status: status ?? this.status,
    createdAt: createdAt,
  );
}
