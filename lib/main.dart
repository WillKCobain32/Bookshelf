import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Theme/app_theme.dart';
import 'repositories/auth_repository.dart';
import 'repositories/livro_repository_mock.dart';
import 'repositories/review_repository.dart';
import 'viewsmodel/auth_viewmodel.dart';
import 'viewsmodel/diary_viewmodel.dart';
import 'viewsmodel/home_viewmodel.dart';
import 'viewsmodel/profile_viewmodel.dart';
import 'viewsmodel/search_viewmodel.dart';
import 'views/auth/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Repositorios
        Provider<AuthRepository>(create: (_) => InMemoryAuthRepository()),
        Provider<BookRepository>(create: (_) => InMemoryBookRepository()),
        Provider<ReviewRepository>(create: (_) => InMemoryReviewRepository()),

        // ViewModels
        ChangeNotifierProvider<AuthViewModel>(
          create: (c) => AuthViewModel(authRepository: c.read<AuthRepository>()),
        ),
        ChangeNotifierProvider<HomeViewModel>(
          create: (c) => HomeViewModel(
            bookRepository: c.read<BookRepository>(),
            reviewRepository: c.read<ReviewRepository>(),
          ),
        ),
        ChangeNotifierProvider<SearchViewModel>(
          create: (c) => SearchViewModel(bookRepository: c.read<BookRepository>()),
        ),
        ChangeNotifierProvider<DiaryViewModel>(
          create: (c) => DiaryViewModel(
            bookRepository: c.read<BookRepository>(),
            reviewRepository: c.read<ReviewRepository>(),
          ),
        ),
        ChangeNotifierProvider<ProfileViewModel>(
          create: (c) => ProfileViewModel(reviewRepository: c.read<ReviewRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Bookish',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const LoginPage(),
      ),
    );
  }
}