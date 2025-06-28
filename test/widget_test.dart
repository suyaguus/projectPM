import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_inventory_app/main.dart'; // Adjust import if your app package/folder name differs

void main() {
  testWidgets(
    'App starts and shows inventory list with search and add button',
    (WidgetTester tester) async {
      await tester.pumpWidget(InventoryApp());

      // Check for app bar title
      expect(find.text('Inventory Management'), findsOneWidget);

      // Check for search input
      expect(find.byType(TextField), findsOneWidget);
      expect(find.widgetWithIcon(TextField, Icons.search), findsOneWidget);

      // Check for Add button (FloatingActionButton)
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Check initial list items (e.g. Laptop, Office Chair)
      expect(find.text('Laptop'), findsOneWidget);
      expect(find.text('Office Chair'), findsOneWidget);
    },
  );

  testWidgets('Search filters inventory list', (WidgetTester tester) async {
    await tester.pumpWidget(InventoryApp());

    // Enter search text 'lap'
    await tester.enterText(find.byType(TextField), 'lap');
    await tester.pumpAndSettle();

    // Should find Laptop, but not Office Chair
    expect(find.text('Laptop'), findsOneWidget);
    expect(find.text('Office Chair'), findsNothing);
  });

  testWidgets('Add new inventory item works', (WidgetTester tester) async {
    await tester.pumpWidget(InventoryApp());

    // Tap add button
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Dialog appears
    expect(find.text('Add Inventory Item'), findsOneWidget);

    // Fill fields
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Item Name'),
      'Test Item',
    );
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Other').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Quantity'),
      '10',
    );

    // Tap Add button
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // New item should appear in list
    expect(find.text('Test Item'), findsOneWidget);
  });

  testWidgets('Edit inventory item works', (WidgetTester tester) async {
    await tester.pumpWidget(InventoryApp());

    // Tap edit button on Laptop item
    final editIcon = find
        .descendant(
          of: find.widgetWithText(ListTile, 'Laptop'),
          matching: find.byIcon(Icons.edit),
        )
        .first;
    await tester.tap(editIcon);
    await tester.pumpAndSettle();

    // Dialog appears with Laptop title
    expect(find.text('Edit Inventory Item'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Laptop'), findsOneWidget);

    // Change name to 'Laptop Edited'
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Item Name'),
      'Laptop Edited',
    );

    // Tap Save
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify updated item name in list
    expect(find.text('Laptop Edited'), findsOneWidget);
  });

  testWidgets('Delete inventory item works', (WidgetTester tester) async {
    await tester.pumpWidget(InventoryApp());

    // Tap delete button on 'Pen Pack' item
    final deleteIcon = find
        .descendant(
          of: find.widgetWithText(ListTile, 'Pen Pack'),
          matching: find.byIcon(Icons.delete),
        )
        .first;
    await tester.tap(deleteIcon);
    await tester.pumpAndSettle();

    // Confirm delete dialog appears
    expect(find.text('Delete Item'), findsOneWidget);

    // Tap Delete
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    // Item should be removed
    expect(find.text('Pen Pack'), findsNothing);
  });
}
