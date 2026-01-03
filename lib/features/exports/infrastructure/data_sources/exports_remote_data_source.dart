import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/network/api_client.dart';

class ExportsRemoteDataSource {
  final ApiClient _client;

  ExportsRemoteDataSource(this._client);

  Future<File> exportExpensesToCsv({
    DateTime? from,
    DateTime? to,
    String? categoryId,
    String? tagId,
    String? search,
  }) async {
    final query = <String, dynamic>{};
    if (from != null) query['from'] = from.toIso8601String();
    if (to != null) query['to'] = to.toIso8601String();
    if (categoryId != null) query['categoryId'] = categoryId;
    if (tagId != null) query['tagId'] = tagId;
    if (search != null) query['search'] = search;

    final response = await _client.get(
      '/exports/expenses',
      queryParameters: query,
      // We expect the CSV as plain text response from the current backend implementation
    );

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/expenses_export.csv');
    await file.writeAsString(response.data.toString());
    
    return file;
  }
}
