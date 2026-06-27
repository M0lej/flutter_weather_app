import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/resources/global_resource.dart';
import 'package:weather_app/themes/extenstions/gradient_theme.dart';
import 'package:weather_app/utils/translations/translation.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool showError = false;
  late Timer t;

  @override
  void initState() {
    t = Timer(Duration(seconds: 30), () {
      setState(() {
        showError = true;
      });
      throw "Error: fetching data took more than expected";
    });
    super.initState();
  }

  @override
  void dispose() {
    t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Translation translation = GlobalResource.of(
      context,
    ).appTranslation.translations;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            colors:
                Theme.of(context).extension<GradientTheme>()?.colors ??
                <Color>[],
          ),
        ),
        child: Center(
          child: showError
              ? AutoSizeText(
                  translation.loadingError,
                  maxLines: 1,
                  minFontSize: 10,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 20),
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
