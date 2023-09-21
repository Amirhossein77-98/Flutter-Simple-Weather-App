import 'package:flutter/material.dart';

class WeatherForecastCard extends StatelessWidget {
  final String hour;
  final IconData icon;
  final String degree;

  const WeatherForecastCard({
    super.key,
    required this.hour,
    required this.icon,
    required this.degree,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                hour,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                icon,
                size: 36,
              ),
              const SizedBox(height: 5),
              Text(degree),
            ],
          ),
        ),
      ),
    );
  }
}
