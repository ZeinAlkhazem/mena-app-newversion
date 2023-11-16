class WeatherModel {
  int? id;
  String? title;
  String? weatherLargeIcon;
  String? weatherSmallIcon;
  int? weatherCodeMin;


  WeatherModel({
    this.id,
    this.title,
    this.weatherLargeIcon,
    this.weatherSmallIcon,
    this.weatherCodeMin,

  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
        id: json.containsKey("id") ? json['id'] : null,
        title: json.containsKey("title") ? json['title'] : null,
        weatherLargeIcon: json.containsKey("weatherLargeIcon") ? json['weatherLargeIcon'] : null,
        weatherSmallIcon: json.containsKey("weatherSmallIcon") ? json['weatherSmallIcon'] : null,
        weatherCodeMin: json.containsKey("weatherCodeMin") ? json['weatherCodeMin'] : null,
    );
  }
}