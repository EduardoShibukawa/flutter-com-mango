import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          R.strings.surveys,
        ),
      ),
      body: Builder(
        builder: (context) {
          presenter.loadData();

          return StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        snapshot.error!.toString(),
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        onPressed: presenter.loadData,
                        child: Text(R.strings.reload),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      aspectRatio: 1,
                    ),
                    items: snapshot.data!
                        .map((viewModel) => SurveyItem(viewModel))
                        .toList(),
                  ),
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
