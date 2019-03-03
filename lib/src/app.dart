import 'package:flutter/material.dart';
import 'package:teamup_app/src/blocs/root_bloc.dart';
import 'package:teamup_app/src/ui/root_bloc_page.dart';
import 'package:teamup_app/src/ui/widgets/bloc_provider.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeamUp',
      home: BlocProvider(
        bloc: RootBloc(),
        child: RootBlocPage(),
      )
    );

  }
}