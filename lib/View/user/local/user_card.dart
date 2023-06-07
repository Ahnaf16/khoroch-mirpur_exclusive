import 'package:flutter/material.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/users_model.dart';
import 'package:khoroch/routes/route_config.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/cached_img.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.user,
  });

  final UsersModel user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushTo(RouteName.user(user.uid));
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(15),
            decoration: AppTheme.neuDecoration.copyWith(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Hero(
                  tag: user.uid,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: KCachedImg(url: user.photo).provider),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.name.split(' ').first,
                      style: context.textTheme.bodyLarge,
                    ),
                    if (user.canAdd)
                      const Icon(
                        Icons.verified_outlined,
                        size: 18,
                      ),
                  ],
                ),
                // const SizedBox(height: 10),
                Text(user.total.toCurrency,
                    style: context.textTheme.titleLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
