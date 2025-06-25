import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SizedBox(
          width: double.infinity,
          height: size.height,

          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/images/background.svg',
                    width: size.width,
                    height: size.height * 0.60,
                    fit: BoxFit.cover,
                  ),

                  Container(
                    width: size.width,
                    padding: EdgeInsets.only(top: 40, bottom: 10),
                    child: Text(
                      'Camp Crew',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),

                  Container(
                    width: size.width,
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Text(
                      'Ride together, camp under stars – your mobile community awaits!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),

                  SizedBox(height: size.height * 0.05),

                  SizedBox(
                    width: size.width * 0.5,
                    height: 60.0,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the campsite list screen
                        context.go('/');
                      },
                      child: Text("LET'S GO", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
