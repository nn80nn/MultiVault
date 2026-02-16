import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/providers.dart';
import '../../domain/entities/password_health_result.dart';
import '../../domain/usecases/analyze_passwords.dart';

class PasswordHealthScreen extends ConsumerStatefulWidget {
  const PasswordHealthScreen({super.key});

  @override
  ConsumerState<PasswordHealthScreen> createState() =>
      _PasswordHealthScreenState();
}

class _PasswordHealthScreenState extends ConsumerState<PasswordHealthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  PasswordHealthResult? _result;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _analyze());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    final encryptionKey = ref.read(encryptionKeyProvider);
    if (encryptionKey == null) return;

    final vaultRepo = ref.read(vaultRepositoryProvider);
    final encryptionService = ref.read(encryptionServiceProvider);
    final entries = await vaultRepo.getAllEntriesForExport();

    final analyzer = AnalyzePasswords(encryptionService);
    final result = analyzer.analyze(entries, encryptionKey);

    if (mounted) {
      setState(() {
        _result = result;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Health'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Weak${_result != null ? ' (${_result!.weakPasswords.length})' : ''}',
            ),
            Tab(
              text: 'Reused${_result != null ? ' (${_result!.reusedPasswords.length})' : ''}',
            ),
            Tab(
              text: 'Old${_result != null ? ' (${_result!.oldPasswords.length})' : ''}',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildScoreCard(colorScheme),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildIssueList(_result!.weakPasswords, Icons.warning_amber_rounded, Colors.orange),
                      _buildIssueList(_result!.reusedPasswords, Icons.copy_rounded, Colors.red),
                      _buildIssueList(_result!.oldPasswords, Icons.schedule_rounded, Colors.blue),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildScoreCard(ColorScheme colorScheme) {
    final result = _result!;
    final score = result.score;
    final scoreColor = score >= 80
        ? Colors.green
        : score >= 50
            ? Colors.orange
            : Colors.red;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 8,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    color: scoreColor,
                  ),
                  Text(
                    '$score',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: scoreColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    score >= 80
                        ? 'Good health'
                        : score >= 50
                            ? 'Needs improvement'
                            : 'Critical issues',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${result.totalEntries} passwords analyzed, '
                    '${result.totalIssues} issues found',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueList(
    List<HealthIssue> issues,
    IconData icon,
    Color iconColor,
  ) {
    if (issues.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.green.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              'No issues found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(icon, color: iconColor),
            title: Text(issue.entry.title),
            subtitle: Text(issue.description),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/vault/${issue.entry.id}'),
          ),
        );
      },
    );
  }
}
