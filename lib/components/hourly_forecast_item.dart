import 'package:flutter/material.dart';

class HourlyForeCastItem extends StatelessWidget {

  final IconData icon;
  final String time;
  final String temperature;

  const HourlyForeCastItem({
    super.key,
    required this.icon,
    required this.time,
    required this.temperature,
    });

  @override
  Widget build(BuildContext context) {
    return   Card(
                      elevation: 10,
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
                        child: Column(
                          children: [
                            Text(time ,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold ,),maxLines: 1,overflow: TextOverflow.ellipsis,),
                            Icon(
                              icon,
                              color: icon == Icons.cloud ? Colors.white : Colors.orangeAccent,
                            ),
                            Text(temperature)
                                
                          ],
                        ),
                      ),
                    );
  }
}