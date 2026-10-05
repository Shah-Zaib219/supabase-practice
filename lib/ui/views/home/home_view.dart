import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:supabase_practice/ui/common/app_colors.dart';
import 'package:supabase_practice/ui/common/ui_helpers.dart';
import 'package:supabase_practice/ui/widgets/auth_layout.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Column(
        children: [
          // Gradient header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: kgPrimaryGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 12, 32),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello there 👋',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white70,
                            ),
                          ),
                          verticalSpaceTiny,
                          Text(
                            'My List',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Logout',
                      onPressed: viewModel.logout,
                      icon: const Icon(Icons.logout_rounded),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: viewModel.fetchItems,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _ItemForm(viewModel: viewModel),
                  verticalSpaceMedium,
                  Row(
                    children: [
                      const Text(
                        'Items',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: kcDarkGreyColor,
                        ),
                      ),
                      horizontalSpaceSmall,
                      Text(
                        '${viewModel.items.length}',
                        style: const TextStyle(color: kcMediumGrey),
                      ),
                    ],
                  ),
                  verticalSpaceSmall,
                  ..._buildItems(viewModel),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildItems(HomeViewModel viewModel) {
    if (viewModel.isFetching && viewModel.items.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }
    if (viewModel.items.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 48, color: kcLightGrey),
              verticalSpaceSmall,
              Text(
                'No items yet. Add one above.',
                style: TextStyle(color: kcMediumGrey),
              ),
            ],
          ),
        ),
      ];
    }
    return [
      for (final item in viewModel.items)
        _ItemTile(
          item: item,
          selected: viewModel.editingId == item['id'],
          onEdit: () => viewModel.startEdit(item),
          onDelete: () => viewModel.delete(item),
        ),
    ];
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.fetchItems();
}

class _ItemForm extends StatelessWidget {
  final HomeViewModel viewModel;

  const _ItemForm({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14300151),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            viewModel.isEditing ? 'Edit item' : 'Add new item',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: kcDarkGreyColor,
            ),
          ),
          verticalSpaceSmall,
          TextField(
            controller: viewModel.titleController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Title',
              prefixIcon: Icon(Icons.title_rounded),
            ),
          ),
          verticalSpaceSmall,
          TextField(
            controller: viewModel.descriptionController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.notes_rounded),
            ),
          ),
          verticalSpaceMedium,
          AuthErrorText(viewModel.errorMessage),
          AuthSubmitButton(
            label: viewModel.isEditing ? 'Update' : 'Add',
            busy: viewModel.isSaving,
            onPressed: viewModel.save,
          ),
          if (viewModel.isEditing) ...[
            verticalSpaceTiny,
            TextButton(
              onPressed: viewModel.cancelEdit,
              child: const Text('Cancel'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool selected;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ItemTile({
    required this.item,
    required this.selected,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final description = (item['description'] ?? '').toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? kcPrimaryColor : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (item['title'] ?? '').toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: kcDarkGreyColor,
                  ),
                ),
                if (description.isNotEmpty) ...[
                  verticalSpaceTiny,
                  Text(
                    description,
                    style: const TextStyle(color: kcMediumGrey, height: 1.3),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit',
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, color: kcPrimaryColor),
          ),
          IconButton(
            tooltip: 'Delete',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: kcErrorColor),
          ),
        ],
      ),
    );
  }
}
