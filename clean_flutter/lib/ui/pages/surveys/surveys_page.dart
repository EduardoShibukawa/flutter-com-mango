import 'package:clean_flutter/ui/mixins/mixins.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage>
    with NavigationManager, SessionManager, RouteAware {
  @override
  Widget build(BuildContext context) {
    Get.find<RouteObserver>().subscribe(this, ModalRoute.of(context)!);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          R.strings.surveys,
        ),
      ),
      body: Builder(
        builder: (context) {
          widget.presenter.loadData();

          handleNavigation(widget.presenter.navigateToStream);
          handleSessionExpired(widget.presenter.isSessionExpiredStream);

          return StreamBuilder<List<SurveyViewModel>>(
            stream: widget.presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error!.toString(),
                  reload: widget.presenter.loadData,
                );
              } else if (snapshot.hasData) {
                return Provider(
                  create: (_) => widget.presenter,
                  child: SurveyItems(snapshot.data!),
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }

  @override
  void didPopNext() {
    widget.presenter.loadData();
    super.didPopNext();
  }

  @override
  void dispose() {
    Get.find<RouteObserver>().unsubscribe(this);
    super.dispose();
  }
}
