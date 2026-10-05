import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_practice/app/app.locator.dart';
import 'package:supabase_practice/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

const String _fetchBusyKey = 'fetch';
const String _saveBusyKey = 'save';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();
  final supabase = Supabase.instance.client;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  List<Map<String, dynamic>> items = [];
  String? errorMessage;

  /// id of the row being edited, or null when adding a new one.
  dynamic editingId;
  bool get isEditing => editingId != null;

  bool get isFetching => busy(_fetchBusyKey);
  bool get isSaving => busy(_saveBusyKey);

  // READ
  Future<void> fetchItems() async {
    try {
      final data = await runBusyFuture(
        supabase.from('lists').select().order('id', ascending: false),
        busyObject: _fetchBusyKey,
        throwException: true,
      );
      items = List<Map<String, dynamic>>.from(data);
      errorMessage = null;
    } on PostgrestException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'Could not load items.';
    }
    rebuildUi();
  }

  // CREATE / UPDATE
  Future<void> save() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty) {
      errorMessage = 'Please enter a title.';
      rebuildUi();
      return;
    }
    errorMessage = null;

    final values = {'title': title, 'description': description};

    try {
      await runBusyFuture(
        isEditing
            ? supabase.from('lists').update(values).eq('id', editingId)
            : supabase.from('lists').insert(values),
        busyObject: _saveBusyKey,
        throwException: true,
      );
      cancelEdit();
      await fetchItems();
    } on PostgrestException catch (e) {
      errorMessage = e.message;
      rebuildUi();
    } catch (_) {
      errorMessage = 'Could not save item.';
      rebuildUi();
    }
  }

  void startEdit(Map<String, dynamic> item) {
    editingId = item['id'];
    titleController.text = item['title'] ?? '';
    descriptionController.text = item['description'] ?? '';
    errorMessage = null;
    rebuildUi();
  }

  void cancelEdit() {
    editingId = null;
    titleController.clear();
    descriptionController.clear();
    rebuildUi();
  }

  // DELETE
  Future<void> delete(Map<String, dynamic> item) async {
    final response = await _dialogService.showConfirmationDialog(
      title: 'Delete item?',
      description: 'Delete "${item['title']}"? This cannot be undone.',
      confirmationTitle: 'Delete',
      cancelTitle: 'Cancel',
    );
    if (response?.confirmed != true) return;

    try {
      await supabase.from('lists').delete().eq('id', item['id']);
      if (editingId == item['id']) cancelEdit();
      items.removeWhere((i) => i['id'] == item['id']);
      errorMessage = null;
    } on PostgrestException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'Could not delete item.';
    }
    rebuildUi();
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
    _navigationService.clearStackAndShow(Routes.loginView);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
