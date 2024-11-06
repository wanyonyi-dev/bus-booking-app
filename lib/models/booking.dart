class Booking {
  final String id;
  final String busId;
  final String userId;
  final List<int> seats;
  final DateTime date;
  final double totalAmount;
  final String status;

  Booking({
    required this.id,
    required this.busId,
    required this.userId,
    required this.seats,
    required this.date,
    required this.totalAmount,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      busId: json['busId'],
      userId: json['userId'],
      seats: List<int>.from(json['seats']),
      date: DateTime.parse(json['date']),
      totalAmount: json['totalAmount'].toDouble(),
      status: json['status'],
    );
  }
}
