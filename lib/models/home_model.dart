import 'package:scoped_model/scoped_model.dart';

class HomeModel extends Model{
  int _pageIndex = 0;


  changePage(int index){
    _pageIndex = index;
    notifyListeners();
  }

  int get pageIndex => _pageIndex;

}