import 'package:softmed24h/src/data/models/transaction.dart';
import 'package:softmed24h/src/data/network/api_client.dart';

class TransactionsApiService {
  final ApiClient _apiClient;

  TransactionsApiService(this._apiClient);

  Future<FinancialSummary> getFinancialSummary() async {
    final response = await _apiClient.get('/transactions/summary');
    return FinancialSummary.fromJson(response);
  }

  Future<List<Transaction>> getFinancialExtract({
    int skip = 0,
    int limit = 100,
  }) async {
    final response = await _apiClient.get(
      '/transactions/?skip=$skip&limit=$limit',
    );
    return (response as List)
        .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Transaction> getTransactionEntry(int entryId) async {
    final response = await _apiClient.get('/transactions/$entryId');
    return Transaction.fromJson(response);
  }

  Future<Transaction> createTransactionEntry(
    TransactionCreate transaction,
  ) async {
    final response = await _apiClient.post(
      '/transactions/',
      body: transaction.toJson(),
    );
    return Transaction.fromJson(response);
  }

  Future<void> deleteTransactionEntry(int entryId) async {
    await _apiClient.delete('/transactions/$entryId');
  }
}
