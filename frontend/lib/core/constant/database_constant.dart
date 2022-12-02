import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class CollectionNames {
  static String get note => 'note';
  static String get databaseId => dotenv.env['APPWRITE_DATABASE_ID']!;
  static String get noteDocumentPath => 'collection.$note.documents';
}
