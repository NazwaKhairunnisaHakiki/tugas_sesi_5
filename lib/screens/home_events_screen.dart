import 'package:flutter/material.dart';

import '../data/sample_events.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';
import '../widgets/event_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/venue_map_viewer.dart';
import 'event_registration_screen.dart';
import 'registered_tickets_screen.dart';

class HomeEventsScreen extends StatefulWidget {
  const HomeEventsScreen({super.key});

  @override
  State<HomeEventsScreen> createState() => _HomeEventsScreenState();
}

class _HomeEventsScreenState extends State<HomeEventsScreen> {
  int _selectedIndex = 0;
  String _selectedCategory = 'Semua';

  final List<RegistrationTicket> _tickets = [];

  List<EventItem> get _filteredEvents {
    if (_selectedCategory == 'Semua') {
      return sampleEvents;
    }

    return sampleEvents
        .where((event) => event.category == _selectedCategory)
        .toList();
  }

  void _showFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterBottomSheet(
          selectedCategory: _selectedCategory,
          onCategorySelected: (category) {
            setState(() {
              _selectedCategory = category;
            });
          },
        );
      },
    );
  }

  Future<void> _openRegistration(EventItem event) async {
    final ticket = await Navigator.push<RegistrationTicket>(
      context,
      MaterialPageRoute(
        builder: (context) => EventRegistrationScreen(event: event),
      ),
    );

    if (ticket != null && mounted) {
      setState(() {
        _tickets.add(ticket);
        _selectedIndex = 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildSeminarPage(),
      _buildGalleryPage(),
      RegisteredTicketsScreen(tickets: _tickets),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NusaEvent Hub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              onPressed: _showFilter,
              icon: const Icon(Icons.filter_list),
            ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.event), label: 'Seminar'),
          NavigationDestination(
            icon: Icon(Icons.photo_library),
            label: 'Galeri',
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_number),
            label: 'Tiket',
          ),
        ],
      ),
    );
  }

  Widget _buildSeminarPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Temukan Acara Menarik!',
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text('Pilih seminar dan workshop favoritmu.'),
              Wrap(
                spacing: 8,
                children: [
                  Chip(label: Text(_selectedCategory)),
                  TextButton(
                    onPressed: _showFilter,
                    child: const Text('Ubah Filter'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredEvents.length,
            itemBuilder: (context, index) {
              final event = _filteredEvents[index];

              return EventCard(
                event: event,
                onTap: () => _openRegistration(event),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryPage() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Galeri Seminar',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: sampleEvents.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final event = sampleEvents[index];

            return Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.asset(
                      event.poster,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.deepPurple.shade50,
                          child: const Icon(
                            Icons.image,
                            size: 48,
                            color: Colors.deepPurple,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const VenueMapViewer(),
      ],
    );
  }
}
