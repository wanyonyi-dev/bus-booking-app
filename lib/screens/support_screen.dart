import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Support',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildSupportOptions(context),
            _buildFAQSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.support_agent,
            size: 64,
            color: Colors.blue.shade700,
          ),
          const SizedBox(height: 16),
          Text(
            'How can we help you?',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Our support team is here to assist you',
            style: GoogleFonts.poppins(
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Us',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactCard(
            context,
            icon: Icons.phone,
            title: 'Call Support',
            subtitle: 'Available 24/7',
            onTap: () => _launchUrl('tel:+1234567890'),
          ),
          _buildContactCard(
            context,
            icon: Icons.email,
            title: 'Email Support',
            subtitle: 'Response within 24 hours',
            onTap: () => _launchUrl('mailto:support@busapp.com'),
          ),
          _buildContactCard(
            context,
            icon: Icons.chat,
            title: 'Live Chat',
            subtitle: 'Chat with our support team',
            onTap: () => _showLiveChatDialog(context),
          ),
          _buildContactCard(
            context,
            icon: FontAwesomeIcons.whatsapp, // Use FontAwesome WhatsApp icon
            title: 'WhatsApp Support',
            subtitle: 'Message us on WhatsApp',
            onTap: () => _launchUrl('https://wa.me/1234567890'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildFAQExpansionTile(
            'How do I cancel my booking?',
            'You can cancel your booking through the My Bookings section. '
                'Cancellation charges may apply based on the time of cancellation.',
          ),
          _buildFAQExpansionTile(
            'How can I get a refund?',
            'Refunds are automatically processed to the original payment method '
                'within 5-7 business days after cancellation.',
          ),
          _buildFAQExpansionTile(
            'Can I modify my booking?',
            'Yes, you can modify your booking up to 24 hours before departure. '
                'Additional charges may apply based on fare differences.',
          ),
          _buildFAQExpansionTile(
            'What is the luggage policy?',
            'Each passenger is allowed one piece of carry-on luggage and two pieces '
                'of check-in luggage. Additional baggage fees may apply.',
          ),
        ],
      ),
    );
  }

  Widget _buildFAQExpansionTile(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              content,
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _showLiveChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Start Live Chat',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Would you like to start a live chat with our support team?',
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
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement live chat functionality
            },
            child: Text(
              'Start Chat',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }
}
