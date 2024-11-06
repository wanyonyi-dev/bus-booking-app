import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// Models
class Bus {
  final String id;
  final String name;
  final String from;
  final String to;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final int totalSeats;
  final List<int> bookedSeats;
  final List<String> features;

  Bus({
    required this.id,
    required this.name,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.totalSeats,
    required this.bookedSeats,
    required this.features,
  });
}

class CartItem {
  final Bus bus;
  final List<int> selectedSeats;
  final DateTime travelDate;

  CartItem({
    required this.bus,
    required this.selectedSeats,
    required this.travelDate,
  });

  double get totalPrice => bus.price * selectedSeats.length;
}

// Search Bus Screen
class SearchBusScreen extends StatefulWidget {
  const SearchBusScreen({Key? key}) : super(key: key);

  @override
  State<SearchBusScreen> createState() => _SearchBusScreenState();
}

class _SearchBusScreenState extends State<SearchBusScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int _passengerCount = 1;

  final List<String> kenyanCounties = [
    'Nairobi', 'Mombasa', 'Kisumu', 'Nakuru', 'Eldoret',
    'Kakamega', 'Garissa', 'Lamu', 'Machakos', 'Meru',

    // Add more counties as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Bus',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return kenyanCounties.where((county) =>
                    county.toLowerCase().contains(textEditingValue.text.toLowerCase()));
              },
              onSelected: (String value) {
                _fromController.text = value;
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'From',
                    labelStyle: GoogleFonts.poppins(),
                    border: const OutlineInputBorder(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return kenyanCounties.where((county) =>
                    county.toLowerCase().contains(textEditingValue.text.toLowerCase()));
              },
              onSelected: (String value) {
                _toController.text = value;
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'To',
                    labelStyle: GoogleFonts.poppins(),
                    border: const OutlineInputBorder(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Travel Date',
                  labelStyle: GoogleFonts.poppins(),
                  border: const OutlineInputBorder(),
                ),
                child: Text(
                  DateFormat('MMM dd, yyyy').format(_selectedDate),
                  style: GoogleFonts.poppins(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Passengers',
                      labelStyle: GoogleFonts.poppins(),
                      border: const OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (_passengerCount > 1) {
                              setState(() {
                                _passengerCount--;
                              });
                            }
                          },
                        ),
                        Text(
                          _passengerCount.toString(),
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _passengerCount++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSearch,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Search Buses',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSearch() {
    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusSearchResultsScreen(
          from: _fromController.text,
          to: _toController.text,
          date: _selectedDate,
          passengers: _passengerCount,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }
}

// Bus Search Results Screen
class BusSearchResultsScreen extends StatelessWidget {
  final String from;
  final String to;
  final DateTime date;
  final int passengers;

  const BusSearchResultsScreen({
    Key? key,
    required this.from,
    required this.to,
    required this.date,
    required this.passengers,
  }) : super(key: key);

  List<Bus> _getDummyBuses() {
    return [
      Bus(
        id: '1',
        name: 'Easy Coach Express',
        from: from,
        to: to,
        departureTime: DateTime(date.year, date.month, date.day, 8, 0),
        arrivalTime: DateTime(date.year, date.month, date.day, 14, 0),
        price: 1500.0,
        totalSeats: 44,
        bookedSeats: [1, 4, 7, 12, 15, 22, 28, 35],
        features: ['AC', 'WiFi', 'USB Charging'],
      ),
      Bus(
        id: '2',
        name: 'Modern Coast',
        from: from,
        to: to,
        departureTime: DateTime(date.year, date.month, date.day, 10, 0),
        arrivalTime: DateTime(date.year, date.month, date.day, 16, 0),
        price: 1800.0,
        totalSeats: 44,
        bookedSeats: [2, 5, 8, 14, 18, 25, 30, 38],
        features: ['AC', 'WiFi', 'Refreshments'],
      ),
      // Add more dummy buses as needed
    ];
  }

  @override
  Widget build(BuildContext context) {
    final buses = _getDummyBuses();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Available Buses',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: buses.length,
        itemBuilder: (context, index) {
          return _buildBusCard(context, buses[index]);
        },
      ),
    );
  }

  Widget _buildBusCard(BuildContext context, Bus bus) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bus.name,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'KES ${bus.price.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeColumn(
                  'Departure',
                  DateFormat('hh:mm a').format(bus.departureTime),
                ),
                const Icon(Icons.arrow_forward, color: Colors.grey),
                _buildTimeColumn(
                  'Arrival',
                  DateFormat('hh:mm a').format(bus.arrivalTime),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: bus.features.map((feature) {
                IconData icon;
                switch (feature) {
                  case 'AC':
                    icon = Icons.ac_unit;
                    break;
                  case 'WiFi':
                    icon = Icons.wifi;
                    break;
                  case 'USB Charging':
                    icon = Icons.power;
                    break;
                  case 'Refreshments':
                    icon = Icons.fastfood;
                    break;
                  default:
                    icon = Icons.star;
                }
                return _buildFeatureChip(icon, feature);
              }).toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeatSelectionScreen(
                        bus: bus,
                        travelDate: date,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Select Seats',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeColumn(String label, String time) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 12),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}

// Seat Selection Screen
class SeatSelectionScreen extends StatefulWidget {
  final Bus bus;
  final DateTime travelDate;

  const SeatSelectionScreen({
    Key? key,
    required this.bus,
    required this.travelDate,
  }) : super(key: key);

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final Set<int> _selectedSeats = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Seats',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildBusInfo(),
                  const SizedBox(height: 24),
                  _buildSeatLegend(),
                  const SizedBox(height: 24),
                  _buildSeatGrid(),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }
  Widget _buildBusInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.bus.name,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.bus.from} → ${widget.bus.to}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${DateFormat('MMM dd, yyyy').format(widget.travelDate)}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            Text(
              'Time: ${DateFormat('hh:mm a').format(widget.bus.departureTime)}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(Colors.grey[300]!, 'Available'),
        _buildLegendItem(Colors.blue, 'Selected'),
        _buildLegendItem(Colors.red, 'Booked'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.poppins(),
        ),
      ],
    );
  }

  Widget _buildSeatGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: widget.bus.totalSeats,
      itemBuilder: (context, index) {
        final seatNumber = index + 1;
        final isBooked = widget.bus.bookedSeats.contains(seatNumber);
        final isSelected = _selectedSeats.contains(seatNumber);

        return GestureDetector(
          onTap: isBooked
              ? null
              : () {
            setState(() {
              if (isSelected) {
                _selectedSeats.remove(seatNumber);
              } else {
                _selectedSeats.add(seatNumber);
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isBooked
                  ? Colors.red
                  : isSelected
                  ? Colors.blue
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    seatNumber.toString(),
                    style: GoogleFonts.poppins(
                      color: isBooked || isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isBooked)
                  Center(
                    child: Icon(
                      Icons.close,
                      color: Colors.white.withOpacity(0.5),
                      size: 32,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    final totalAmount = _selectedSeats.length * widget.bus.price;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Selected: ${_selectedSeats.length} seats',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Total: KES ${totalAmount.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _selectedSeats.isEmpty
                ? null
                : () {
              final cartItem = CartItem(
                bus: widget.bus,
                selectedSeats: _selectedSeats.toList(),
                travelDate: widget.travelDate,
              );
              CartProvider.addToCart(cartItem);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            child: Text(
              'Add to Cart',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Cart Provider
class CartProvider {
  static final List<CartItem> _cart = [];

  static List<CartItem> get cart => _cart;

  static void addToCart(CartItem item) {
    _cart.add(item);
  }

  static void removeFromCart(CartItem item) {
    _cart.remove(item);
  }

  static void clearCart() {
    _cart.clear();
  }

  static double get total {
    return _cart.fold(0, (sum, item) => sum + item.totalPrice);
  }
}

// Cart Screen
class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          if (CartProvider.cart.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Clear Cart',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      'Are you sure you want to clear your cart?',
                      style: GoogleFonts.poppins(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          CartProvider.clearCart();
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Clear',
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: CartProvider.cart.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Book Tickets',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: CartProvider.cart.length,
              itemBuilder: (context, index) {
                final item = CartProvider.cart[index];
                return _buildCartItem(item);
              },
            ),
          ),
          _buildCheckoutBar(),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.bus.name,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    CartProvider.removeFromCart(item);
                    setState(() {});
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${item.bus.from} → ${item.bus.to}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${DateFormat('MMM dd, yyyy').format(item.travelDate)}',
              style: GoogleFonts.poppins(),
            ),
            Text(
              'Time: ${DateFormat('hh:mm a').format(item.bus.departureTime)}',
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 8),
            Text(
              'Selected Seats: ${item.selectedSeats.join(", ")}',
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 8),
            Text(
              'Amount: KES ${item.totalPrice.toStringAsFixed(0)}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total Amount',
                  style: GoogleFonts.poppins(),
                ),
                Text(
                  'KES ${CartProvider.total.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement checkout process
              // Navigate to payment screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Proceeding to checkout...'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            child: Text(
              'Checkout',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}