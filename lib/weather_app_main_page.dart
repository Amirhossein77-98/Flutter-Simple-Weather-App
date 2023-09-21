import 'dart:convert';
import 'dart:ui';
import 'package:weather_app/secrets.dart';
import 'weather_forcast_cards.dart';
import 'package:flutter/material.dart';
import 'additional_info_cards.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MyWeatherAppHomePage extends StatefulWidget {
  const MyWeatherAppHomePage({super.key});

  @override
  State<MyWeatherAppHomePage> createState() => _MyWeatherAppHomePageState();
}

class _MyWeatherAppHomePageState extends State<MyWeatherAppHomePage> {
  Future<Map<String, dynamic>> getCurrentWeatherData() async {
    try {
      const cityName = 'Bābol,IR';
      final response = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$appID'),
      );

      final data = jsonDecode(response.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error has occurred';
      }

      return data;
    } catch (e) {
      throw (e).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 32,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeatherData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;

          final currentWeatherData = data['list'][0];

          final currentTemp = currentWeatherData['main']['temp'] - 273.15;
          final currentWeather = currentWeatherData['weather'][0]['main'];
          final currentHumidity =
              currentWeatherData['main']['humidity'].toString();
          final currentWindSpeed =
              currentWeatherData['wind']['speed'].toString();
          final currentPressure =
              currentWeatherData['main']['pressure'].toString();

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  "${currentTemp.toStringAsFixed(2)}°C",
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Icon(
                                  currentWeather == 'Clouds' ||
                                          currentWeather == 'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 70,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  currentWeather,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Weather Forcast",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 9),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final timeData = data['list'][index + 1]['dt_txt'];
                        final time = DateTime.parse(timeData);
                        final iconData = data['list'][index + 1]['weather'][0]
                                        ['main'] ==
                                    'Clouds' ||
                                data['list'][index + 1]['weather'][0]['main'] ==
                                    'Rain'
                            ? Icons.cloud
                            : Icons.sunny;
                        final tempData =
                            (data['list'][index + 1]['main']['temp'] - 273.15)
                                .toStringAsFixed(2);

                        return WeatherForecastCard(
                          hour: DateFormat.Hm().format(time).toString(),
                          icon: iconData,
                          degree: tempData,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoCards(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currentHumidity,
                      ),
                      AdditionalInfoCards(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: currentWindSpeed,
                      ),
                      AdditionalInfoCards(
                        icon: Icons.beach_access,
                        label: "Pressure",
                        value: currentPressure,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
