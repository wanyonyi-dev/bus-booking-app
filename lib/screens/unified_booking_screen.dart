import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

enum BookingStatus {
  upcoming(label: 'Upcoming', color: Colors.green),
  completed(label: 'Completed', color: Colors.blue),
  cancelled(label: 'Cancelled', color: Colors.red);

  final String label;
  final Color color;

  const BookingStatus({
    required this.label,
    required this.color,
  });
}

class BookingData {
  final String bookingId;
  final String from;
  final String to;
  final DateTime travelDate;
  final String departureTime;
  final String arrivalTime;
  final double amount;
  final int seatCount;
  final List<String> seatNumbers;
  final BookingStatus status;
  final String busOperator;
  final String busType;

  BookingData({
    required this.bookingId,
    required this.from,
    required this.to,
    required this.travelDate,
    required this.departureTime,
    required this.arrivalTime,
    required this.amount,
    required this.seatCount,
    required this.seatNumbers,
    required this.status,
    required this.busOperator,
    required this.busType,
  });
}

class UnifiedBookingScreen extends StatefulWidget {
  const UnifiedBookingScreen({Key? key}) : super(key: key);

  @override
  State<UnifiedBookingScreen> createState() => _UnifiedBookingScreenState();
}

class _UnifiedBookingScreenState extends State<UnifiedBookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Bookings',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(),
          indicatorWeight: 3,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadBookings,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildBookingList(BookingStatus.upcoming),
            _buildBookingList(BookingStatus.completed),
            _buildBookingList(BookingStatus.cancelled),
          ],
        ),
      ),
    );
  }

  List<BookingData> _getDummyBookings(BookingStatus status) {
    return List.generate(
      5,
          (index) => BookingData(
        bookingId: 'BK${1000 + index}',
        from: 'New York',
        to: 'Boston',
        travelDate: DateTime.now().add(Duration(days: status == BookingStatus.upcoming ? index + 1 : -index - 1)),
        departureTime: '08:00 AM',
        arrivalTime: '11:30 AM',
        amount: 45.0,
        seatCount: 2,
        seatNumbers: ['12A', '12B'],
        status: status,
        busOperator: 'Express Lines',
        busType: 'Luxury Coach',
      ),
    );
  }

  Widget _buildBookingList(BookingStatus status) {
    final bookings = _getDummyBookings(status);

    return bookings.isEmpty
        ? _buildEmptyState(status)
        : ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  Widget _buildEmptyState(BookingStatus status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            status == BookingStatus.upcoming
                ? Icons.calendar_today
                : status == BookingStatus.completed
                ? Icons.check_circle_outline
                : Icons.cancel_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No ${status.label} Bookings',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            status == BookingStatus.upcoming
                ? 'Book a bus ticket to get started!'
                : 'Your ${status.label.toLowerCase()} bookings will appear here',
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
            ),
          ),
          if (status == BookingStatus.upcoming) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
              icon: const Icon(Icons.search),
              label: Text(
                'Search Buses',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBookingCard(BookingData booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: booking.status.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    booking.status.label,
                    style: GoogleFonts.poppins(
                      color: booking.status.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Booking ID: ${booking.bookingId}',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.from,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        booking.departureTime,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward, color: Colors.grey),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        booking.to,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        booking.arrivalTime,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Divider(height: 1),
                const SizedBox(height: 16),
                _buildDetailRow('Travel Date',
                    DateFormat('MMM dd, yyyy').format(booking.travelDate)),
                _buildDetailRow('Bus Operator', booking.busOperator),
                _buildDetailRow('Bus Type', booking.busType),
                _buildDetailRow('Seats', booking.seatNumbers.join(', ')),
                _buildDetailRow('Amount Paid',
                    '\$${booking.amount.toStringAsFixed(2)}'),
                const SizedBox(height: 16),
                if (booking.status == BookingStatus.upcoming)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showCancelDialog(booking),
                          icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                          label: Text(
                            'Cancel Booking',
                            style: GoogleFonts.poppins(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _downloadTicket(booking),
                          icon: const Icon(Icons.download),
                          label: Text(
                            'Download',
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (booking.status == BookingStatus.completed)
                  ElevatedButton.icon(
                    onPressed: () => _showRatingDialog(booking),
                    icon: const Icon(Icons.star_outline),
                    label: Text(
                      'Rate Journey',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BookingData booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Text(
          'Are you sure you want to cancel booking ID: ${booking.bookingId}?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              // Handle cancellation logic here
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BookingData booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate Journey'),
        content: const Text('Please rate your journey from 1 to 5.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle rating logic here
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _downloadTicket(BookingData booking) {
    // Handle download logic here
  }

  void _showFilterDialog() {
    // Handle filter functionality here
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UnifiedBookingScreen(),
  ));
}
