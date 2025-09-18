import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// A centralized class for managing all icons in the app.
/// This makes it easier to update icons across the app and maintain consistency.
class AppIcons {
  // Navigation Icons
  static const IconData home = Icons.home_rounded;
  static const IconData profile = Icons.person_rounded;
  static const IconData bazaar = Icons.store_rounded;
  static const IconData wallet = Icons.account_balance_wallet_rounded;
  static const IconData history = Icons.history_rounded;
  static const IconData results = Icons.emoji_events_rounded;
  static const IconData support = Icons.support_agent_rounded;
  static const IconData userAvatar = Icons.person_outline_rounded;
  static const IconData logout = Icons.logout_rounded;
  
  // Game Icons
  static const IconData play = Icons.play_arrow_rounded;
  static const IconData crown = Icons.emoji_events_rounded;
  static const IconData trophy = Icons.emoji_events_outlined;
  static const IconData dice = Icons.casino_rounded;
  static const IconData cards = Icons.games_rounded;
  static const IconData money = Icons.monetization_on_rounded;
  static const IconData bet = Icons.attach_money_rounded;
  
  // Action Icons
  static const IconData add = Icons.add_rounded;
  static const IconData edit = Icons.edit_rounded;
  static const IconData delete = Icons.delete_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData check = Icons.check_circle_rounded;
  static const IconData error = Icons.error_rounded;
  static const IconData filter = Icons.filter_list_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData copy = Icons.content_copy_rounded;
  static const IconData notification = Icons.notifications_rounded;
  static const IconData settings = Icons.settings_rounded;
  static const IconData info = Icons.info_rounded;
  static const IconData share = Icons.share_rounded;
  static const IconData star = Icons.star_rounded;
  static const IconData starBorder = Icons.star_border_rounded;
  static const IconData starHalf = Icons.star_half_rounded;
  
  // Navigation Icons
  static const IconData back = Icons.arrow_back_ios_rounded;
  static const IconData forward = Icons.arrow_forward_ios_rounded;
  static const IconData menu = Icons.menu_rounded;
  static const IconData more = Icons.more_vert_rounded;
  static const IconData refresh = Icons.refresh_rounded;
  static const IconData gamepad = Icons.gamepad_rounded;
  static const IconData clock = Icons.access_time_rounded;
  static const IconData stop = Icons.stop_circle_rounded;
  
  // Status Icons
  static const IconData playing = Icons.play_circle_rounded;
  static const IconData paused = Icons.pause_circle_rounded;
  static const IconData stopped = Icons.stop_circle_rounded;
  static const IconData pending = Icons.pending_rounded;
  static const IconData blocked = Icons.block_rounded;
  static const IconData disabled = Icons.do_not_disturb_on_rounded;
  static const IconData warning = Icons.warning_rounded;
  
  // Icon Utilities
  static Icon material(IconData icon, {double? size, Color? color}) {
    return Icon(icon, size: size, color: color);
  }
  
  static FaIcon awesome(IconData icon, {double? size, Color? color}) {
    return FaIcon(icon, size: size, color: color);
  }
  
  // Social Icons
  static const IconData facebook = Icons.facebook_rounded;
  static const IconData twitter = Icons.sports_basketball;
  static const IconData instagram = Icons.photo_camera_rounded;
  static const IconData whatsapp = Icons.messenger_rounded;
  static const IconData youtube = Icons.play_arrow_rounded;
  static const IconData telegram = Icons.send_rounded;
  
  // Payment Icons
  static const IconData creditCard = Icons.credit_card_rounded;
  static const IconData cashOnDelivery = Icons.payments_rounded;
  static const IconData netBanking = Icons.account_balance_rounded;
  static const IconData upi = Icons.mobile_friendly_rounded;
  static const IconData wallet_payment = Icons.account_balance_wallet_rounded;
  
  // Others
  static const IconData camera = Icons.camera_alt_rounded;
  static const IconData gallery = Icons.photo_library_rounded;
  static const IconData location = Icons.location_on_rounded;
  static const IconData phone = Icons.phone_rounded;
  static const IconData email = Icons.email_rounded;
  static const IconData password = Icons.lock_rounded;
  static const IconData lock = Icons.lock_rounded;
  static const IconData eye = Icons.visibility_rounded;
  static const IconData eyeOff = Icons.visibility_off_rounded;
  static const IconData passwordVisible = Icons.visibility_rounded;
  static const IconData passwordHidden = Icons.visibility_off_rounded;
  static const IconData calendar = Icons.calendar_today_rounded;
  static const IconData time = Icons.access_time_rounded;
  static const IconData help = Icons.help_rounded;
  static const IconData about = Icons.info_rounded;
  static const IconData report = Icons.report_problem_rounded;
  static const IconData upload = Icons.upload_rounded;
  static const IconData download = Icons.download_rounded;
  static const IconData favorite = Icons.favorite_rounded;
  static const IconData favoriteBorder = Icons.favorite_border_rounded;
  static const IconData bookmark = Icons.bookmark_rounded;
  static const IconData bookmarkBorder = Icons.bookmark_border_rounded;
  static const IconData send = Icons.send_rounded;
  static const IconData attachment = Icons.attach_file_rounded;
  static const IconData link = Icons.link_rounded;
  static const IconData verified = Icons.verified_rounded;
  static const IconData unverified = Icons.gpp_bad_rounded;
  static const IconData discount = Icons.local_offer_rounded;
  static const IconData gift = Icons.card_giftcard_rounded;
  static const IconData chart = Icons.bar_chart_rounded;
  static const IconData analytics = Icons.analytics_rounded;
  static const IconData trending = Icons.trending_up_rounded;
  static const IconData language = Icons.language_rounded;
  static const IconData theme = Icons.palette_rounded;
  static const IconData list = Icons.list_rounded;
  static const IconData grid = Icons.grid_view_rounded;
  static const IconData sort = Icons.sort_rounded;
  static const IconData filter_alt = Icons.filter_alt_rounded;
}