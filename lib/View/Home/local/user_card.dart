import 'package:flutter/material.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/users_model.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/cached_img.dart';

class PersonCashCard extends StatelessWidget {
  const PersonCashCard({
    super.key,
    required this.user,
  });

  final UsersModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          decoration: AppTheme.neuDecoration.copyWith(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: KCachedImg(url: user.photo).provider),
                ),
              ),
              const SizedBox(height: 10),
              Text(user.name, style: context.textTheme.bodyLarge),
              // const SizedBox(height: 10),
              Text(user.total.toCurrency, style: context.textTheme.titleLarge),
            ],
          ),
        ),
      ],
    );
  }
}
