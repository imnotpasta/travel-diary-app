import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/trip.dart';
import '../../providers/trip_provider.dart';

class TripFormScreen extends StatefulWidget {
  final Trip? tripToEdit;

  const TripFormScreen({super.key, this.tripToEdit});

  @override
  State<TripFormScreen> createState() => _TripFormScreenState();
}

class _TripFormScreenState extends State<TripFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _destinationController;
  late TextEditingController _budgetController;
  late TextEditingController _itineraryController;
  late TextEditingController _coverImageController;

  late DateTime _selectedDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final t = widget.tripToEdit;
    _titleController = TextEditingController(text: t?.title ?? '');
    _destinationController = TextEditingController(text: t?.destination ?? '');
    _budgetController = TextEditingController(text: t != null ? t.budget.toStringAsFixed(0) : '');
    _itineraryController = TextEditingController(text: t?.itinerary ?? '');
    _coverImageController = TextEditingController(text: t?.coverImage ?? '');
    _selectedDate = t?.startDate ?? DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _destinationController.dispose();
    _budgetController.dispose();
    _itineraryController.dispose();
    _coverImageController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTrip() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final title = _titleController.text.trim();
      final destination = _destinationController.text.trim();
      final budget = double.tryParse(_budgetController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;
      final itinerary = _itineraryController.text.trim();
      final cover = _coverImageController.text.trim().isNotEmpty
          ? _coverImageController.text.trim()
          : 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&w=800&q=80';

      final provider = context.read<TripProvider>();

      if (widget.tripToEdit != null) {
        final updated = widget.tripToEdit!.copyWith(
          title: title,
          destination: destination,
          startDate: _selectedDate,
          budget: budget,
          itinerary: itinerary,
          coverImage: cover,
        );
        await provider.updateTrip(updated);
      } else {
        final newTrip = Trip(
          title: title,
          destination: destination,
          startDate: _selectedDate,
          budget: budget,
          itinerary: itinerary,
          coverImage: cover,
        );
        await provider.addTrip(newTrip);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.tripToEdit != null
                ? 'Đã cập nhật chuyến đi thành công!'
                : 'Đã thêm chuyến đi mới vào cơ sở dữ liệu Sqflite!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.tripToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Chỉnh sửa chuyến đi' : 'Tạo chuyến đi mới'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Tên chuyến đi
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tên chuyến đi *',
                  hintText: 'Ví dụ: Nghỉ dưỡng Đà Nẵng - Hội An',
                  prefixIcon: Icon(Icons.bookmark_outline),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Vui lòng nhập tên chuyến đi' : null,
              ),
              const SizedBox(height: 16),

              // 2. Địa điểm
              TextFormField(
                controller: _destinationController,
                decoration: const InputDecoration(
                  labelText: 'Địa điểm du lịch *',
                  hintText: 'Ví dụ: Đà Lạt, Lâm Đồng',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Vui lòng nhập địa điểm' : null,
              ),
              const SizedBox(height: 16),

              // 3. Ngày khởi hành
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.orange),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Ngày khởi hành', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 2),
                            Text(
                              DateFormat('dd/MM/yyyy').format(_selectedDate),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const Text('Chọn ngày', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 4. Chi phí dự trù
              TextFormField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Chi phí dự trù (VNĐ) *',
                  hintText: 'Ví dụ: 5000000',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Vui lòng nhập chi phí dự trù';
                  final numVal = double.tryParse(val.replaceAll(RegExp(r'[^0-9]'), ''));
                  if (numVal == null || numVal <= 0) return 'Chi phí phải là số dương hợp lệ';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 5. Ảnh bìa URL
              TextFormField(
                controller: _coverImageController,
                decoration: const InputDecoration(
                  labelText: 'URL ảnh bìa chuyến đi (Tùy chọn)',
                  hintText: 'https://images.unsplash.com/...',
                  prefixIcon: Icon(Icons.image_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // 6. Lịch trình chi tiết
              TextFormField(
                controller: _itineraryController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Lịch trình chi tiết *',
                  hintText: 'Nhập các hoạt động theo ngày:\n- Ngày 1: Check-in, dạo phố cổ...\n- Ngày 2: Tour lặn biển ngắm san hô...\n- Ngày 3: Thưởng thức ẩm thực địa phương...',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 80),
                    child: Icon(Icons.list_alt_outlined),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Vui lòng nhập lịch trình chi tiết' : null,
              ),
              const SizedBox(height: 28),

              // Nút Lưu chuyến đi
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveTrip,
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  _isSaving
                      ? 'Đang lưu vào SQLite...'
                      : (isEditing ? 'Cập nhật chuyến đi' : 'Lưu chuyến đi vào Sổ tay'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

