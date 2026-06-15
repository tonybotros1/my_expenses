import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../consts.dart';
import '../models/category_model.dart';
import '../models/expense_template.dart';
import '../models/item_model.dart';
import '../models/money_movement.dart';
import '../models/recurring_expense.dart';
import '../models/spending_goal.dart';
import '../models/transaction_rule.dart';
import '../models/wallet_account.dart';

class DailyToolsController extends GetxController {
  final categories = <CategoryModel>[].obs;
  final items = <ItemModel>[].obs;
  final templates = <ExpenseTemplate>[].obs;
  final recurringExpenses = <RecurringExpense>[].obs;
  final wallets = <WalletAccount>[].obs;
  final movements = <MoneyMovement>[].obs;
  final goals = <SpendingGoal>[].obs;
  final transactionRules = <TransactionRule>[].obs;
  final budgets = <String, double>{}.obs;
  final budgetRollover = <String, bool>{}.obs;
  final categoryMeta = <String, Map<String, dynamic>>{}.obs;
  final isReady = false.obs;
  final lastGeneratedRecurringCount = 0.obs;

  final quickNameController = TextEditingController();
  final quickPriceController = TextEditingController();
  final quickQuantityController = TextEditingController(text: '1');
  final quickNoteController = TextEditingController();
  final quickCategoryId = RxnString();
  final quickWalletId = RxnString();
  final quickSaveAsTemplate = false.obs;

  final movementAmountController = TextEditingController();
  final movementNoteController = TextEditingController();
  final movementWalletId = RxnString();
  final movementToWalletId = RxnString();

  late Box<CategoryModel> _categoryBox;
  late Box<ItemModel> _itemsBox;
  late Box<dynamic> _templateBox;
  late Box<dynamic> _recurringBox;
  late Box<dynamic> _budgetBox;
  late Box<dynamic> _budgetRolloverBox;
  late Box<dynamic> _categoryMetaBox;
  late Box<dynamic> _walletBox;
  late Box<dynamic> _movementBox;
  late Box<dynamic> _goalBox;
  late Box<dynamic> _ruleBox;
  final _subscriptions = <StreamSubscription<BoxEvent>>[];

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  @override
  void onClose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    quickNameController.dispose();
    quickPriceController.dispose();
    quickQuantityController.dispose();
    quickNoteController.dispose();
    movementAmountController.dispose();
    movementNoteController.dispose();
    super.onClose();
  }

  Future<void> _initialize() async {
    _categoryBox = Hive.isBoxOpen('category_box')
        ? Hive.box<CategoryModel>('category_box')
        : await Hive.openBox<CategoryModel>('category_box');
    _itemsBox = Hive.isBoxOpen('item_box')
        ? Hive.box<ItemModel>('item_box')
        : await Hive.openBox<ItemModel>('item_box');
    _templateBox = Hive.isBoxOpen('expense_template_box')
        ? Hive.box<dynamic>('expense_template_box')
        : await Hive.openBox<dynamic>('expense_template_box');
    _recurringBox = Hive.isBoxOpen('recurring_expense_box')
        ? Hive.box<dynamic>('recurring_expense_box')
        : await Hive.openBox<dynamic>('recurring_expense_box');
    _budgetBox = Hive.isBoxOpen('monthly_budget_box')
        ? Hive.box<dynamic>('monthly_budget_box')
        : await Hive.openBox<dynamic>('monthly_budget_box');
    _budgetRolloverBox = Hive.isBoxOpen('budget_rollover_box')
        ? Hive.box<dynamic>('budget_rollover_box')
        : await Hive.openBox<dynamic>('budget_rollover_box');
    _categoryMetaBox = Hive.isBoxOpen('category_meta_box')
        ? Hive.box<dynamic>('category_meta_box')
        : await Hive.openBox<dynamic>('category_meta_box');
    _walletBox = Hive.isBoxOpen('wallet_box')
        ? Hive.box<dynamic>('wallet_box')
        : await Hive.openBox<dynamic>('wallet_box');
    _movementBox = Hive.isBoxOpen('money_movement_box')
        ? Hive.box<dynamic>('money_movement_box')
        : await Hive.openBox<dynamic>('money_movement_box');
    _goalBox = Hive.isBoxOpen('spending_goal_box')
        ? Hive.box<dynamic>('spending_goal_box')
        : await Hive.openBox<dynamic>('spending_goal_box');
    _ruleBox = Hive.isBoxOpen('transaction_rule_box')
        ? Hive.box<dynamic>('transaction_rule_box')
        : await Hive.openBox<dynamic>('transaction_rule_box');

    loadAll();
    _subscriptions
      ..add(_categoryBox.watch().listen((_) => loadCategories()))
      ..add(_itemsBox.watch().listen((_) => loadItems()))
      ..add(_templateBox.watch().listen((_) => loadTemplates()))
      ..add(_recurringBox.watch().listen((_) => loadRecurringExpenses()))
      ..add(_budgetBox.watch().listen((_) => loadBudgets()))
      ..add(_budgetRolloverBox.watch().listen((_) => loadBudgetRollover()))
      ..add(_categoryMetaBox.watch().listen((_) => loadCategoryMeta()))
      ..add(_walletBox.watch().listen((_) => loadWallets()))
      ..add(_movementBox.watch().listen((_) => loadMovements()))
      ..add(_goalBox.watch().listen((_) => loadGoals()))
      ..add(_ruleBox.watch().listen((_) => loadTransactionRules()));

    await createDueRecurringExpenses(showMessage: false);
    isReady.value = true;
  }

  void loadAll() {
    loadCategories();
    loadItems();
    loadTemplates();
    loadRecurringExpenses();
    loadBudgets();
    loadBudgetRollover();
    loadCategoryMeta();
    loadWallets();
    loadMovements();
    loadGoals();
    loadTransactionRules();
  }

  void loadCategories() {
    categories.value = _categoryBox.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    quickCategoryId.value ??= categories.isEmpty ? null : categories.first.id;
  }

  void loadWallets() {
    wallets.value =
        _walletBox.values
            .whereType<Map<dynamic, dynamic>>()
            .map(WalletAccount.fromMap)
            .where((wallet) => wallet.name.trim().isNotEmpty)
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    quickWalletId.value ??= wallets.isEmpty ? null : wallets.first.id;
    movementWalletId.value ??= wallets.isEmpty ? null : wallets.first.id;
  }

  void loadMovements() {
    movements.value =
        _movementBox.values
            .whereType<Map<dynamic, dynamic>>()
            .map(MoneyMovement.fromMap)
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
  }

  void loadGoals() {
    goals.value =
        _goalBox.values
            .whereType<Map<dynamic, dynamic>>()
            .map(SpendingGoal.fromMap)
            .where((goal) => goal.name.trim().isNotEmpty)
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  void loadTransactionRules() {
    transactionRules.value =
        _ruleBox.values
            .whereType<Map<dynamic, dynamic>>()
            .map(TransactionRule.fromMap)
            .where((rule) => rule.keyword.trim().isNotEmpty)
            .toList()
          ..sort((a, b) => a.keyword.compareTo(b.keyword));
  }

  void loadItems() {
    items.value = _itemsBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  void loadTemplates() {
    templates.value =
        _templateBox.values
            .whereType<Map<dynamic, dynamic>>()
            .map(ExpenseTemplate.fromMap)
            .where((template) => template.name.trim().isNotEmpty)
            .toList()
          ..sort((a, b) {
            if (a.isFavorite != b.isFavorite) return a.isFavorite ? -1 : 1;
            return b.updatedAt.compareTo(a.updatedAt);
          });
  }

  void loadRecurringExpenses() {
    recurringExpenses.value =
        _recurringBox.values
            .whereType<Map<dynamic, dynamic>>()
            .map(RecurringExpense.fromMap)
            .where((expense) => expense.name.trim().isNotEmpty)
            .toList()
          ..sort((a, b) => a.dayOfMonth.compareTo(b.dayOfMonth));
  }

  void loadBudgets() {
    budgets.value = {
      for (final entry in _budgetBox.toMap().entries)
        '${entry.key}': (entry.value as num?)?.toDouble() ?? 0,
    };
  }

  void loadBudgetRollover() {
    budgetRollover.value = {
      for (final entry in _budgetRolloverBox.toMap().entries)
        '${entry.key}': entry.value == true,
    };
  }

  void loadCategoryMeta() {
    categoryMeta.value = {
      for (final entry in _categoryMetaBox.toMap().entries)
        '${entry.key}': Map<String, dynamic>.from(entry.value as Map),
    };
  }

  List<ExpenseTemplate> get favoriteTemplates =>
      templates.where((template) => template.isFavorite).toList();

  List<ItemModel> get recentUniqueItems {
    final seen = <String>{};
    final result = <ItemModel>[];
    for (final item in items) {
      final key =
          '${item.name}-${item.category}-${item.quantity}-${item.price}';
      if (seen.add(key)) result.add(item);
      if (result.length == 8) break;
    }
    return result;
  }

  double get todayTotal =>
      _sumForRange(_todayStart(), _todayStart(daysAhead: 1));

  double get weekTotal {
    final today = _todayStart();
    final start = today.subtract(Duration(days: today.weekday - 1));
    return _sumForRange(start, start.add(const Duration(days: 7)));
  }

  double get monthTotal {
    final now = DateTime.now();
    return _sumForRange(
      DateTime(now.year, now.month),
      DateTime(now.year, now.month + 1),
    );
  }

  double get monthlyBudgetTotal =>
      categories.fold(0, (sum, category) => sum + effectiveBudget(category.id));

  double get remainingMonthlyBudget => monthlyBudgetTotal - monthTotal;

  double get totalWalletBalance =>
      wallets.fold(0, (sum, wallet) => sum + wallet.balance);

  double get safeToSpend {
    final budgetRemaining = monthlyBudgetTotal <= 0
        ? totalWalletBalance
        : remainingMonthlyBudget;
    return [
      totalWalletBalance,
      budgetRemaining,
    ].reduce((a, b) => a < b ? a : b);
  }

  List<RecurringExpense> get upcomingRecurringExpenses {
    final now = DateTime.now();
    final end = now.add(const Duration(days: 14));
    return recurringExpenses.where((expense) {
        if (!expense.isActive) return false;
        final dueDate = expense.nextDueDate(now);
        return !dueDate.isBefore(now) && !dueDate.isAfter(end);
      }).toList()
      ..sort((a, b) => a.nextDueDate(now).compareTo(b.nextDueDate(now)));
  }

  List<String> get insights {
    final result = <String>[];
    final now = DateTime.now();
    final thisMonthStart = DateTime(now.year, now.month);
    final lastMonthStart = DateTime(now.year, now.month - 1);
    final lastMonthEnd = thisMonthStart;
    final lastMonthTotal = _sumForRange(lastMonthStart, lastMonthEnd);

    if (lastMonthTotal > 0) {
      final delta = ((monthTotal - lastMonthTotal) / lastMonthTotal) * 100;
      if (delta.abs() >= 10) {
        result.add(
          'This month is ${delta > 0 ? 'up' : 'down'} ${delta.abs().toStringAsFixed(0)}% vs last month.',
        );
      }
    }

    for (final category in categories) {
      final budget = effectiveBudget(category.id);
      if (budget <= 0) continue;
      final spent = spentForCategoryThisMonth(category.id);
      final progress = spent / budget;
      if (progress >= 0.9) {
        result.add(
          '${category.name} is at ${(progress * 100).toStringAsFixed(0)}% of budget.',
        );
      }
    }

    if (upcomingRecurringExpenses.isNotEmpty) {
      result.add(
        '${upcomingRecurringExpenses.length} bill(s) due in the next 14 days.',
      );
    }

    if (result.isEmpty) {
      result.add('Spending is calm right now. Keep the quick add habit going.');
    }
    return result.take(3).toList();
  }

  String get topCategoryThisMonth {
    final totals = <String, double>{};
    final now = DateTime.now();
    final start = DateTime(now.year, now.month);
    final end = DateTime(now.year, now.month + 1);
    for (final item in items) {
      if (!item.date.isBefore(start) && item.date.isBefore(end)) {
        totals[item.category] = (totals[item.category] ?? 0) + item.price;
      }
    }
    if (totals.isEmpty) return 'None';
    final topId = totals.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    return getCategoryName(topId);
  }

  Future<void> addQuickExpense() async {
    final categoryId = quickCategoryId.value;
    if (categoryId == null) {
      showSnackBar(title: 'No Category', message: 'Add a category first.');
      return;
    }

    final unitPrice = double.tryParse(quickPriceController.text.trim());
    final quantity = int.tryParse(quickQuantityController.text.trim()) ?? 1;
    final fallbackName = getCategoryName(categoryId);
    final name = quickNameController.text.trim().isEmpty
        ? fallbackName
        : quickNameController.text.trim();

    final item = await addExpense(
      name: name,
      category: categoryId,
      unitPrice: unitPrice,
      quantity: quantity,
      note: quickNoteController.text.trim(),
      date: DateTime.now(),
      walletId: quickWalletId.value,
      showMessage: true,
    );

    if (item != null && quickSaveAsTemplate.value) {
      await saveTemplate(
        name: item.name,
        category: item.category,
        unitPrice: item.price / item.quantity,
        quantity: item.quantity,
        note: item.note,
        isFavorite: true,
      );
    }

    if (item != null) clearQuickForm();
  }

  Future<ItemModel?> addExpense({
    required String name,
    required String category,
    required double? unitPrice,
    required int quantity,
    required String note,
    required DateTime date,
    String? walletId,
    bool showMessage = false,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty ||
        category.isEmpty ||
        unitPrice == null ||
        unitPrice < 0 ||
        quantity <= 0) {
      showSnackBar(
        title: 'Missing Details',
        message: 'Enter a valid name, category, price, and quantity.',
      );
      return null;
    }

    final categoryId = _categoryFromRules(trimmedName) ?? category;
    final item = ItemModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: trimmedName,
      category: categoryId,
      date: date,
      note: note.trim(),
      price: unitPrice * quantity,
      quantity: quantity,
    );

    await _itemsBox.put(item.id, item);
    if (walletId != null) {
      await _recordMovement(
        type: MoneyMovementType.expense,
        amount: item.price,
        walletId: walletId,
        note: item.name,
        linkedItemId: item.id,
      );
    }
    if (showMessage) {
      showSnackBar(title: 'Added', message: '${item.name} was saved.');
    }
    return item;
  }

  Future<void> saveTemplate({
    String? id,
    required String name,
    required String category,
    required double unitPrice,
    required int quantity,
    required String note,
    bool isFavorite = false,
  }) async {
    if (name.trim().isEmpty ||
        category.isEmpty ||
        unitPrice < 0 ||
        quantity <= 0) {
      showSnackBar(title: 'Error', message: 'Template details are incomplete.');
      return;
    }

    final template = ExpenseTemplate(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      category: category,
      unitPrice: unitPrice,
      quantity: quantity,
      note: note.trim(),
      isFavorite: isFavorite,
      updatedAt: DateTime.now(),
    );
    await _templateBox.put(template.id, template.toMap());
    showSnackBar(title: 'Saved', message: 'Template "${template.name}" saved.');
  }

  Future<void> addExpenseFromTemplate(ExpenseTemplate template) async {
    await addExpense(
      name: template.name,
      category: template.category,
      unitPrice: template.unitPrice,
      quantity: template.quantity,
      note: template.note,
      date: DateTime.now(),
      walletId: quickWalletId.value,
      showMessage: true,
    );
    await _templateBox.put(
      template.id,
      template.copyWith(updatedAt: DateTime.now()).toMap(),
    );
  }

  Future<void> addExpenseFromRecent(ItemModel item) async {
    final quantity = item.quantity <= 0 ? 1 : item.quantity;
    await addExpense(
      name: item.name,
      category: item.category,
      unitPrice: item.price / quantity,
      quantity: quantity,
      note: item.note,
      date: DateTime.now(),
      walletId: quickWalletId.value,
      showMessage: true,
    );
  }

  Future<void> createTemplateFromItem(ItemModel item) async {
    final quantity = item.quantity <= 0 ? 1 : item.quantity;
    await saveTemplate(
      name: item.name,
      category: item.category,
      unitPrice: item.price / quantity,
      quantity: quantity,
      note: item.note,
      isFavorite: true,
    );
  }

  Future<void> toggleTemplateFavorite(ExpenseTemplate template) async {
    await _templateBox.put(
      template.id,
      template
          .copyWith(isFavorite: !template.isFavorite, updatedAt: DateTime.now())
          .toMap(),
    );
  }

  Future<void> deleteTemplate(String id) async {
    await _templateBox.delete(id);
  }

  Future<void> saveWallet({
    String? id,
    required String name,
    required double balance,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      showSnackBar(title: 'Error', message: 'Wallet name is required.');
      return;
    }

    final wallet = WalletAccount(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: trimmedName,
      balance: balance,
      createdAt:
          wallets.firstWhereOrNull((wallet) => wallet.id == id)?.createdAt ??
          DateTime.now(),
    );
    await _walletBox.put(wallet.id, wallet.toMap());
    showSnackBar(title: 'Saved', message: 'Wallet saved.');
  }

  Future<void> deleteWallet(String id) async {
    await _walletBox.delete(id);
    showSnackBar(title: 'Deleted', message: 'Wallet removed.');
  }

  Future<void> addIncome({
    required String walletId,
    required double amount,
    required String note,
  }) async {
    if (walletId.isEmpty || amount <= 0) {
      showSnackBar(title: 'Error', message: 'Choose a wallet and amount.');
      return;
    }
    await _recordMovement(
      type: MoneyMovementType.income,
      amount: amount,
      walletId: walletId,
      note: note.trim().isEmpty ? 'Income' : note.trim(),
    );
    clearMovementForm();
    showSnackBar(title: 'Added', message: 'Income saved.');
  }

  Future<void> transferMoney({
    required String fromWalletId,
    required String toWalletId,
    required double amount,
    required String note,
  }) async {
    if (fromWalletId.isEmpty ||
        toWalletId.isEmpty ||
        fromWalletId == toWalletId ||
        amount <= 0) {
      showSnackBar(title: 'Error', message: 'Choose two wallets and amount.');
      return;
    }
    await _recordMovement(
      type: MoneyMovementType.transfer,
      amount: amount,
      walletId: fromWalletId,
      toWalletId: toWalletId,
      note: note.trim().isEmpty ? 'Transfer' : note.trim(),
    );
    clearMovementForm();
    showSnackBar(title: 'Moved', message: 'Transfer saved.');
  }

  Future<void> saveGoal({
    String? id,
    required String name,
    required double targetAmount,
    double? savedAmount,
    DateTime? dueDate,
  }) async {
    if (name.trim().isEmpty || targetAmount <= 0) {
      showSnackBar(
        title: 'Error',
        message: 'Goal name and target are required.',
      );
      return;
    }
    final existing = goals.firstWhereOrNull((goal) => goal.id == id);
    final goal = SpendingGoal(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      targetAmount: targetAmount,
      savedAmount: savedAmount ?? existing?.savedAmount ?? 0,
      dueDate: dueDate ?? existing?.dueDate,
      createdAt: existing?.createdAt ?? DateTime.now(),
    );
    await _goalBox.put(goal.id, goal.toMap());
    showSnackBar(title: 'Saved', message: 'Goal saved.');
  }

  Future<void> addGoalContribution({
    required SpendingGoal goal,
    required double amount,
    String? walletId,
  }) async {
    if (amount <= 0) {
      showSnackBar(title: 'Error', message: 'Contribution amount is invalid.');
      return;
    }
    final updated = goal.copyWith(savedAmount: goal.savedAmount + amount);
    await _goalBox.put(updated.id, updated.toMap());
    if (walletId != null) {
      await _recordMovement(
        type: MoneyMovementType.goal,
        amount: amount,
        walletId: walletId,
        goalId: goal.id,
        note: goal.name,
      );
    }
    showSnackBar(title: 'Saved', message: 'Goal contribution added.');
  }

  Future<void> deleteGoal(String id) async {
    await _goalBox.delete(id);
  }

  Future<void> saveTransactionRule({
    String? id,
    required String keyword,
    required String category,
    bool isActive = true,
  }) async {
    if (keyword.trim().isEmpty || category.isEmpty) {
      showSnackBar(
        title: 'Error',
        message: 'Rule keyword and category are required.',
      );
      return;
    }
    final rule = TransactionRule(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      keyword: keyword.trim(),
      category: category,
      isActive: isActive,
    );
    await _ruleBox.put(rule.id, rule.toMap());
    showSnackBar(title: 'Saved', message: 'Rule saved.');
  }

  Future<void> toggleRule(TransactionRule rule, bool value) async {
    await _ruleBox.put(rule.id, rule.copyWith(isActive: value).toMap());
  }

  Future<void> deleteRule(String id) async {
    await _ruleBox.delete(id);
  }

  Future<void> saveRecurringExpense({
    String? id,
    required String name,
    required String category,
    required double unitPrice,
    required int quantity,
    required String note,
    required int dayOfMonth,
    bool isActive = true,
    String? lastCreatedMonth,
  }) async {
    if (name.trim().isEmpty ||
        category.isEmpty ||
        unitPrice < 0 ||
        quantity <= 0 ||
        dayOfMonth < 1 ||
        dayOfMonth > 28) {
      showSnackBar(
        title: 'Error',
        message: 'Recurring expenses need valid details and day 1-28.',
      );
      return;
    }

    final recurring = RecurringExpense(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      category: category,
      unitPrice: unitPrice,
      quantity: quantity,
      note: note.trim(),
      dayOfMonth: dayOfMonth,
      isActive: isActive,
      lastCreatedMonth: lastCreatedMonth,
    );
    await _recurringBox.put(recurring.id, recurring.toMap());
    showSnackBar(title: 'Saved', message: 'Recurring expense saved.');
  }

  Future<void> toggleRecurring(
    RecurringExpense recurring,
    bool isActive,
  ) async {
    await _recurringBox.put(
      recurring.id,
      recurring.copyWith(isActive: isActive).toMap(),
    );
  }

  Future<void> deleteRecurring(String id) async {
    await _recurringBox.delete(id);
  }

  Future<void> createDueRecurringExpenses({bool showMessage = true}) async {
    final now = DateTime.now();
    var createdCount = 0;

    for (final recurring in recurringExpenses) {
      if (!recurring.isDue(now)) continue;
      final created = await addExpense(
        name: recurring.name,
        category: recurring.category,
        unitPrice: recurring.unitPrice,
        quantity: recurring.quantity,
        note: recurring.note,
        date: DateTime(now.year, now.month, recurring.dayOfMonth.clamp(1, 28)),
      );
      if (created != null) {
        createdCount++;
        await _recurringBox.put(
          recurring.id,
          recurring
              .copyWith(lastCreatedMonth: RecurringExpense.monthKey(now))
              .toMap(),
        );
      }
    }

    lastGeneratedRecurringCount.value = createdCount;
    if (showMessage) {
      showSnackBar(
        title: 'Recurring Checked',
        message: createdCount == 0
            ? 'No recurring expenses are due.'
            : '$createdCount recurring expense(s) added.',
      );
    }
  }

  Future<void> setBudget(String categoryId, double amount) async {
    if (categoryId.isEmpty || amount < 0) {
      showSnackBar(title: 'Error', message: 'Budget amount is invalid.');
      return;
    }
    await _budgetBox.put(categoryId, amount);
    showSnackBar(title: 'Saved', message: 'Budget updated.');
  }

  Future<void> setBudgetRollover(String categoryId, bool value) async {
    await _budgetRolloverBox.put(categoryId, value);
  }

  Future<void> deleteBudget(String categoryId) async {
    await _budgetBox.delete(categoryId);
  }

  double spentForCategoryThisMonth(String categoryId) {
    final now = DateTime.now();
    return _sumForRange(
      DateTime(now.year, now.month),
      DateTime(now.year, now.month + 1),
      categoryId: categoryId,
    );
  }

  double effectiveBudget(String categoryId) {
    final baseBudget = budgets[categoryId] ?? 0;
    if (baseBudget <= 0 || budgetRollover[categoryId] != true) {
      return baseBudget;
    }

    final now = DateTime.now();
    final lastMonthStart = DateTime(now.year, now.month - 1);
    final lastMonthEnd = DateTime(now.year, now.month);
    final lastMonthSpent = _sumForRange(
      lastMonthStart,
      lastMonthEnd,
      categoryId: categoryId,
    );
    return baseBudget + (baseBudget - lastMonthSpent);
  }

  double progressForCategory(String categoryId) {
    final budget = effectiveBudget(categoryId);
    if (budget <= 0) return 0;
    return (spentForCategoryThisMonth(categoryId) / budget).clamp(0, 1);
  }

  Color categoryColor(CategoryModel category, int index) {
    final colorValue = categoryMeta[category.id]?['color'] as int?;
    if (colorValue != null) return Color(colorValue);
    return colors[index % colors.length];
  }

  IconData categoryIcon(CategoryModel? category) {
    if (category == null) return Icons.more_horiz;
    final iconName = categoryMeta[category.id]?['icon'] as String?;
    return iconName == null
        ? getCategoryIcon(category.name)
        : getIconByLabel(iconName);
  }

  String categoryIconLabel(CategoryModel category) {
    return categoryMeta[category.id]?['icon'] as String? ??
        iconLabelForName(category.name);
  }

  Future<void> setCategoryStyle({
    required String categoryId,
    required Color color,
    required String icon,
  }) async {
    await _categoryMetaBox.put(categoryId, {
      'color': color.toARGB32(),
      'icon': icon,
    });
    showSnackBar(title: 'Saved', message: 'Category style updated.');
  }

  Future<String?> exportCsv() async {
    try {
      final directory = await _exportsDirectory();
      final file = File(
        '${directory.path}/expenses_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv',
      );
      final buffer = StringBuffer(
        'id,name,category,quantity,total_price,unit_price,date,note\n',
      );
      for (final item in items) {
        final quantity = item.quantity <= 0 ? 1 : item.quantity;
        buffer.writeln(
          [
            item.id,
            item.name,
            getCategoryName(item.category),
            quantity,
            item.price.toStringAsFixed(2),
            (item.price / quantity).toStringAsFixed(2),
            DateFormat('yyyy-MM-dd').format(item.date),
            item.note,
          ].map(_csvValue).join(','),
        );
      }
      await file.writeAsString(buffer.toString());
      showSnackBar(title: 'Exported', message: file.path);
      return file.path;
    } catch (_) {
      showSnackBar(title: 'Error', message: 'Could not export expenses.');
      return null;
    }
  }

  Future<String?> backupData() async {
    try {
      final directory = await _exportsDirectory();
      final file = File(
        '${directory.path}/backup_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json',
      );
      final data = {
        'createdAt': DateTime.now().toIso8601String(),
        'categories': categories
            .map((category) => {'id': category.id, 'name': category.name})
            .toList(),
        'items': items.map(_itemToMap).toList(),
        'templates': templates.map((template) => template.toMap()).toList(),
        'recurring': recurringExpenses
            .map((recurring) => recurring.toMap())
            .toList(),
        'wallets': wallets.map((wallet) => wallet.toMap()).toList(),
        'movements': movements.map((movement) => movement.toMap()).toList(),
        'goals': goals.map((goal) => goal.toMap()).toList(),
        'transactionRules': transactionRules
            .map((rule) => rule.toMap())
            .toList(),
        'budgets': budgets,
        'budgetRollover': budgetRollover,
        'categoryMeta': categoryMeta,
      };
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(data),
      );
      showSnackBar(title: 'Backup Created', message: file.path);
      return file.path;
    } catch (_) {
      showSnackBar(title: 'Error', message: 'Could not create backup.');
      return null;
    }
  }

  Future<void> restoreLatestBackup() async {
    try {
      final directory = await _exportsDirectory();
      final backups =
          directory
              .listSync()
              .whereType<File>()
              .where(
                (file) =>
                    file.path.contains('/backup_') &&
                    file.path.endsWith('.json'),
              )
              .toList()
            ..sort(
              (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
            );

      if (backups.isEmpty) {
        showSnackBar(title: 'No Backup', message: 'Create a backup first.');
        return;
      }

      final data = jsonDecode(await backups.first.readAsString()) as Map;
      await _categoryBox.clear();
      await _itemsBox.clear();
      await _templateBox.clear();
      await _recurringBox.clear();
      await _walletBox.clear();
      await _movementBox.clear();
      await _goalBox.clear();
      await _ruleBox.clear();
      await _budgetBox.clear();
      await _budgetRolloverBox.clear();
      await _categoryMetaBox.clear();

      for (final category in (data['categories'] as List? ?? [])) {
        final map = Map<String, dynamic>.from(category as Map);
        final categoryModel = CategoryModel(
          id: '${map['id']}',
          name: '${map['name']}',
        );
        await _categoryBox.put(categoryModel.id, categoryModel);
      }
      for (final item in (data['items'] as List? ?? [])) {
        final itemModel = _itemFromMap(Map<String, dynamic>.from(item as Map));
        await _itemsBox.put(itemModel.id, itemModel);
      }
      for (final template in (data['templates'] as List? ?? [])) {
        final map = Map<String, dynamic>.from(template as Map);
        await _templateBox.put('${map['id']}', map);
      }
      for (final recurring in (data['recurring'] as List? ?? [])) {
        final map = Map<String, dynamic>.from(recurring as Map);
        await _recurringBox.put('${map['id']}', map);
      }
      for (final wallet in (data['wallets'] as List? ?? [])) {
        final map = Map<String, dynamic>.from(wallet as Map);
        await _walletBox.put('${map['id']}', map);
      }
      for (final movement in (data['movements'] as List? ?? [])) {
        final map = Map<String, dynamic>.from(movement as Map);
        await _movementBox.put('${map['id']}', map);
      }
      for (final goal in (data['goals'] as List? ?? [])) {
        final map = Map<String, dynamic>.from(goal as Map);
        await _goalBox.put('${map['id']}', map);
      }
      for (final rule in (data['transactionRules'] as List? ?? [])) {
        final map = Map<String, dynamic>.from(rule as Map);
        await _ruleBox.put('${map['id']}', map);
      }
      for (final entry in Map<String, dynamic>.from(
        data['budgets'] as Map? ?? {},
      ).entries) {
        await _budgetBox.put(entry.key, (entry.value as num).toDouble());
      }
      for (final entry in Map<String, dynamic>.from(
        data['budgetRollover'] as Map? ?? {},
      ).entries) {
        await _budgetRolloverBox.put(entry.key, entry.value == true);
      }
      for (final entry in Map<String, dynamic>.from(
        data['categoryMeta'] as Map? ?? {},
      ).entries) {
        await _categoryMetaBox.put(
          entry.key,
          Map<String, dynamic>.from(entry.value as Map),
        );
      }

      loadAll();
      showSnackBar(title: 'Restored', message: 'Latest backup was restored.');
    } catch (_) {
      showSnackBar(title: 'Error', message: 'Could not restore backup.');
    }
  }

  String getCategoryName(String id) {
    return categories.firstWhereOrNull((category) => category.id == id)?.name ??
        'Unknown';
  }

  CategoryModel? getCategoryById(String id) {
    return categories.firstWhereOrNull((category) => category.id == id);
  }

  void fillQuickFromTemplate(ExpenseTemplate template) {
    quickNameController.text = template.name;
    quickCategoryId.value = template.category;
    quickPriceController.text = _formatInput(template.unitPrice);
    quickQuantityController.text = template.quantity.toString();
    quickNoteController.text = template.note;
  }

  void clearQuickForm() {
    quickNameController.clear();
    quickPriceController.clear();
    quickQuantityController.text = '1';
    quickNoteController.clear();
    quickSaveAsTemplate.value = false;
  }

  void clearMovementForm() {
    movementAmountController.clear();
    movementNoteController.clear();
  }

  Future<void> _recordMovement({
    required MoneyMovementType type,
    required double amount,
    String? walletId,
    String? toWalletId,
    String? linkedItemId,
    String? goalId,
    required String note,
  }) async {
    final movement = MoneyMovement(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: type,
      amount: amount,
      date: DateTime.now(),
      note: note,
      walletId: walletId,
      toWalletId: toWalletId,
      linkedItemId: linkedItemId,
      goalId: goalId,
    );

    if (walletId != null) {
      final multiplier = switch (type) {
        MoneyMovementType.income => 1.0,
        MoneyMovementType.expense => -1.0,
        MoneyMovementType.transfer => -1.0,
        MoneyMovementType.goal => -1.0,
      };
      await _adjustWallet(walletId, amount * multiplier);
    }
    if (type == MoneyMovementType.transfer && toWalletId != null) {
      await _adjustWallet(toWalletId, amount);
    }
    await _movementBox.put(movement.id, movement.toMap());
  }

  Future<void> _adjustWallet(String walletId, double delta) async {
    final raw = _walletBox.get(walletId);
    if (raw is! Map) return;
    final wallet = WalletAccount.fromMap(raw);
    await _walletBox.put(
      walletId,
      wallet.copyWith(balance: wallet.balance + delta).toMap(),
    );
  }

  String? _categoryFromRules(String name) {
    final normalized = name.toLowerCase();
    for (final rule in transactionRules) {
      if (rule.isActive && normalized.contains(rule.keyword.toLowerCase())) {
        return rule.category;
      }
    }
    return null;
  }

  double _sumForRange(DateTime start, DateTime end, {String? categoryId}) {
    return items
        .where((item) {
          final inRange = !item.date.isBefore(start) && item.date.isBefore(end);
          final matchesCategory =
              categoryId == null || item.category == categoryId;
          return inRange && matchesCategory;
        })
        .fold(0, (sum, item) => sum + item.price);
  }

  DateTime _todayStart({int daysAhead = 0}) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + daysAhead);
  }

  Map<String, dynamic> _itemToMap(ItemModel item) {
    return {
      'id': item.id,
      'name': item.name,
      'category': item.category,
      'price': item.price,
      'date': item.date.toIso8601String(),
      'note': item.note,
      'quantity': item.quantity,
    };
  }

  ItemModel _itemFromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: '${map['id']}',
      name: '${map['name']}',
      category: '${map['category']}',
      date: DateTime.tryParse('${map['date']}') ?? DateTime.now(),
      note: '${map['note'] ?? ''}',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  Future<Directory> _exportsDirectory() async {
    final base = await getApplicationDocumentsDirectory();
    final directory = Directory('${base.path}/my_expenses_exports');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return directory;
  }

  String _csvValue(Object? value) {
    final raw = '${value ?? ''}'.replaceAll('"', '""');
    return '"$raw"';
  }

  String _formatInput(double value) {
    if (value % 1 == 0) return value.toStringAsFixed(0);
    return value.toStringAsFixed(2);
  }
}
