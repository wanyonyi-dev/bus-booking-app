import '../../models/booking.dart';
import '../../models/bus.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BusesLoading extends BookingState {}

class BusesLoaded extends BookingState {
  final List<Bus> buses;

  BusesLoaded(this.buses);
}

class BusSelected extends BookingState {
  final Bus bus;

  BusSelected(this.bus);
}

class SeatsSelected extends BookingState {
  final List<int> seats;
  final Bus bus;

  SeatsSelected(this.seats, this.bus);
}

class BookingInProgress extends BookingState {}

class BookingSuccess extends BookingState {
  final Booking booking;
  final String ticketUrl;

  BookingSuccess(this.booking, this.ticketUrl);
}

class BookingError extends BookingState {
  final String message;

  BookingError(this.message);
}
