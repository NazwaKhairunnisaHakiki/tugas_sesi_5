import 'package:flutter/material.dart';

import '../models/event_item.dart';
import '../models/registration_ticket.dart';

class EventRegistrationScreen extends StatefulWidget {
  final EventItem event;

  const EventRegistrationScreen({super.key, required this.event});

  @override
  State<EventRegistrationScreen> createState() =>
      _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _donationController = TextEditingController(text: '0');

  String _participantType = 'Mahasiswa';
  String _seminarKit = 'Standard';
  DateTime? _attendanceDate;
  bool _agreeRules = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    _donationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      helpText: 'Pilih tanggal kehadiran',
    );

    if (picked != null) {
      setState(() {
        _attendanceDate = picked;
      });
    }
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_attendanceDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih tanggal kehadiran.')),
      );
      return;
    }

    if (!_agreeRules) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamu harus menyetujui tata tertib.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final ticket = RegistrationTicket(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      event: widget.event,
      participantName: _nameController.text.trim(),
      nim: _nimController.text.trim(),
      email: _emailController.text.trim(),
      whatsapp: _whatsappController.text.trim(),
      participantType: _participantType,
      attendanceDate: _attendanceDate!,
      seminarKit: _seminarKit,
      donation: double.tryParse(_donationController.text) ?? 0,
      registeredAt: DateTime.now(),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    Navigator.pop(context, ticket);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pendaftaran berhasil! Tiket telah dibuat.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulir Pendaftaran')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              widget.event.title,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Harga tiket: Rp ${widget.event.price.toStringAsFixed(0)}'),
            const Divider(height: 32),

            const Text(
              'Data Peserta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildTextField(
              label: 'Nama Lengkap',
              controller: _nameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama wajib diisi';
                }
                if (value.trim().length < 3) {
                  return 'Nama minimal 3 karakter';
                }
                return null;
              },
            ),

            _buildTextField(
              label: 'NIM',
              controller: _nimController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'NIM wajib diisi';
                }
                if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
                  return 'NIM harus berupa angka';
                }
                return null;
              },
            ),

            _buildTextField(
              label: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email wajib diisi';
                }
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                    .hasMatch(value.trim())) {
                  return 'Format email tidak valid';
                }
                return null;
              },
            ),

            _buildTextField(
              label: 'Nomor WhatsApp',
              controller: _whatsappController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nomor WhatsApp wajib diisi';
                }
                if (!RegExp(r'^\+?\d{9,15}$').hasMatch(value.trim())) {
                  return 'Nomor WhatsApp tidak valid';
                }
                return null;
              },
            ),

            const Divider(height: 32),

            const Text(
              'Detail Kehadiran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: _participantType,
              decoration: const InputDecoration(
                labelText: 'Tipe Peserta',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Mahasiswa', child: Text('Mahasiswa')),
                DropdownMenuItem(value: 'Umum', child: Text('Umum')),
                DropdownMenuItem(value: 'Dosen', child: Text('Dosen')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _participantType = value;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: _selectDate,
              icon: const Icon(Icons.calendar_month),
              label: Text(
                _attendanceDate == null
                    ? 'Pilih Tanggal Kehadiran'
                    : '${_attendanceDate!.day}/${_attendanceDate!.month}/${_attendanceDate!.year}',
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _seminarKit,
              decoration: const InputDecoration(
                labelText: 'Paket Seminar Kit',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Standard', child: Text('Standard')),
                DropdownMenuItem(value: 'Premium', child: Text('Premium')),
                DropdownMenuItem(value: 'Tanpa Kit', child: Text('Tanpa Kit')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _seminarKit = value;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            _buildTextField(
              label: 'Donasi (Rp)',
              controller: _donationController,
              keyboardType: TextInputType.number,
              validator: (value) {
                final amount = double.tryParse(value ?? '');
                if (amount == null || amount < 0) {
                  return 'Masukkan donasi berupa angka minimal 0';
                }
                return null;
              },
            ),

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _agreeRules,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text(
                'Saya menyetujui tata tertib dan ketentuan seminar.',
              ),
              onChanged: (value) {
                setState(() {
                  _agreeRules = value ?? false;
                });
              },
            ),

            const SizedBox(height: 20),

            FilledButton(
              onPressed: _isLoading ? null : _submitRegistration,
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Daftar Sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}
