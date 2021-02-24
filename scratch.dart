void main() {
  String txt = 'mailto:883888';

  int index = txt.indexOf(':') + 1;
  print(index);

  print(txt.substring(0, index));
  print(txt.substring(index));
}
