import 'package:flutter/material.dart';
import 'package:hse/core/companents/widgets/loader_widget.dart';
import 'package:hse/core/utils/UI_Helpers.dart';
import 'package:hse/core/utils/globals.dart';
import 'package:hse/viewmodels/bpm_models/risks_model.dart';
import 'package:hse/viewmodels/user_info.dart';
import 'package:provider/provider.dart';
import 'components/calendar.dart';
import 'components/registry.dart';
import 'package:hse/generated/l10n.dart';

class RisksManagementMobileView extends StatefulWidget {
  const RisksManagementMobileView({Key key}) : super(key: key);

  @override
  _RisksManagementMobileViewState createState() => _RisksManagementMobileViewState();
}

class _RisksManagementMobileViewState extends State<RisksManagementMobileView> {
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<RisksModel>(context);
    var userModel = Provider.of<UserInfoModel>(context);
    return FutureBuilder(
        future: model.getEntities(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return Scaffold(
              appBar: _appBar(model),
              body: LoaderWidget(),
            );
          }
          loading = false;
          return DefaultTabController(
              length: 2,
              child: Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  appBar: _appBar(model),
                  body: TabBarView(
                    children: [
                      RisksManagementRegistry(model, userModel),
                      RisksManagementCalendar(model),
                    ],
                  )));
        });
  }

  Widget _appBar(RisksModel model) {
    return AppBar(
      title: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            S.current.riskRegister,
            style: generalFontStyle.copyWith(fontSize: defaultFontSize + 5),
          )),
      actions: [
        IconButton(
          icon: Icon(
            Icons.add,
            size: 32,
          ),
          onPressed: () => model.createEntity().then((value) => setState((){})),
        )
      ],
      centerTitle: true,
      bottom: loading
          ? null
          : PreferredSize(
        child: Container(
          child: TabBar(
            indicatorColor: Colors.blue,
            unselectedLabelColor: Colors.black54,
            labelColor: appBlueColor,
            tabs: [
              Tab(text: S.current.registry),
              Tab(text: S.current.calendar),
            ],
          ),
          color: Colors.white,
        ),
        preferredSize: Size.fromHeight(45),
      ),
    );
  }
}