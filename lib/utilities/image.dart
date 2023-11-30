import 'package:bamboo_chat/utilities/constants.dart';

String getAvatar(String url)
{
  if(url == "" || url == null)
    {
      return DEFAULT_AVATAR;
    }
  else
    {
      return url;
    }
}