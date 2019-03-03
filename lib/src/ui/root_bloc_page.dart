import 'package:flutter/material.dart';
import 'package:teamup_app/src/blocs/root_bloc.dart';
import 'package:teamup_app/src/ui/widgets/bloc_provider.dart';


class RootBlocPage extends StatefulWidget {
  @override
  _RootBlocPageState createState() => _RootBlocPageState();
}

class _RootBlocPageState extends State<RootBlocPage> {
  @override
  Widget build(BuildContext context) {
    final RootBloc rootBloc = BlocProvider.of<RootBloc>(context);
    return StreamBuilder<bool>(
      stream: rootBloc.isSignedInStream,
      builder: (context, snapshot){
        if(snapshot.hasData){
          if(snapshot.data)
            return HomeBlocPage();
          return LoginSignupBlocPage();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
