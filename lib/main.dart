import 'package:flutter/material.dart';

// Tidak lagi memerlukan 'intl' atau 'date_symbol_data_local'
// jadi fungsi main kembali seperti semula.
void main() {
  runApp(InventoryApp());
}

class InventoryItem {
  int id;
  String name;
  String category;
  int quantity;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
  });
}

// Main App StatefulWidget with Login and Bottom Navigation
class InventoryApp extends StatefulWidget {
  @override
  _InventoryAppState createState() => _InventoryAppState();
}

class _InventoryAppState extends State<InventoryApp> {
  bool _loggedIn = false;

  int _selectedIndex = 0;

  // Variabel _lastLoginTime sudah tidak diperlukan dan telah dihapus.

  // Hardcoded admin credentials
  final String _adminUsername = 'suyaguus';
  final String _adminPassword = 'suyaguus';

  final List<InventoryItem> _inventory = [
    InventoryItem(
      id: 1,
      name: 'Daun Monstera',
      category: 'Monstera',
      quantity: 10,
    ),
    InventoryItem(id: 2, name: 'Bunga Peony', category: 'Peony', quantity: 8),
    InventoryItem(
      id: 3,
      name: 'Anggrek Latex',
      category: 'Anggrek',
      quantity: 12,
    ),
  ];

  // Maintain categories extracted from initial inventory
  List<String> _categories = ['Mawar', 'Anggrek', 'Monstera', 'Peony'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addItem(InventoryItem item) {
    setState(() {
      final newId = _inventory.isNotEmpty
          ? _inventory.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1
          : 1;
      item.id = newId;
      _inventory.add(item);
      // If category of item is new, add it
      if (!_categories.contains(item.category)) {
        _categories.add(item.category);
      }
    });
  }

  void _editItem(InventoryItem updatedItem) {
    setState(() {
      final index = _inventory.indexWhere((item) => item.id == updatedItem.id);
      if (index != -1) {
        _inventory[index] = updatedItem;
      }
    });
  }

  void _deleteItem(int id) {
    setState(() {
      _inventory.removeWhere((item) => item.id == id);
    });
  }

  void _addCategory(String category) {
    setState(() {
      if (!_categories.contains(category)) {
        _categories.add(category);
      }
    });
  }

  void _editCategory(String oldCategory, String newCategory) {
    setState(() {
      final index = _categories.indexOf(oldCategory);
      if (index != -1) {
        _categories[index] = newCategory;
        // Update products assigned to oldCategory to newCategory
        for (var item in _inventory) {
          if (item.category == oldCategory) {
            item.category = newCategory;
          }
        }
      }
    });
  }

  void _deleteCategory(String category) {
    setState(() {
      _categories.remove(category);
      // Remove all inventory items that belong to this category
      _inventory.removeWhere((item) => item.category == category);
    });
  }

  void _login(String username, String password) {
    if (username == _adminUsername && password == _adminPassword) {
      setState(() {
        _loggedIn = true;
        // Tidak perlu lagi mencatat waktu login
      });
    } else {
      // Show error on login failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid username or password'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  void _logout() {
    setState(() {
      _loggedIn = false;
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Kode di dalam EditorPage disesuaikan dengan versi terakhir
    // yang sudah memiliki fungsionalitas edit dan delete produk.
    final pages = [
      HomePage(inventory: _inventory),
      ProductCategoryPage(categories: _categories, inventory: _inventory),
      EditorPage(
        inventory: _inventory,
        categories: _categories,
        onAddProduct: _addItem,
        onEditProduct: _editItem,
        onDeleteProduct: _deleteItem,
        onAddCategory: _addCategory,
        onEditCategory: _editCategory,
        onDeleteCategory: _deleteCategory,
      ),
      // Menggunakan AccountPage yang sudah diperbarui tanpa history
      AccountPage(username: _adminUsername, onLogout: _logout),
    ];

    if (!_loggedIn) {
      return MaterialApp(
        title: 'Login',
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.indigo,
          fontFamily: 'Poppins',
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
            headlineLarge: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            titleLarge: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            bodyMedium: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            labelStyle: TextStyle(color: Colors.black54),
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.red.shade700,
            contentTextStyle: TextStyle(color: Colors.white),
          ),
        ),
        home: LoginPage(onLogin: _login),
      );
    }

    return MaterialApp(
      title: 'Manajemen Inventaris',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.indigo,
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
            height: 1.4,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelStyle: TextStyle(color: Colors.black54),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.green.shade700,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            _selectedIndex == 0
                ? 'Home'
                : _selectedIndex == 1
                ? 'Product & Category'
                : _selectedIndex == 2
                ? 'Editor'
                : 'Account',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          centerTitle: true,
        ),
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.indigo.shade700,
          unselectedItemColor: Colors.black54,
          showUnselectedLabels: true,
          elevation: 10,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              label: 'Product & Category',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_outlined),
              label: 'Editor',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}

// Login Page Widget
class LoginPage extends StatefulWidget {
  final void Function(String username, String password) onLogin;

  LoginPage({required this.onLogin});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _username = '';
  String _password = '';

  bool _obscurePassword = true;

  void _tryLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      widget.onLogin(_username, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Card(
            color: Colors.grey.shade50,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadowColor: Colors.grey.shade300,
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    SizedBox(height: 32),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Please enter username'
                          : null,
                      onSaved: (val) => _username = val!.trim(),
                      style: TextStyle(color: Colors.black87),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (val) => val == null || val.isEmpty
                          ? 'Please enter password'
                          : null,
                      onSaved: (val) => _password = val ?? '',
                      style: TextStyle(color: Colors.black87),
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _tryLogin,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        child: Text('Log In'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 1. Homepage: show simple dashboard summary with inventory list
class HomePage extends StatelessWidget {
  final List<InventoryItem> inventory;

  HomePage({required this.inventory});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 36),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Manage your products and categories easily using the Editor section.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Color(0xFF6B7280)),
              ),
              SizedBox(height: 32),

              // Card summary for total categories & products
              Wrap(
                spacing: 32,
                runSpacing: 32,
                children: [
                  _SummaryCard(
                    label: 'Total Products',
                    value: inventory.length.toString(),
                    icon: Icons.inventory_2_outlined,
                    iconColor: Colors.indigo.shade700,
                    textColor: Colors.black87,
                    backgroundColor: Colors.grey[50],
                  ),
                  _SummaryCard(
                    label: 'Total Quantity',
                    value: inventory
                        .fold<int>(0, (sum, item) => sum + item.quantity)
                        .toString(),
                    icon: Icons.confirmation_num_outlined,
                    iconColor: Colors.indigo.shade700,
                    textColor: Colors.black87,
                    backgroundColor: Colors.grey[50],
                  ),
                  _SummaryCard(
                    label: 'Categories',
                    value: inventory.isNotEmpty
                        ? inventory
                              .map((e) => e.category)
                              .toSet()
                              .length
                              .toString()
                        : '0',
                    icon: Icons.category_outlined,
                    iconColor: Colors.indigo.shade700,
                    textColor: Colors.black87,
                    backgroundColor: Colors.grey[50],
                  ),
                ],
              ),
              SizedBox(height: 48),
              Text(
                'Inventory List',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              inventory.isEmpty
                  ? Text(
                      'No products available.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Color(0xFF6B7280),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: inventory.length,
                      separatorBuilder: (context, index) =>
                          Divider(height: 1, color: Colors.grey[300]),
                      itemBuilder: (context, index) {
                        final item = inventory[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          title: Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: Colors.black87),
                          ),
                          subtitle: Text(
                            '${item.category} • Quantity: ${item.quantity}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Color(0xFF6B7280)),
                          ),
                          leading: Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.indigo.shade700,
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color textColor;
  final Color? backgroundColor;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.textColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor ?? Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 260,
        padding: EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(12),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: textColor,
                  ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 2. Product & Category Page
class ProductCategoryPage extends StatefulWidget {
  final List<String> categories;
  final List<InventoryItem> inventory;

  ProductCategoryPage({required this.categories, required this.inventory});

  @override
  _ProductCategoryPageState createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _searchQuery.isEmpty
        ? widget.inventory
        : widget.inventory
              .where(
                (item) =>
                    item.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    item.category.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Products & Categories',
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(color: Colors.black87),
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search products or categories...',
                  prefixIcon: Icon(Icons.search, color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                ),
                style: TextStyle(color: Colors.black87),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim();
                  });
                },
              ),
              SizedBox(height: 24),
              filteredProducts.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Center(
                        child: Text(
                          'No products found.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Color(0xFF6B7280)),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final item = filteredProducts[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            color: Colors.grey[50],
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 24,
                              ),
                              title: Text(
                                item.name,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(color: Colors.black87),
                              ),
                              subtitle: Text(
                                'Category: ${item.category}\nQuantity: ${item.quantity}',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Color(0xFF6B7280)),
                              ),
                              trailing: Icon(
                                Icons.inventory_2_outlined,
                                color: Colors.indigo.shade700,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. Editor Page
class EditorPage extends StatefulWidget {
  final List<InventoryItem> inventory;
  final List<String> categories;
  final void Function(InventoryItem) onAddProduct;
  final void Function(InventoryItem) onEditProduct;
  final void Function(int) onDeleteProduct;
  final void Function(String) onAddCategory;
  final void Function(String oldCategory, String newCategory) onEditCategory;
  final void Function(String) onDeleteCategory;

  EditorPage({
    required this.inventory,
    required this.categories,
    required this.onAddProduct,
    required this.onEditProduct,
    required this.onDeleteProduct,
    required this.onAddCategory,
    required this.onEditCategory,
    required this.onDeleteCategory,
  });

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> with TickerProviderStateMixin {
  late TabController _tabController;

  final _productFormKey = GlobalKey<FormState>();
  final _categoryFormKey = GlobalKey<FormState>();

  final _productNameController = TextEditingController();
  final _quantityController = TextEditingController();
  String? _selectedCategory;

  InventoryItem? _editingProduct;
  final _categoryController = TextEditingController();
  String? _editingCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.categories.isNotEmpty) {
      _selectedCategory = widget.categories.first;
    }
  }

  @override
  void didUpdateWidget(covariant EditorPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.categories.isNotEmpty && !_currentCategoryExists()) {
      setState(() {
        _selectedCategory = widget.categories.first;
      });
    }
    if (widget.inventory != oldWidget.inventory && _editingProduct != null) {
      if (!widget.inventory.any((p) => p.id == _editingProduct!.id)) {
        _stopEditingProduct();
      }
    }
  }

  bool _currentCategoryExists() {
    return widget.categories.contains(_selectedCategory);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _categoryController.dispose();
    _productNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _addOrEditCategory() {
    if (!(_categoryFormKey.currentState?.validate() ?? false)) return;
    final newCategory = _categoryController.text.trim();
    if (_editingCategory != null) {
      if (newCategory != _editingCategory) {
        widget.onEditCategory(_editingCategory!, newCategory);
      }
      setState(() {
        _editingCategory = null;
      });
    } else {
      if (widget.categories.contains(newCategory)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Category already exists',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.orange.shade700,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        return;
      }
      widget.onAddCategory(newCategory);
    }
    _categoryController.clear();
    _categoryFormKey.currentState?.reset();
    _tabController.animateTo(0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _editingCategory == null ? 'Category added' : 'Category updated',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _startEditingCategory(String category) {
    setState(() {
      _editingCategory = category;
      _categoryController.text = category;
      _tabController.animateTo(2); // Switch to category tab
    });
  }

  void _deleteCategoryConfirmed(String category) {
    widget.onDeleteCategory(category);
    if (_editingCategory == category) {
      setState(() {
        _editingCategory = null;
        _categoryController.clear();
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Category "$category" deleted',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _submitProduct() {
    if (!(_productFormKey.currentState?.validate() ?? false)) return;

    _productFormKey.currentState?.save();

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a category',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    final quantity = int.tryParse(_quantityController.text);

    if (quantity == null || quantity < 0) {
      return;
    }

    if (_editingProduct != null) {
      final updatedItem = InventoryItem(
        id: _editingProduct!.id,
        name: _productNameController.text,
        category: _selectedCategory!,
        quantity: quantity,
      );
      widget.onEditProduct(updatedItem);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product "${updatedItem.name}" updated'),
          backgroundColor: Colors.green.shade700,
        ),
      );
      _stopEditingProduct();
    } else {
      final newItem = InventoryItem(
        id: 0,
        name: _productNameController.text,
        category: _selectedCategory!,
        quantity: quantity,
      );

      widget.onAddProduct(newItem);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product "${newItem.name}" added'),
          backgroundColor: Colors.green.shade700,
        ),
      );
    }
    _productFormKey.currentState?.reset();
    _productNameController.clear();
    _quantityController.clear();
    setState(() {
      _selectedCategory = widget.categories.isNotEmpty
          ? widget.categories.first
          : null;
    });
  }

  void _startEditingProduct(InventoryItem item) {
    setState(() {
      _editingProduct = item;
      _productNameController.text = item.name;
      _quantityController.text = item.quantity.toString();
      _selectedCategory = item.category;
      _tabController.animateTo(0); // Switch to the product form tab
    });
  }

  void _stopEditingProduct() {
    setState(() {
      _editingProduct = null;
      _productNameController.clear();
      _quantityController.clear();
      _productFormKey.currentState?.reset();
      _selectedCategory = widget.categories.isNotEmpty
          ? widget.categories.first
          : null;
    });
  }

  void _deleteProductConfirmed(int id) {
    widget.onDeleteProduct(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product deleted'),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }

  Widget _buildProductFormTab() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Form(
        key: _productFormKey,
        child: ListView(
          children: [
            Text(
              _editingProduct == null ? 'Add Product' : 'Edit Product',
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(color: Colors.black87),
            ),
            SizedBox(height: 24),
            TextFormField(
              controller: _productNameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: TextStyle(color: Colors.black54),
              ),
              validator: (val) => val == null || val.trim().isEmpty
                  ? 'Please enter product name'
                  : null,
              style: TextStyle(color: Colors.black87),
            ),
            SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: TextStyle(color: Colors.black54),
              ),
              dropdownColor: Colors.white,
              items: widget.categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedCategory = val;
                });
              },
              validator: (val) => val == null || val.isEmpty
                  ? 'Please select a category'
                  : null,
              style: TextStyle(color: Colors.black87),
            ),
            SizedBox(height: 24),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: TextStyle(color: Colors.black54),
              ),
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please enter quantity';
                final n = int.tryParse(val);
                if (n == null || n < 0) return 'Quantity must be 0 or more';
                return null;
              },
              style: TextStyle(color: Colors.black87),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitProduct,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  _editingProduct == null ? 'Save Product' : 'Update Product',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 3,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            if (_editingProduct != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextButton(
                  onPressed: _stopEditingProduct,
                  child: Text('Cancel Edit'),
                ),
              ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: widget.inventory.isEmpty
          ? Center(
              child: Text(
                'No products to manage.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          : ListView.builder(
              itemCount: widget.inventory.length,
              itemBuilder: (context, index) {
                final item = widget.inventory[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                      'Category: ${item.category} | Qty: ${item.quantity}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.black54),
                          onPressed: () => _startEditingProduct(item),
                          tooltip: 'Edit Product',
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red.shade700),
                          tooltip: 'Delete Product',
                          onPressed: () => showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Confirm Deletion'),
                              content: Text(
                                'Are you sure you want to delete "${item.name}"?',
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () => Navigator.of(ctx).pop(),
                                ),
                                ElevatedButton(
                                  child: Text('Delete'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade700,
                                  ),
                                  onPressed: () {
                                    _deleteProductConfirmed(item.id);
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildCategoryTab() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Manage Categories',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(color: Colors.black87),
          ),
          SizedBox(height: 16),
          Expanded(
            child: widget.categories.isEmpty
                ? Center(
                    child: Text(
                      'No categories created yet.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: widget.categories.length,
                    separatorBuilder: (_, __) =>
                        Divider(color: Colors.grey[300]),
                    itemBuilder: (context, index) {
                      final cat = widget.categories[index];
                      return ListTile(
                        title: Text(
                          cat,
                          style: TextStyle(color: Colors.black87),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Edit Category',
                              icon: Icon(Icons.edit, color: Colors.black54),
                              onPressed: () => _startEditingCategory(cat),
                            ),
                            IconButton(
                              tooltip: 'Delete Category',
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red.shade700,
                              ),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: Text(
                                    'Delete Category',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  content: Text(
                                    'Are you sure you want to delete "$cat"? This will also remove all products in this category.',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade700,
                                      ),
                                      onPressed: () {
                                        _deleteCategoryConfirmed(cat);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Form(
            key: _categoryFormKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: _editingCategory == null
                        ? 'New Category Name'
                        : 'Edit Category Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelStyle: TextStyle(color: Colors.black54),
                  ),
                  style: TextStyle(color: Colors.black87),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Please enter a category name'
                      : null,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addOrEditCategory,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      _editingCategory == null
                          ? 'Add Category'
                          : 'Save Changes',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.grey[50],
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.indigo.shade700,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.indigo.shade700,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Product Form'),
              Tab(text: 'Manage Products'),
              Tab(text: 'Manage Categories'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildProductFormTab(),
              _buildProductListTab(),
              _buildCategoryTab(),
            ],
          ),
        ),
      ],
    );
  }
}

// 4. Account Page: Tampilan baru yang lebih sederhana tanpa history
class AccountPage extends StatelessWidget {
  final String username;
  final VoidCallback onLogout;

  const AccountPage({Key? key, required this.username, required this.onLogout})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(36.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Membuat card seukuran konten
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.indigo.shade100,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    username,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Administrator',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  ElevatedButton.icon(
                    icon: Icon(Icons.logout),
                    onPressed: onLogout,
                    label: Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
