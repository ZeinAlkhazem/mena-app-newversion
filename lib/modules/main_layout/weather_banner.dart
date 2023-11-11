import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mena/core/functions/main_funcs.dart';

class PopupWidgetUpComing extends StatelessWidget {
  final String? data;

  PopupWidgetUpComing(this.data);
  var x;



  Future<Map<String, dynamic>> fetchWeatherData(String location) async {
    final apiKey = 'UNdeVStXE4TBU4BAXQeAve0Tb8ZAU8bG'; // Replace with your API key
    final apiUrl =
        'https://api.tomorrow.io/v4/weather/forecast?location=$location&timesteps=1d&apikey=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));
    var data =
        json.decode(response.body);
    log("# Data weather response : $data");
    ///temperatureAvg
    if (response.statusCode == 200) {
      return data ;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchWeatherData(data!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final Map<String, dynamic>? responseData = snapshot.data as Map<String, dynamic>?;

          if (responseData == null) {
            return Text('Error: No data available.');
          }

          final List<dynamic>? dailyData = responseData['timelines']['daily'];
          if (dailyData == null || dailyData.isEmpty) {
            return Text('Error: No daily data available.');
          }

          // Extracting relevant information
          String locationName = data!;
          String countryName = "Country"; // Replace with actual country name
          log("# location name : $locationName");
          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: 330,
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xffFFFFFF),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x29000000),
                      offset: Offset(0, 2),
                      blurRadius: 3,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Location icon and country name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: Color(0xff97A0A8),
                            size: 18,
                          ),
                        ),
                        Text(
                          '$locationName',
                          style: TextStyle(
                            color: Color(0xff97A0A8),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 5,bottom: 2),
                          width: 90.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow:  null),
                          child: Image.asset(
                            'assets/new_icons/large/png/11000_mostly_clear_large.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            '${dailyData[0]['values']["temperatureAvg"]}°',
                            style: TextStyle(
                              color: Color(0xff050505),
                              fontSize: 45.0,
                              // fontWeight: FontWeight.w600,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              'Mostly Clear',
                              style: TextStyle(
                                color: Color(0xff97A0A8),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            Text(
                              'feels like ${dailyData[0]['values']["temperatureApparentAvg"]}°',
                              style: TextStyle(
                                color: Color(0xff97A0A8),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Loop through all days in dailyData
                    for (var dayData in dailyData)
                      _buildDayInfo(dayData),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }


  Widget _buildDayInfo(dynamic dayData) {
    DateTime? date = DateTime.tryParse(dayData['time'] ?? '');
    if (date == null) {
      // Handle the case where the date is null
      return Container();
    }

    String dayName = DateFormat.EEEE().format(date); // Day name
    int dayNumber = date.day; // Day number

    Map<String, dynamic>? values = dayData['values'];
    if (values == null) {
      // Handle the case where values are null
      return Container();
    }
    log("# temperatureAvg :${values['temperatureAvg']} ");
    log("# temperatureMax :${values['temperatureMax']} ");
    log("# temperatureMin :${values['temperatureMin']} ");

    double temperatureAvg = values['temperatureAvg'].toDouble() ?? 0.0;
    double temperatureMax = values['temperatureMax'].toDouble() ?? 0.0;
    double temperatureMin = values['temperatureMin'].toDouble() ?? 0.0;
    double rainIntensityAvg = values['precipitationIntensity'] ?? 0.0;


    return Container(
      padding: EdgeInsets.only(right: 10,left: 10),
      child: Column(
        children: [
          SizedBox(height: 20),
          // Big icon with temperature and weather condition
          // SizedBox(height: 20),
          // Daily forecast for each day
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    '$dayName'.substring(0, 3),
                    style: TextStyle(
                      color: Color(0xff97A0A8),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  Text(
                    '$dayNumber',
                    style: TextStyle(
                      color: Color(0xff050505),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 18,right: 5),
                child: Image.asset(
                  'assets/new_icons/small/png/11000_mostly_clear_small.png',
                  fit: BoxFit.contain,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.umbrella,
                    color: Color(0xff97A0A8),
                  ),
                  Text(
                    '$rainIntensityAvg%',
                    style: TextStyle(
                      color: Color(0xff97A0A8),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    ' $temperatureMin° ',
                    style: TextStyle(
                      color: Color(0xff97A0A8),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  Text(
                    '$temperatureMax°',
                    style: TextStyle(
                      color: Color(0xff050505),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

}

class PopupWidgetAir extends StatelessWidget {
  final String? data;

  PopupWidgetAir(this.data);
  var x;



  Future<Map<String, dynamic>> fetchWeatherData(String location) async {
    final apiKey = 'UNdeVStXE4TBU4BAXQeAve0Tb8ZAU8bG'; // Replace with your API key
    final apiUrl =
        'https://api.tomorrow.io/v4/weather/forecast?location=$location&timesteps=1d&apikey=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));
    var data =
    json.decode(response.body);
    log("# Data weather response : $data");
    ///temperatureAvg
    if (response.statusCode == 200) {
      return data ;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchWeatherData(data!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final Map<String, dynamic>? responseData = snapshot.data as Map<String, dynamic>?;

          if (responseData == null) {
            return Text('Error: No data available.');
          }

          final List<dynamic>? dailyData = responseData['timelines']['daily'];

          if (dailyData == null || dailyData.isEmpty) {
            return Text('Error: No daily data available.');
          }

          // Extracting relevant information
          String locationName = data!;
          String countryName = "Country"; // Replace with actual country name
          log("# location name : $locationName");
          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: 330,
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xffFFFFFF),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x29000000),
                      offset: Offset(0, 2),
                      blurRadius: 3,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Location icon and country name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Now',
                                style: TextStyle(
                                  color: Color(0xff050505),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 60,top: 30),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: Color(0xff97A0A8),
                                  size: 18,
                                ),
                              ),
                              Text(
                                '$locationName, $countryName',
                                style: TextStyle(
                                  color: Color(0xff97A0A8),
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 5,bottom: 2),
                          width: 90.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow:  null),
                          child: Image.asset(
                            'assets/new_icons/large/png/11000_mostly_clear_large.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            '${dailyData[0]['values']["temperatureAvg"]}°',
                            style: TextStyle(
                              color: Color(0xff050505),
                              fontSize: 45.0,
                              // fontWeight: FontWeight.w600,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              'Mostly Clear',
                              style: TextStyle(
                                color: Color(0xff97A0A8),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            Text(
                              'feels like ${dailyData[0]['values']["temperatureApparentAvg"]}°',
                              style: TextStyle(
                                color: Color(0xff97A0A8),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(color: Color(0xff97A0A8),),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              'Air quality',
                              style: TextStyle(
                                color: Color(0xff050505),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            Text(
                              'Cool',
                              style: TextStyle(
                                color: Color(0xff97A0A8),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: MyWindSpeedProgressBar()
                            ),
                            Text(
                              "0  100  200  300  400  500",
                              style: TextStyle(
                              color: Color(0xff97A0A8),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Tajawal',
                            ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(color: Color(0xff97A0A8),),
                    // Loop through all days in dailyData
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

}
class MyWindSpeedProgressBar extends StatefulWidget {
  @override
  _MyWindSpeedProgressBarState createState() => _MyWindSpeedProgressBarState();
}

class _MyWindSpeedProgressBarState extends State<MyWindSpeedProgressBar> {
  double windSpeed = 0.0;
  double maxWindSpeed = 500.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LinearProgressIndicator(
          value: windSpeed / maxWindSpeed,
          minHeight: 20.0,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        SizedBox(height: 20.0),
        Text('Wind Speed: ${windSpeed.toStringAsFixed(2)}'),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            fetchData(); // Fetch data from the API
          },
          child: Text('Update Wind Speed'),
        ),
      ],
    );
  }

  Future<void> fetchData() async {
    final apiKey = 'UNdeVStXE4TBU4BAXQeAve0Tb8ZAU8bG'; // Replace with your Tomorrow.io API key
    final location = 'Erbil';

    final apiUrl =
        'https://api.tomorrow.io/v4/weather/realtime?location=$location&apikey=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newWindSpeed = data['data']['instant']['wind']['speed'].toDouble();

        setState(() {
          windSpeed = newWindSpeed * 100; // Convert to the desired scale
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}