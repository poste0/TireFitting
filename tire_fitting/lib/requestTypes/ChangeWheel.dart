import 'package:tire_fitting/requestTypes/RequestType.dart';

class ChangeWheel extends RequestType{
  @override
  double getDuration(int radius) {
    return 15 * 60 * (1 + (radius - 13) / 5);
  }

  String name = 'change_wheel';

}