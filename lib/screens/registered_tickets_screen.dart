import 'package:flutter/material.dart';

import '../models/registration_ticket.dart';

class RegisteredTicketsScreen extends StatefulWidget {
  final List<RegistrationTicket> tickets;

  const RegisteredTicketsScreen({super.key, required this.tickets});

  @override
  State<RegisteredTicketsScreen> createState() =>
      _RegisteredTicketsScreenState();
}

class _RegisteredTicketsScreenState extends State<RegisteredTicketsScreen> {
  Future<void> _confirmCancellation(RegistrationTicket ticket) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Batalkan Tiket?'),
          content: Text(
            'Apakah kamu yakin ingin membatalkan tiket '
            '${ticket.event.title}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Tidak'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Ya, Batalkan'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      setState(() {
        widget.tickets.removeWhere((item) => item.id == ticket.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tiket berhasil dibatalkan.')),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tickets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.confirmation_number_outlined,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              const Text(
                'Belum Ada Tiket',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tiket seminar yang kamu daftarkan '
                'akan muncul di sini.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.tickets.length,
      itemBuilder: (context, index) {
        final ticket = widget.tickets[index];

        return Dismissible(
          key: ValueKey(ticket.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            await _confirmCancellation(ticket);
            return false;
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Divider(height: 24),
                  Text('Nama: ${ticket.participantName}'),
                  Text('NIM: ${ticket.nim}'),
                  Text('Email: ${ticket.email}'),
                  Text('WhatsApp: ${ticket.whatsapp}'),
                  Text('Tipe peserta: ${ticket.participantType}'),
                  Text(
                    'Tanggal hadir: '
                    '${_formatDate(ticket.attendanceDate)}',
                  ),
                  Text('Seminar kit: ${ticket.seminarKit}'),
                  Text('Donasi: Rp ${ticket.donation.toStringAsFixed(0)}'),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _confirmCancellation(ticket),
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Batalkan Tiket',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
