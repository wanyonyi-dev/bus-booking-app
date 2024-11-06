import 'package:dio/dio.dart';

import 'booking.dart';
import 'bus.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://your-api-base-url.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  Future<List<Bus>> fetchBuses(String from, String to, DateTime date) async {
    try {
      final response = await _dio.get('/buses', queryParameters: {
        'from': from,
        'to': to,
        'date': date.toIso8601String(),
      });

      return (response.data as List)
          .map((json) => Bus.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch buses: $e');
    }
  }

  Future<Booking> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await _dio.post('/bookings', data: bookingData);
      return Booking.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  Future<String> generateTicket(String bookingId) async {
    try {
      final response = await _dio.get('/bookings/$bookingId/ticket');
      return response.data['ticketUrl'];
    } catch (e) {
      throw Exception('Failed to generate ticket: $e');
    }
  }
}
