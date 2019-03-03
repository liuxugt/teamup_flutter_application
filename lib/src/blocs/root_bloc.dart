import 'dart:async';
import 'package:teamup_app/src/resources/repository.dart';
import 'package:teamup_app/src/ui/widgets/bloc_provider.dart';

class RootBloc implements BlocBase{
  bool _isSignedIn;
  final _repository = Repository();
  // Stream to handle boolean for signed in user
  StreamController<bool> _signedInController = StreamController<bool>.broadcast();
  Stream<bool> get isSignedInStream => _signedInController.stream;


  RootBloc(){
    _isSignedIn = false;
    init();
  }

  void init() async {
    _repository.getCurrentUser().then((user){
      _isSignedIn = (user?.uid == null)? false : true;
    });
  }


  @override
  void dispose() {
    _signedInController.close();
  }


}