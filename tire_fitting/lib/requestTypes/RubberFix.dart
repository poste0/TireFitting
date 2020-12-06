import 'package:tire_fitting/requestTypes/RequestType.dart';

class RubberFix extends RequestType{
  @override
  double getDuration(int radius) {
    return 30 * 60 * (1 + (radius - 13) / 5);
  }

  String name = 'rubber_fix';

}