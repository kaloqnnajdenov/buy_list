import 'package:flutter/material.dart';
import '../widgets/shopping_item.dart';
import '../services/storage_service.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final _storage = StorageService();
  List<String> _items = <String>[];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    _items = await _storage.loadItems();
    setState(() {});
  }

  Future<void> _saveItems() async => _storage.saveItems(_items);

  // ---------- UI actions ----------
  void _showAddItemDialog() {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add item'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. Milk'),
          onSubmitted: (_) => _saveAndClose(controller),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Discard'),
          ),
          ElevatedButton(
            onPressed: () => _saveAndClose(controller),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _saveAndClose(TextEditingController c) {
    final text = c.text.trim();
    if (text.isNotEmpty) {
      setState(() => _items.add(text));
      _saveItems();
    }
    Navigator.pop(context);
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
    _saveItems();
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add), onPressed: _showAddItemDialog),
        ],
      ),
      body: _items.isEmpty
          ? const Center(child: Text('Tap + to add your first item'))
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Dismissible(
                  key: ValueKey(_items[i]),
                  direction: DismissDirection.endToStart, // swipe left only

                  // ← REQUIRED, even if you never swipe right
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent, // invisible filler
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  // ← shows while swiping left (right-to-left)
                  secondaryBackground: Container(
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.delete, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Delete',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                  onDismissed: (_) => _removeItem(i),

                  // ③ the actual list row (your ShoppingItem widget)
                  child: ShoppingItem(text: _items[i]), // keep this as is
                ),
              ),
            ),
    );
  }
}
