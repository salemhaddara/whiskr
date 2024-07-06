// ignore_for_file: camel_case_types,file_names

class formatDate {
  static String fromdatetoString(DateTime time) {
    DateTime now = time;
    String formattedTime = now.hour > 12
        ? '${now.hour - 12}:${now.minute} PM'
        : '${now.hour}:${now.minute} AM';
    String formattedDate = now.day == DateTime.now().day
        ? 'Today'
        : '${now.day}/${now.month}/${now.year}';
    return '$formattedDate $formattedTime';
  }
}
