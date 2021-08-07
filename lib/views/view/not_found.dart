import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotFound extends StatelessWidget {
  const NotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                  mainAxisSize: MainAxisSize.min,
                  children: ['4', '0', '4']
                      .map((e) => Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(e,
                                style: GoogleFonts.zcoolQingKeHuangYou(
                                    fontSize: 78)),
                          ))
                      .toList()),
              const Text(
                'Sorry. Requested Flutree profile was not found in the database.',
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      )),
    );
  }
}
