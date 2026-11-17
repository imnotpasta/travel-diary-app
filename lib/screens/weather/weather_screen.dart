import 'package:flutter/material.dart';
import '../../models/weather_model.dart';
import '../../services/auth_service.dart';
import '../../services/weather_api_service.dart';

class WeatherScreen extends StatefulWidget {
  final String? prefilledCity;

  const WeatherScreen({super.key, this.prefilledCity});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherApiService _weatherApiService = WeatherApiService();
  final TextEditingController _cityController = TextEditingController();

  Future<WeatherModel>? _weatherFuture;
  String _currentQuery = 'Đà Lạt';
  bool _isPosting = false;

  final List<String> _popularCities = [
    'Đà Lạt',
    'Phú Quốc',
    'Sa Pa',
    'Đà Nẵng',
    'Hà Nội',
    'Nha Trang',
    'Hội An',
  ];

  @override
  void initState() {
    super.initState();
    final userCity = AuthService().currentUser?.homeCity;
    _currentQuery = widget.prefilledCity?.isNotEmpty == true
        ? widget.prefilledCity!
        : (userCity != null && userCity.isNotEmpty ? userCity : 'Đà Lạt');
    _cityController.text = _currentQuery;
    _fetchWeather();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void _fetchWeather() {
    setState(() {
      _currentQuery = _cityController.text.trim();
      _weatherFuture = _weatherApiService.fetchWeatherByCity(_currentQuery);
    });
  }

  Future<void> _sendHttpPostDemo() async {
    setState(() => _isPosting = true);
    try {
      final res = await _weatherApiService.postTripBackupToServer(
        tripTitle: 'Hành trình khám phá $_currentQuery',
        destination: _currentQuery,
        budget: 5000000.0,
        travelerEmail: 'traveler@vietnam.com',
      );

      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            icon: const Icon(Icons.cloud_done, color: Colors.green, size: 48),
            title: const Text('REST API POST Response (201 Created)'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    res['serverMessage'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  const Divider(height: 20),
                  const Text('Dữ liệu JSON giải mã qua jsonDecode():', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Name: ${res['data']['name']}\n'
                      'Job: ${res['data']['job']}\n'
                      'Budget: ${res['data']['budget']} VNĐ\n'
                      'ID cấp bởi server: ${res['data']['id']}\n'
                      'Created At: ${res['data']['createdAt']}',
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Đóng')),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi HTTP POST: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ô tìm kiếm thời tiết theo tên thành phố
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.teal),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _fetchWeather(),
                        decoration: const InputDecoration(
                          hintText: 'Nhập tên thành phố (Đà Lạt, Sa Pa...)...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward, color: Colors.teal),
                      onPressed: _fetchWeather,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Chips địa điểm gợi ý nhanh
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _popularCities.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final city = _popularCities[index];
                  final isSelected = _cityController.text.trim().toLowerCase() == city.toLowerCase();
                  return ChoiceChip(
                    label: Text(city),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        _cityController.text = city;
                        _fetchWeather();
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 18),

            // Yêu cầu Đề tài 10: Xử lý mượt mà các trạng thái ConnectionState trong FutureBuilder
            FutureBuilder<WeatherModel>(
              future: _weatherFuture,
              builder: (context, snapshot) {
                // Trạng thái 1: ConnectionState.none
                if (snapshot.connectionState == ConnectionState.none) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: Text('Vui lòng nhập tên địa điểm để tra cứu thời tiết.')),
                    ),
                  );
                }

                // Trạng thái 2: ConnectionState.waiting (Đang gửi HTTP GET request)
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(color: Colors.teal),
                          SizedBox(height: 16),
                          Text(
                            'Đang kết nối REST API Server...\nGiải mã JSON qua jsonDecode()',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Trạng thái 3: Gặp lỗi trong quá trình xử lý HTTP
                if (snapshot.hasError) {
                  return Card(
                    color: Colors.red.withValues(alpha: 0.08),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Icon(Icons.cloud_off, size: 48, color: Colors.redAccent),
                          const SizedBox(height: 12),
                          Text(
                            'Lỗi kết nối REST API: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: _fetchWeather,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Trạng thái 4: ConnectionState.done & có dữ liệu thành công
                if (snapshot.hasData) {
                  final weather = snapshot.data!;
                  return _buildWeatherResultCard(context, weather);
                }

                return const SizedBox();
              },
            ),

            const SizedBox(height: 20),

            // Demo HTTP POST Backend (ReqRes.in)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.teal.withValues(alpha: 0.3)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.http, color: Colors.teal, size: 28),
                        SizedBox(width: 8),
                        Text(
                          'HTTP POST Backend Demo',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Gửi dữ liệu hành trình du lịch lên Server Backend (https://reqres.in/api/users) bằng method POST và giải mã JSON phản hồi.',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _isPosting ? null : _sendHttpPostDemo,
                      icon: _isPosting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.send),
                      label: Text(_isPosting ? 'Đang gửi POST Request...' : 'Gửi HTTP POST Request'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherResultCard(BuildContext context, WeatherModel weather) {
    return Column(
      children: [
        // Thẻ Thời tiết chính
        Card(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
                  Theme.of(context).colorScheme.primary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weather.cityName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          weather.description,
                          style: const TextStyle(fontSize: 15, color: Colors.white70),
                        ),
                      ],
                    ),
                    Text(
                      '${weather.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.white24),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWeatherSubStat('Cảm giác', '${weather.feelsLike.toStringAsFixed(1)}°C', Icons.thermostat),
                    _buildWeatherSubStat('Độ ẩm', '${weather.humidity}%', Icons.water_drop),
                    _buildWeatherSubStat('Sức gió', '${weather.windSpeed.toStringAsFixed(1)} km/h', Icons.air),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Thẻ Gợi ý Trang Phục Du Lịch Thông Minh (Tiêu chí bắt buộc của đề bài)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.checkroom, color: Colors.orange, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gợi ý trang phục cho chuyến đi',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        weather.outfitSuggestion,
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherSubStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

