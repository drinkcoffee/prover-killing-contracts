// Copyright (c) Whatgame Studios 2024 - 2025
using UnityEngine;
using System;

namespace LoadTest {
    public class PassportStore {
        public const string PASS_LOGGED_IN = "PASS_LOGGED_IN";
        public const string PASS_WHEN_LOGGED_IN = "PASS_WHEN_LOGGED_IN";
        public const string PASS_ACCOUNT = "PASS_ACCOUNT";

        public const string PASS_CHOSE_NOT_TO_LOGIN = "PASS_CHOSE_NOT_TO_LOGIN";

        // Classify "recently" as five minutes.
        public const int RECENTLY_MS = 1000 * 60 * 5;

        public static bool IsLoggedIn() {
            return PlayerPrefs.GetInt(PASS_LOGGED_IN, 0) != 0;
        }

        public static void SetLoggedIn(bool isLoggedIn) {
            if (isLoggedIn) {
                PlayerPrefs.SetInt(PASS_LOGGED_IN, 1);
            }
            else {
                PlayerPrefs.SetInt(PASS_LOGGED_IN, 0);
            }
            PlayerPrefs.Save();
        }

        public static bool ChoseToNotLogin() {
            return PlayerPrefs.GetInt(PASS_CHOSE_NOT_TO_LOGIN, 0) != 0;
        }

        public static void SetChoseToNotLogin(bool skipLogin) {
            if (skipLogin) {
                PlayerPrefs.SetInt(PASS_CHOSE_NOT_TO_LOGIN, 1);
            }
            else {
                PlayerPrefs.SetInt(PASS_CHOSE_NOT_TO_LOGIN, 0);
            }
            PlayerPrefs.Save();
        }


        public static bool WasLoggedInRecently() {
            string whenLoggedInStr = PlayerPrefs.GetString(PASS_WHEN_LOGGED_IN, "0");
            long whenLoggedIn = Int64.Parse(whenLoggedInStr);
            double elapsed = (DateTime.Now - new DateTime(whenLoggedIn)).TotalMilliseconds;
            return ((int) elapsed < RECENTLY_MS);
        }

        public static void SetLoggedInChecked() {
            PlayerPrefs.SetString(PASS_WHEN_LOGGED_IN, (DateTime.Now.Ticks).ToString());
        }

        public static string GetPassportAccount() {
            return PlayerPrefs.GetString(PASS_ACCOUNT, "");
        }

        public static void SetPassportAccount(string account) {
            PlayerPrefs.SetString(PASS_ACCOUNT, account);
        }
    }
}