import '../../models/bus.dart';

abstract class BookingEvent {}

class LoadBuses extends BookingEvent {
  final String from;
  final String to;
  final DateTime date;

  LoadBuses(this.from, this.to, this.date);
}

class SelectBus extends BookingEvent {
  final Bus bus;

  SelectBus(this.bus);
}

class SelectSeats extends BookingEvent {
  final List<int> seats;

  SelectSeats(this.seats);
}

class SubmitBooking extends BookingEvent {
  final Map<String, dynamic> passengerDetails;

  SubmitBooking(this.passengerDetails);
}