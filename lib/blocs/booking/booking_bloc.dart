import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/api_service.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final ApiService _apiService;

  BookingBloc(this._apiService) : super(BookingInitial()) {
    on<LoadBuses>(_onLoadBuses);
    on<SelectBus>(_onSelectBus);
    on<SelectSeats>(_onSelectSeats);
    on<SubmitBooking>(_onSubmitBooking);
  }

  Future<void> _onLoadBuses(LoadBuses event, Emitter<BookingState> emit) async {
    emit(BusesLoading());
    try {
      final buses = await _apiService.fetchBuses(
        event.from,
        event.to,
        event.date,
      );
      emit(BusesLoaded(buses));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  void _onSelectBus(SelectBus event, Emitter<BookingState> emit) {
    emit(BusSelected(event.bus));
  }

  void _onSelectSeats(SelectSeats event, Emitter<BookingState> emit) {
    if (state is BusSelected) {
      emit(SeatsSelected(event.seats, (state as BusSelected).bus));
    }
  }

  Future<void> _onSubmitBooking(
      SubmitBooking event,
      Emitter<BookingState> emit,
      ) async {
    if (state is SeatsSelected) {
      final currentState = state as SeatsSelected;
      emit(BookingInProgress());

      try {
        final bookingData = {
          ...event.passengerDetails,
          'busId': currentState.bus.id,
          'seats': currentState.seats,
          'totalAmount': currentState.bus.price * currentState.seats.length,
        };

        final booking = await _apiService.createBooking(bookingData);
        final ticketUrl = await _apiService.generateTicket(booking.id);
        emit(BookingSuccess(booking, ticketUrl));
      } catch (e) {
        emit(BookingError(e.toString()));
      }
    }
  }
}
