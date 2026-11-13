class WeatherModel {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final String condition;
  final String outfitSuggestion;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.condition,
    required this.outfitSuggestion,
  });

  factory WeatherModel.fromOpenMeteoJson(String cityName, Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>? ?? {};
    final temp = (current['temperature_2m'] as num?)?.toDouble() ?? 25.0;
    final feels = (current['apparent_temperature'] as num?)?.toDouble() ?? temp;
    final humid = (current['relative_humidity_2m'] as num?)?.toInt() ?? 65;
    final wind = (current['wind_speed_10m'] as num?)?.toDouble() ?? 10.0;
    final weatherCode = (current['weather_code'] as num?)?.toInt() ?? 0;

    final conditionData = _mapWeatherCode(weatherCode);

    return WeatherModel(
      cityName: cityName,
      temperature: temp,
      feelsLike: feels,
      humidity: humid,
      windSpeed: wind,
      description: conditionData['desc']!,
      icon: conditionData['icon']!,
      condition: conditionData['condition']!,
      outfitSuggestion: _generateOutfitSuggestion(temp, conditionData['condition']!),
    );
  }

  factory WeatherModel.fromOpenWeatherMapJson(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? 'Điểm đến';
    final main = json['main'] as Map<String, dynamic>? ?? {};
    final temp = (main['temp'] as num?)?.toDouble() ?? 25.0;
    final feels = (main['feels_like'] as num?)?.toDouble() ?? temp;
    final humid = (main['humidity'] as num?)?.toInt() ?? 60;
    final windData = json['wind'] as Map<String, dynamic>? ?? {};
    final wind = (windData['speed'] as num?)?.toDouble() ?? 5.0;
    
    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final firstWeather = weatherList.isNotEmpty ? weatherList[0] as Map<String, dynamic> : {};
    final desc = firstWeather['description'] as String? ?? 'Nhiều mây';
    final mainCondition = firstWeather['main'] as String? ?? 'Clouds';
    final icon = firstWeather['icon'] as String? ?? '02d';

    return WeatherModel(
      cityName: name,
      temperature: temp,
      feelsLike: feels,
      humidity: humid,
      windSpeed: wind,
      description: desc,
      icon: icon,
      condition: mainCondition,
      outfitSuggestion: _generateOutfitSuggestion(temp, mainCondition),
    );
  }

  static Map<String, String> _mapWeatherCode(int code) {
    if (code == 0) {
      return {'desc': 'Trời quang đãng, nắng đẹp', 'icon': '01d', 'condition': 'Clear'};
    } else if (code <= 3) {
      return {'desc': 'Có mây rải rác, mát mẻ', 'icon': '02d', 'condition': 'Clouds'};
    } else if (code <= 48) {
      return {'desc': 'Sương mù nhẹ', 'icon': '50d', 'condition': 'Fog'};
    } else if (code <= 67) {
      return {'desc': 'Có mưa rào / mưa nhỏ', 'icon': '10d', 'condition': 'Rain'};
    } else if (code <= 77) {
      return {'desc': 'Tuyết rơi nhẹ', 'icon': '13d', 'condition': 'Snow'};
    } else if (code <= 82) {
      return {'desc': 'Mưa dông cục bộ', 'icon': '09d', 'condition': 'Rain'};
    } else {
      return {'desc': 'Dông sét, mưa lớn', 'icon': '11d', 'condition': 'Thunderstorm'};
    }
  }

  static String _generateOutfitSuggestion(double temp, String condition) {
    final buffer = StringBuffer();
    if (temp >= 32) {
      buffer.write('Nắng nóng gay gắt: Khuyên dùng áo phông cotton mỏng nhẹ, quần đùi hoặc váy maxi, nón rộng vành, kính râm, kem chống nắng SPF50+.');
    } else if (temp >= 25) {
      buffer.write('Thời tiết lý tưởng: Áo thun thoáng khí, quần short hoặc jeans nhẹ, giày thể thao đi bộ thoải mái để chụp hình.');
    } else if (temp >= 18) {
      buffer.write('Trời se se lạnh: Nên phối áo khoác mỏng (cardigan, hoodie), quần dài, giày sneaker tiện di chuyển.');
    } else {
      buffer.write('Thời tiết khá lạnh: Chuẩn bị áo khoác dày / áo phao, khăn quàng, găng tay giữ ấm cơ thể.');
    }

    if (condition.toLowerCase().contains('rain') || condition.toLowerCase().contains('mưa')) {
      buffer.write(' Lưu ý: Mang theo ô (dù), áo mưa tiện lợi và bọc giày chống nước.');
    }
    return buffer.toString();
  }
}

