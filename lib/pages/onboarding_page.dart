import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teamup_app/models/onboarding_model.dart';
import 'package:teamup_app/widgets/onboarding/headline.dart';
import 'package:teamup_app/widgets/onboarding/personal_info.dart';
import 'package:teamup_app/widgets/onboarding/language_info.dart';
import 'package:teamup_app/widgets/onboarding/skill_info.dart';
import 'package:teamup_app/widgets/onboarding/stength_info.dart';
import 'package:teamup_app/widgets/onboarding/availability_info.dart';
import 'package:teamup_app/widgets/onboarding/icebreaker_info.dart';
import 'package:teamup_app/widgets/onboarding/profile_picture.dart';

class OnboardingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {

  final OnboardingModel onboardingModel = OnboardingModel();

  TabController _tabController;
  List<Widget> _tabs;

  @override
  void initState() {
    _tabs = [HeadlineTab(), PersonalInfoTab(), LanguageInfoTab(), SkillInfoTab(), StrengthInfoTab(),
    AvailabilityInfoTab(), IcebreakerInfoTab(), ProfilePictureTab()];
    _tabController = new TabController(length: _tabs.length, vsync: this);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return ScopedModel<OnboardingModel>(
      model: onboardingModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Onboarding"),
        ),
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              Flexible(
                child: TabBarView(
                  children: _tabs,
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: (_tabController.index > 0)
                            ? FlatButton(
                                child: Text("BACK"),
                                onPressed: () {
                                  _tabController.animateTo(
                                      _tabController.index - 1);
                                  setState(() {});
                                },
                              )
                            : FlatButton(
                                child: Text(""),
                                onPressed: () {
                                },
                             )),
                    TabPageSelector(
                      controller: _tabController,
                    ),
                    Container(
                        child: (_tabController.index ==
                            _tabController.length - 1)
                            ? FlatButton(
                                child: Text("FINISH"),
                                onPressed: () {
                                  onboardingModel.submitAttributes();
//                                  ScopedModel.of<OnboardingModel>(context,
//                                          rebuildOnChange: false)
//                                      .submitAttributes();
                                  Navigator.of(context).pop();
                                },
                              )
                            : FlatButton(
                                onPressed: () {
                                  _tabController.animateTo(
                                      _tabController.index + 1);
                                  setState(() {});
                                },
                                child: Text("NEXT"))),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
