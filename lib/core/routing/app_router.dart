import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/application/auth_notifier.dart';
import '../../features/auth/application/auth_state.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/splash_screen.dart';
import '../../features/expenses/presentation/screens/expense_add_edit_screen.dart';
import '../../features/expenses/presentation/screens/recurring_expense_list_screen.dart';
import '../../features/expenses/presentation/screens/tag_list_screen.dart';
import '../../features/reports/presentation/screens/reports_screen.dart';
import '../../features/budgets/presentation/screens/budget_list_screen.dart';
import '../../features/expenses/domain/entities/expense.dart';
import '../../features/categories/presentation/screens/category_list_screen.dart';
import '../../features/income/presentation/pages/income_list_page.dart';
import '../../features/income/presentation/pages/income_add_edit_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuth = authState is Authenticated;
      final isLoggingIn = state.matchedLocation.startsWith('/auth');

      if (!isAuth && !isLoggingIn && state.matchedLocation != '/') {
        return '/auth/sign-in';
      }

      if (isAuth && isLoggingIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/auth/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/expenses/add',
        builder: (context, state) => const ExpenseAddEditScreen(),
      ),
      GoRoute(
        path: '/expenses/edit',
        builder: (context, state) {
          final expense = state.extra as Expense?;
          return ExpenseAddEditScreen(expense: expense);
        },
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoryListScreen(),
      ),
      GoRoute(
        path: '/recurring-expenses',
        builder: (context, state) => const RecurringExpenseListScreen(),
      ),
      GoRoute(
        path: '/tags',
        builder: (context, state) => const TagListScreen(),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/budgets',
        builder: (context, state) => const BudgetListScreen(),
      ),
      GoRoute(
        path: '/incomes',
        builder: (context, state) => const IncomeListPage(),
      ),
      GoRoute(
        path: '/incomes/add',
        builder: (context, state) => const IncomeAddEditPage(),
      ),
      GoRoute(
        path: '/incomes/edit',
        builder: (context, state) {
          final income = state.extra as Income?;
          return IncomeAddEditPage(income: income);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
});
