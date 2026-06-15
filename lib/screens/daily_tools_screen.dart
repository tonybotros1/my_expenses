import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../consts.dart';
import '../controllers/daily_tools_controller.dart';
import '../controllers/settings_controller.dart';
import '../models/category_model.dart';
import '../models/expense_template.dart';
import '../models/recurring_expense.dart';
import '../models/spending_goal.dart';
import '../models/transaction_rule.dart';
import '../models/wallet_account.dart';
import '../widgets/custom_field.dart';

class DailyToolsScreen extends StatelessWidget {
  DailyToolsScreen({super.key});

  final DailyToolsController _toolsController =
      Get.isRegistered<DailyToolsController>()
      ? Get.find<DailyToolsController>()
      : Get.put(DailyToolsController(), permanent: true);
  final SettingsController _settingsController =
      Get.isRegistered<SettingsController>()
      ? Get.find<SettingsController>()
      : Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('Daily Tools', style: textFontForAppBar)),
      body: Obx(() {
        if (!_toolsController.isReady.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: EdgeInsets.all(16.r),
          children: [
            _moneyOverview(context),
            SizedBox(height: 24.h),
            _sectionHeader(
              context,
              title: 'Wallets',
              icon: Icons.account_balance_wallet_outlined,
              onPressed: () => _showWalletDialog(context),
            ),
            _walletSection(context),
            SizedBox(height: 24.h),
            _sectionHeader(
              context,
              title: 'Goals',
              icon: Icons.flag_outlined,
              onPressed: () => _showGoalDialog(context),
            ),
            _goalSection(context),
            SizedBox(height: 24.h),
            _sectionTitle(context, 'Monthly Budgets'),
            _budgetSection(context),
            SizedBox(height: 24.h),
            _sectionHeader(
              context,
              title: 'Expense Templates',
              icon: Icons.bookmark_add_outlined,
              onPressed: () => _showTemplateDialog(context),
            ),
            _templateSection(context),
            SizedBox(height: 24.h),
            _sectionHeader(
              context,
              title: 'Recurring Expenses',
              icon: Icons.event_repeat,
              onPressed: () => _showRecurringDialog(context),
            ),
            _recurringSection(context),
            SizedBox(height: 24.h),
            _sectionHeader(
              context,
              title: 'Rules',
              icon: Icons.rule,
              onPressed: () => _showRuleDialog(context),
            ),
            _rulesSection(context),
            SizedBox(height: 24.h),
            _sectionTitle(context, 'Insights'),
            _insightsSection(context),
            SizedBox(height: 24.h),
            _sectionTitle(context, 'Data'),
            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Column(
                children: [
                  _actionTile(
                    context,
                    icon: Icons.file_download_outlined,
                    title: 'Export CSV',
                    subtitle: 'Create a spreadsheet-friendly expense file',
                    onTap: _toolsController.exportCsv,
                  ),
                  const Divider(),
                  _actionTile(
                    context,
                    icon: Icons.backup_outlined,
                    title: 'Backup',
                    subtitle: 'Save all expenses, budgets, and templates',
                    onTap: _toolsController.backupData,
                  ),
                  const Divider(),
                  _actionTile(
                    context,
                    icon: Icons.restore_outlined,
                    title: 'Restore Latest Backup',
                    subtitle: 'Replace current data with the newest backup',
                    onTap: () => _confirmRestore(context),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _moneyOverview(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Safe to spend',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _money(_toolsController.safeToSpend),
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _overviewPill(
                  'Wallets',
                  _money(_toolsController.totalWalletBalance),
                  Icons.account_balance_wallet_outlined,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _overviewPill(
                  'Upcoming',
                  '${_toolsController.upcomingRecurringExpenses.length}',
                  Icons.event_repeat,
                ),
              ),
            ],
          ),
          if (_toolsController.upcomingRecurringExpenses.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              'Next: ${_toolsController.upcomingRecurringExpenses.first.name}',
              style: TextStyle(color: colorScheme.onPrimary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _overviewPill(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _walletSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (_toolsController.wallets.isEmpty) {
      return Column(
        children: [
          _emptyState(
            context,
            'Add cash, card, or bank wallets to track balances.',
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _showMoneyMovementDialog(context, isTransfer: false),
                  icon: const Icon(Icons.add),
                  label: const Text('Income'),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _showMoneyMovementDialog(context, isTransfer: true),
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('Transfer'),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 92.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _toolsController.wallets.length,
            separatorBuilder: (_, _) => SizedBox(width: 10.w),
            itemBuilder: (_, index) {
              final wallet = _toolsController.wallets[index];
              return Container(
                width: 180.w,
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            wallet.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showWalletDialog(context, wallet: wallet);
                            }
                            if (value == 'delete') {
                              _toolsController.deleteWallet(wallet.id);
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      _money(wallet.balance),
                      style: TextStyle(
                        color: wallet.balance < 0
                            ? Colors.redAccent
                            : mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () =>
                    _showMoneyMovementDialog(context, isTransfer: false),
                icon: const Icon(Icons.add),
                label: const Text('Income'),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () =>
                    _showMoneyMovementDialog(context, isTransfer: true),
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Transfer'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _goalSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (_toolsController.goals.isEmpty) {
      return _emptyState(
        context,
        'Create savings goals for trips, debt, or emergency funds.',
      );
    }

    return Column(
      children: _toolsController.goals.map((goal) {
        return Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      goal.name,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  Text('${(goal.progress * 100).toStringAsFixed(0)}%'),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showGoalDialog(context, goal: goal);
                      }
                      if (value == 'add') {
                        _showGoalContributionDialog(context, goal);
                      }
                      if (value == 'delete') {
                        _toolsController.deleteGoal(goal.id);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'add', child: Text('Add money')),
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  minHeight: 8.h,
                  value: goal.progress,
                  backgroundColor: colorScheme.outlineVariant,
                  valueColor: const AlwaysStoppedAnimation(mainColor),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text(
                    '${_money(goal.savedAmount)} saved',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                  const Spacer(),
                  Text(
                    '${_money(goal.remaining.clamp(0, double.infinity).toDouble())} left',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _budgetSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (_toolsController.categories.isEmpty) {
      return _emptyState(context, 'Add categories to create budgets.');
    }

    return Column(
      children: _toolsController.categories.map((category) {
        final budget = _toolsController.effectiveBudget(category.id);
        final spent = _toolsController.spentForCategoryThisMonth(category.id);
        final progress = _toolsController.progressForCategory(category.id);

        return Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    _toolsController.categoryIcon(category),
                    color: colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      category.name,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  Text(
                    '${_money(spent)} / ${_money(budget)}',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showBudgetDialog(context, category),
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  minHeight: 8.h,
                  value: progress,
                  backgroundColor: colorScheme.outlineVariant,
                  valueColor: AlwaysStoppedAnimation(
                    progress >= 0.9 ? Colors.redAccent : mainColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _templateSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (_toolsController.templates.isEmpty) {
      return _emptyState(context, 'Save repeated expenses as templates.');
    }

    return Column(
      children: _toolsController.templates.map((template) {
        return Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () =>
                    _toolsController.toggleTemplateFavorite(template),
                icon: Icon(
                  template.isFavorite ? Icons.star : Icons.star_border,
                  color: template.isFavorite ? Colors.amber : null,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      '${_toolsController.getCategoryName(template.category)} • ${_money(template.totalPrice)}',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () =>
                    _toolsController.addExpenseFromTemplate(template),
                icon: const Icon(Icons.add_circle_outline),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showTemplateDialog(context, template: template);
                  }
                  if (value == 'delete') {
                    _toolsController.deleteTemplate(template.id);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _recurringSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (_toolsController.recurringExpenses.isEmpty) {
      return Column(
        children: [
          _emptyState(context, 'Add monthly bills and subscriptions once.'),
          SizedBox(height: 10.h),
          OutlinedButton.icon(
            onPressed: () =>
                _toolsController.createDueRecurringExpenses(showMessage: true),
            icon: const Icon(Icons.refresh),
            label: const Text('Check recurring now'),
          ),
        ],
      );
    }

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton.icon(
            onPressed: () =>
                _toolsController.createDueRecurringExpenses(showMessage: true),
            icon: const Icon(Icons.refresh),
            label: const Text('Check now'),
          ),
        ),
        SizedBox(height: 8.h),
        ..._toolsController.recurringExpenses.map((recurring) {
          final nextDue = recurring.nextDueDate(DateTime.now());
          return Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                Switch(
                  value: recurring.isActive,
                  onChanged: (value) =>
                      _toolsController.toggleRecurring(recurring, value),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recurring.name,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        '${_toolsController.getCategoryName(recurring.category)} • ${_money(recurring.totalPrice)} • ${DateFormat.MMMd().format(nextDue)}',
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showRecurringDialog(context, recurring: recurring);
                    }
                    if (value == 'delete') {
                      _toolsController.deleteRecurring(recurring.id);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _rulesSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (_toolsController.transactionRules.isEmpty) {
      return _emptyState(context, 'Create rules like "Starbucks" -> Drinks.');
    }

    return Column(
      children: _toolsController.transactionRules.map((rule) {
        return Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Switch(
                value: rule.isActive,
                onChanged: (value) => _toolsController.toggleRule(rule, value),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rule.keyword,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _toolsController.getCategoryName(rule.category),
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') _showRuleDialog(context, rule: rule);
                  if (value == 'delete') _toolsController.deleteRule(rule.id);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _insightsSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: _toolsController.insights.map((insight) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.insights, color: mainColor, size: 20.sp),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    insight,
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _actionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: colorScheme.onSurfaceVariant),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _sectionHeader(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Row(
      children: [
        Expanded(child: _sectionTitle(context, title)),
        IconButton(onPressed: onPressed, icon: Icon(icon)),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context, String text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> _showWalletDialog(
    BuildContext context, {
    WalletAccount? wallet,
  }) {
    final name = TextEditingController(text: wallet?.name ?? '');
    final balance = TextEditingController(
      text: wallet == null ? '0' : wallet.balance.toStringAsFixed(2),
    );

    return Get.dialog(
      Dialog(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customLabeledTextField(label: 'Wallet', controller: name),
              SizedBox(height: 12.h),
              customLabeledTextField(
                label: 'Balance',
                controller: balance,
                isDouble: true,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    await _toolsController.saveWallet(
                      id: wallet?.id,
                      name: name.text,
                      balance: double.tryParse(balance.text.trim()) ?? 0,
                    );
                    Get.back();
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMoneyMovementDialog(
    BuildContext context, {
    required bool isTransfer,
  }) {
    final fromWallet = RxnString(
      _toolsController.movementWalletId.value ??
          (_toolsController.wallets.isEmpty
              ? null
              : _toolsController.wallets.first.id),
    );
    final toWallet = RxnString(
      _toolsController.wallets.length < 2
          ? null
          : _toolsController.wallets.last.id,
    );

    return Get.dialog(
      Dialog(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _walletDropdown(
                  label: isTransfer ? 'From' : 'Wallet',
                  selectedWallet: fromWallet,
                ),
                if (isTransfer) ...[
                  SizedBox(height: 12.h),
                  _walletDropdown(label: 'To', selectedWallet: toWallet),
                ],
                SizedBox(height: 12.h),
                customLabeledTextField(
                  label: 'Amount',
                  controller: _toolsController.movementAmountController,
                  isDouble: true,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 12.h),
                customLabeledTextField(
                  label: 'Note',
                  controller: _toolsController.movementNoteController,
                  isRequired: false,
                ),
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      final amount =
                          double.tryParse(
                            _toolsController.movementAmountController.text
                                .trim(),
                          ) ??
                          0;
                      if (isTransfer) {
                        await _toolsController.transferMoney(
                          fromWalletId: fromWallet.value ?? '',
                          toWalletId: toWallet.value ?? '',
                          amount: amount,
                          note: _toolsController.movementNoteController.text,
                        );
                      } else {
                        await _toolsController.addIncome(
                          walletId: fromWallet.value ?? '',
                          amount: amount,
                          note: _toolsController.movementNoteController.text,
                        );
                      }
                      Get.back();
                    },
                    child: Text(isTransfer ? 'Transfer' : 'Add Income'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _walletDropdown({
    required String label,
    required RxnString selectedWallet,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: selectedWallet.value,
      decoration: InputDecoration(labelText: label),
      items: _toolsController.wallets
          .map(
            (wallet) =>
                DropdownMenuItem(value: wallet.id, child: Text(wallet.name)),
          )
          .toList(),
      onChanged: (value) => selectedWallet.value = value,
    );
  }

  Future<void> _showGoalDialog(BuildContext context, {SpendingGoal? goal}) {
    final name = TextEditingController(text: goal?.name ?? '');
    final target = TextEditingController(
      text: goal == null ? '' : goal.targetAmount.toStringAsFixed(2),
    );
    final saved = TextEditingController(
      text: goal == null ? '0' : goal.savedAmount.toStringAsFixed(2),
    );

    return Get.dialog(
      Dialog(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customLabeledTextField(label: 'Goal', controller: name),
              SizedBox(height: 12.h),
              customLabeledTextField(
                label: 'Target',
                controller: target,
                isDouble: true,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12.h),
              customLabeledTextField(
                label: 'Saved',
                controller: saved,
                isDouble: true,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    await _toolsController.saveGoal(
                      id: goal?.id,
                      name: name.text,
                      targetAmount: double.tryParse(target.text.trim()) ?? 0,
                      savedAmount: double.tryParse(saved.text.trim()) ?? 0,
                    );
                    Get.back();
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showGoalContributionDialog(
    BuildContext context,
    SpendingGoal goal,
  ) {
    final amount = TextEditingController();
    final wallet = RxnString(
      _toolsController.wallets.isEmpty
          ? null
          : _toolsController.wallets.first.id,
    );
    return Get.dialog(
      Dialog(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_toolsController.wallets.isNotEmpty)
                _walletDropdown(label: 'Wallet', selectedWallet: wallet),
              SizedBox(height: 12.h),
              customLabeledTextField(
                label: 'Amount',
                controller: amount,
                isDouble: true,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    await _toolsController.addGoalContribution(
                      goal: goal,
                      amount: double.tryParse(amount.text.trim()) ?? 0,
                      walletId: wallet.value,
                    );
                    Get.back();
                  },
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showRuleDialog(BuildContext context, {TransactionRule? rule}) {
    final keyword = TextEditingController(text: rule?.keyword ?? '');
    final selectedCategory = RxnString(
      rule?.category ??
          (_toolsController.categories.isEmpty
              ? null
              : _toolsController.categories.first.id),
    );

    return Get.dialog(
      Dialog(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customLabeledTextField(label: 'Keyword', controller: keyword),
              SizedBox(height: 12.h),
              _categoryDropdown(context, selectedCategory),
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    final category = selectedCategory.value;
                    if (category == null) return;
                    await _toolsController.saveTransactionRule(
                      id: rule?.id,
                      keyword: keyword.text,
                      category: category,
                      isActive: rule?.isActive ?? true,
                    );
                    Get.back();
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showBudgetDialog(BuildContext context, CategoryModel category) {
    final controller = TextEditingController(
      text: (_toolsController.budgets[category.id] ?? 0).toStringAsFixed(2),
    );
    final rollover = (_toolsController.budgetRollover[category.id] == true).obs;
    return Get.dialog(
      Dialog(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                customLabeledTextField(
                  label: '${category.name} Budget',
                  controller: controller,
                  isDouble: true,
                  keyboardType: TextInputType.number,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: rollover.value,
                  title: const Text('Rollover unused money'),
                  onChanged: (value) => rollover.value = value,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        await _toolsController.deleteBudget(category.id);
                        await _toolsController.setBudgetRollover(
                          category.id,
                          false,
                        );
                        Get.back();
                      },
                      child: const Text('Clear'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        await _toolsController.setBudget(
                          category.id,
                          double.tryParse(controller.text.trim()) ?? 0,
                        );
                        await _toolsController.setBudgetRollover(
                          category.id,
                          rollover.value,
                        );
                        Get.back();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showTemplateDialog(
    BuildContext context, {
    ExpenseTemplate? template,
  }) {
    final name = TextEditingController(text: template?.name ?? '');
    final price = TextEditingController(
      text: template == null ? '' : template.unitPrice.toStringAsFixed(2),
    );
    final quantity = TextEditingController(text: '${template?.quantity ?? 1}');
    final note = TextEditingController(text: template?.note ?? '');
    final selectedCategory = RxnString(
      template?.category ??
          (_toolsController.categories.isEmpty
              ? null
              : _toolsController.categories.first.id),
    );
    final isFavorite = (template?.isFavorite ?? true).obs;

    return Get.dialog(
      Dialog(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customLabeledTextField(label: 'Name', controller: name),
              SizedBox(height: 12.h),
              _categoryDropdown(context, selectedCategory),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: customLabeledTextField(
                      label: 'Price',
                      controller: price,
                      isDouble: true,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: customLabeledTextField(
                      label: 'Qty',
                      controller: quantity,
                      isnumber: true,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              customLabeledTextField(label: 'Note', controller: note),
              SizedBox(height: 8.h),
              Obx(
                () => SwitchListTile(
                  value: isFavorite.value,
                  onChanged: (value) => isFavorite.value = value,
                  title: const Text('Favorite'),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    final category = selectedCategory.value;
                    if (category == null) return;
                    await _toolsController.saveTemplate(
                      id: template?.id,
                      name: name.text,
                      category: category,
                      unitPrice: double.tryParse(price.text.trim()) ?? -1,
                      quantity: int.tryParse(quantity.text.trim()) ?? 1,
                      note: note.text,
                      isFavorite: isFavorite.value,
                    );
                    Get.back();
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showRecurringDialog(
    BuildContext context, {
    RecurringExpense? recurring,
  }) {
    final name = TextEditingController(text: recurring?.name ?? '');
    final price = TextEditingController(
      text: recurring == null ? '' : recurring.unitPrice.toStringAsFixed(2),
    );
    final quantity = TextEditingController(text: '${recurring?.quantity ?? 1}');
    final day = TextEditingController(text: '${recurring?.dayOfMonth ?? 1}');
    final note = TextEditingController(text: recurring?.note ?? '');
    final selectedCategory = RxnString(
      recurring?.category ??
          (_toolsController.categories.isEmpty
              ? null
              : _toolsController.categories.first.id),
    );

    return Get.dialog(
      Dialog(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customLabeledTextField(label: 'Name', controller: name),
              SizedBox(height: 12.h),
              _categoryDropdown(context, selectedCategory),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: customLabeledTextField(
                      label: 'Price',
                      controller: price,
                      isDouble: true,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: customLabeledTextField(
                      label: 'Qty',
                      controller: quantity,
                      isnumber: true,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              customLabeledTextField(
                label: 'Day 1-28',
                controller: day,
                isnumber: true,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12.h),
              customLabeledTextField(label: 'Note', controller: note),
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    final category = selectedCategory.value;
                    if (category == null) return;
                    await _toolsController.saveRecurringExpense(
                      id: recurring?.id,
                      name: name.text,
                      category: category,
                      unitPrice: double.tryParse(price.text.trim()) ?? -1,
                      quantity: int.tryParse(quantity.text.trim()) ?? 1,
                      note: note.text,
                      dayOfMonth: int.tryParse(day.text.trim()) ?? 1,
                      isActive: recurring?.isActive ?? true,
                      lastCreatedMonth: recurring?.lastCreatedMonth,
                    );
                    Get.back();
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryDropdown(BuildContext context, RxnString selectedCategory) {
    return Obx(
      () => DropdownButtonFormField<String>(
        initialValue: selectedCategory.value,
        decoration: const InputDecoration(labelText: 'Category'),
        items: _toolsController.categories
            .map(
              (category) => DropdownMenuItem(
                value: category.id,
                child: Text(category.name),
              ),
            )
            .toList(),
        onChanged: (value) => selectedCategory.value = value,
      ),
    );
  }

  Future<void> _confirmRestore(BuildContext context) {
    return alertDialog(
      title: 'Restore Backup',
      middleText: 'This replaces current app data with the latest backup.',
      onPressed: () async {
        Get.back();
        await _toolsController.restoreLatestBackup();
      },
    );
  }

  String _money(double value) {
    return '${_settingsController.currency.value} ${NumberFormat('#,##0.00').format(value)}';
  }
}
