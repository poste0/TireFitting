
class Address{
  String name;
  int x;
  int y;

  Address([this.name, this.x, this.y]);

  @override
  String toString() {
    return name;
  }
}