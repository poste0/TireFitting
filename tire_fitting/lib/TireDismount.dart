import 'RequestType.dart';

class TireDismount implements RequestType{
  @override
  double getDuration(int radius) {
    return 60 * 60 * (1 + (radius - 13) / 5);
  }

}