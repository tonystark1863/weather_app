import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {

  final IconData icon;
  final String label;
  final String value;

  
  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,

    });


  @override
  Widget build(BuildContext context) {
    return  Padding(
                    padding:const EdgeInsets.all(10),
                    child:  Column(
                      children:[
                        Icon(
                          icon,
                          color:const  Color.fromARGB(255, 116, 146, 199),
                          size: 32
                        ) ,
                        Text(
                          label,
                          style: const TextStyle(
                          fontSize: 16,
                          ),
                        ),
                        Text(
                          value,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                      ]
                    ),
                  );
  }
}