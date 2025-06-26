import 'package:camping_site/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/string_constants.dart';
import 'core/theme/app_theme.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.secondaryDark,
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
                      StringConstants.appTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),

                  Container(
                    width: size.width,
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Text(
                      StringConstants.appInitialScreenDescription,
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
                        context.goNamed(AppRoute.home.name);
                      },
                      child: Text(
                        StringConstants.appInitialScreenGoButton,
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                      ),
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
