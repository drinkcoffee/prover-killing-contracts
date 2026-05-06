// Copyright (c) Whatgame Studios 2024 - 2025
using UnityEngine;
using System;

namespace LoadTest {
    // Audit log to store an audit of activity in the game.
    public class AuditLog {
        public const string AUDIT_NEXT = "AUDIT_NEXT";
        public const string AUDIT_ENTRY = "AUDIT_ENTRY";
        public const uint LOG_SIZE = 300;

        public static void Log(string entry) {
            string timestamp = DateTime.Now.ToString("yyyyMMdd: HHmmss");
            string logEntry = $"{timestamp}: {entry}";
            Debug.Log(entry);
            
            uint index = getNext();
            string key = AUDIT_ENTRY + index.ToString();
            PlayerPrefs.SetString(key, logEntry);
            index = (index + 1) % LOG_SIZE;
            PlayerPrefs.SetInt(AUDIT_NEXT, (int) index);
        }

        public static string GetLogs() {
            uint startIndex = getNext();
            System.Text.StringBuilder logs = new System.Text.StringBuilder();
            logs.Append(getHeader());
            
            // Loop through all entries starting from the next position
            for (uint i = 0; i < LOG_SIZE; i++) {
                uint currentIndex = (startIndex + i) % LOG_SIZE;
                string entry = getLogEntry(currentIndex);
                if (!string.IsNullOrEmpty(entry)) {
                    if (logs.Length > 0) {
                        logs.AppendLine();
                    }
                    logs.Append(entry);
                }
            }
            
            return logs.ToString();
        }

        private static string getLogEntry(uint index) {
            string key = AUDIT_ENTRY + index.ToString();
            return PlayerPrefs.GetString(key, "");
        }

        private static uint getNext() {
            int next = PlayerPrefs.GetInt(AUDIT_NEXT, 0);
            return (uint) next;
        }

        private static string getHeader() {
            string version = Application.version;
            string device = SystemInfo.deviceModel;
            string operatingSystem = SystemInfo.operatingSystem;
            string screenWidth = Screen.width.ToString();
            string screenHeight = Screen.height.ToString();

            System.Text.StringBuilder info = new System.Text.StringBuilder();
            info.Append("Worcadian v");
            info.Append(version);
            info.AppendLine();

            info.Append(device);
            info.Append(", ");
            info.Append(operatingSystem);
            info.AppendLine();

            info.Append("Screen: height: ");
            info.Append(screenHeight);
            info.Append(", width: ");
            info.Append(screenWidth);
            info.AppendLine();
            
            return info.ToString();
        }
    }
}