bool checkAge(DateTime dob)
{
  DateTime today = DateTime.now();
  Duration ageDiff = today.difference(dob);

  int age = ageDiff.inDays ~/ 365;

  return age >= 13;
}