import 'dart:developer';

import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    try {
      final scopes = [
        // 'https://www.googleapis.com/auth/userinfo.email',
        'https://www.googleapis.com/auth/firebase.database',
        'https://www.googleapis.com/auth/firebase.messaging',
      ];

      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(
          {
            "type": "service_account",
            "project_id": "jop-project-6e8d3",
            "private_key_id": "59f601d97fb809dc7cddaa3daa93c2b8a087de3f",
            "private_key":
                "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDQupNWVcvaKLoa\nBe+yE/C0J4WjZx/CIIbz+SiKdp0eHxxvbbgDZIPc+EhY2LxNgZWAM3VkdepGZu5O\njP4Dm7NtQ/4HTV6191/vlZ9iZIXXwz/WjWY6Qg/+FIU8G/2yKa9ofF/2BZ1SckXT\nT8MhNLG7lCb3g2KsFkhbm8H1QOW2b7lyD+qniJBoeAjChGxwW2W8dUgIn05C/Vgw\nmOooBu8xrppPlh4zAC2d4oCAL8ztDgpVYgI0A4mP5CM+Qx8cZ5AAU76k21YMBEKm\nNo0/R2OKRfAuGwSZOKP7n6cYGzqQHG3zPozrKFNjUAZJjeDbyEVFAJR6tNP0Dm4B\n4+9s08Q/AgMBAAECggEAIEfSlIYVTkqBKZgkb1Z9IeeA1/oRY8zzAhVVC0D34Jow\nJB2EWWX4rLprOe5fBN+XFuoebCh+UGAH1/cfK8CvOaVLyqZREPROjneF3EouluVX\n4J8iobzoy0MyLc8oZ57hxVeC4cIRiBgrK1iJFYAYQqnRcvMLVhDmJODMWNkuDY4n\nT97kbiDS6c+C+l2llUkzS65uKP8DepG709ZuM6/kpeWWK1Stw7L5rDRLEk/nsX7o\n6aVJ46ZsAie3Uh7Mj+VIoFOflFBkD8rHEqKOKjP9ReLXEtuE2lmD2pMdXtuh9JGB\nIDjhEZXRftsZb7h7i5UxV6pcq8q+MKvloglqYybhOQKBgQDpArLZ3mP83J5aNyjP\nvxvo9opxW7PWu9dJ5+GBATuVuVGrUz4PhBvkreAXzBwctiz3HKILWhElL6HzY6QP\nMeMBm8koQLEag3iN+XZY3MbUltBZTM/EDh1TvLJjrbVT08IFZhOeP6b1sVYdxe/7\nptTwcbfeVC13Bfd8AbdEUWqu2QKBgQDlUpPA7su38Hdr/kcKehcsiD6sTrQ3WIrw\nGWbzf3jPscSaMpBHWh7i2pEB4F3yLXFcwhvtR7wFUQW+58pMgSixddloG6aUYrN3\nApx+xmSJGCfvd3YsIDThvaiNDigZrPJq1N/Vab/m9EAKqsspxHJKlj5Vr+7h45fD\nyxTaLFbM1wKBgQCspLE7uAlBm31AvsngU2ssiy88moN/QSJcwhBVc0JgxzR5ym2b\nNXktUJ9PQo45v8lFNtPhsVQux0IpgdRW5dGaqYC78GLIkEzMdN95K+uuLCgnYkA2\ntXaJSrCqJlTJzYZeVamHgQYF2OVDnhsXzB7OIJPpiVk+bQ9XtDXDysdO0QKBgGQd\n/SvKFV6kuT6IsPM+AkgK43HOmpdfLKlOLcg46sGiVrcLRDoiekGIMq6jCeDlPgzF\nIfQh0VBw4xVJlOR5rw5q6ROunrdBsCBRH4mpi9LenPDLMuho1y2G48NRXuh2vQ8v\nCNnfZUyrbho6HqCJh2xQ074NJTmxZ1yvmNb3bJ3ZAoGBAKhTEhEmP73KZJsqWFd5\nOj+9ssclkHE+L9f1omJnsNfGg2W1bJR3KkA8t1Qp63jMhYbRv1/JqPX84Tx5fw46\nB5HzUP9vZ+8AoyEZR6Ty7VKD2uZmVwOlx+17dTx2nYR2EWBatU1X8Vp9zgV1wX8n\nburu6pwJfrtrUz/5p+EbXf7L\n-----END PRIVATE KEY-----\n",
            "client_email":
                "firebase-adminsdk-fbsvc@jop-project-6e8d3.iam.gserviceaccount.com",
            "client_id": "110256562604526174216",
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "auth_provider_x509_cert_url":
                "https://www.googleapis.com/oauth2/v1/certs",
            "client_x509_cert_url":
                "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40jop-project-6e8d3.iam.gserviceaccount.com",
            "universe_domain": "googleapis.com"
          },
        ),
        scopes,
      );
      log(client.credentials.accessToken.type,
          name: 'client.credentials.accessToken.type');
      final accessServerKey = client.credentials.accessToken.data;
      return accessServerKey;
    } catch (e) {
      return e.toString();
    }
  }
}
