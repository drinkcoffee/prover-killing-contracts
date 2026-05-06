// Copyright (c) Whatgame Studios 2024 - 2025
using UnityEngine;

namespace LoadTest {
    public class MessagePass {

        private static string errorMsg = "";
        private static string message = "";


        public static void SetErrorMsg(string msg) {
            errorMsg = msg;
        }

        public static string GetErrorMsg() {
            return errorMsg;
        }

        public static void SetMsg(string msg) {
            message = msg;
        }

        public static string GetMsg() {
            return message;
        }
    }
}