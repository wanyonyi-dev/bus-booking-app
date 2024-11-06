class Bus {
  final String id;
  final String name;
  final String departure;
  final String arrival;
  final double price;
  final int availableSeats;

  Bus({
    required this.id,
    required this.name,
    required this.departure,
    required this.arrival,
    required this.price,
    required this.availableSeats,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      name: json['name'],
      departure: json['departure'],
      arrival: json['arrival'],
      price: json['price'].toDouble(),
      availableSeats: json['availableSeats'],
    );
  }
}
