import 'package:carousel_slider/carousel_slider.dart';
import 'package:clean_flutter/ui/components/components.dart';
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
                return ReloadScreen(
                  error: snapshot.error!.toString(),
                  reload: presenter.loadData,
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
