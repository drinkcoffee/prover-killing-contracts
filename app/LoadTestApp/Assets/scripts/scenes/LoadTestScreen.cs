// Copyright (c) Whatgame Studios 2024 - 2026
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;
using System.Collections;
using System.Threading.Tasks;
using System;
using System.Collections.Generic;
using Immutable.Passport;




namespace LoadTest {
    public class LoadTestScreen : MonoBehaviour {

        public TextMeshProUGUI OutputText;
        public RectTransform ScrollContent;
        bool isProcessing = false;

        public TextMeshProUGUI loggedIn;


        System.Text.StringBuilder logs = new System.Text.StringBuilder();

        public async void Start() {
            AuditLog.Log("LoadTest screen");

            bool isLoggedIn = PassportStore.IsLoggedIn();
            if (isLoggedIn) {
                await PassportLogin.Init();
                await PassportLogin.Login();

                // Set up wallet (includes creating a wallet for new players)
                List<string> accounts = await Passport.Instance.ZkEvmRequestAccounts();
                if (accounts.Count ==0) {
                    loggedIn.text = "Logged In";
                }
                else {
                    string account = accounts[0];
                    loggedIn.text = "Logged In (" + 
                                    DeepLinkManager.Instance.LoginPath + 
                                    ") as\n" + 
                                    account;
                }
            }
            else 
            {
                loggedIn.text = "NOT Logged In";
            }
        }
        public void OnButtonClick(string buttonText) {
            if (isProcessing) {
                log("Busy");
                return;
            }

            if (buttonText == "Deploy")
            {
                Invoke("Deploy", 0.1f);
            }
            else
            {
                AuditLog.Log("Admin: Unknown button: " + buttonText);
            }
        }


        private async Task Deploy() {
            isProcessing = true;
            try {
                resetLog();
                log("DeployProcess: started");

                Storage4ManagerProcessor storage4ManagerProcessorContract = new Storage4ManagerProcessor();
                bool ok = await storage4ManagerProcessorContract.Deploy(1);
                log($"Execution ok:  {ok}");

                log("DeployProcess: done");
            }
            catch (Exception ex) {
                log($"Exception during admin process: {ex.Message}");
            }
            finally {
                isProcessing = false;
            }
        }


        private void resetLog() {
            logs = new System.Text.StringBuilder();
        }

        private void log(string str) {
            AuditLog.Log(str);
            logs.Append(str + '\n');

            OutputText.text = logs.ToString();

            // 1. Force TMP to calculate its heights immediately
            OutputText.ForceMeshUpdate();
            // 2. Get the preferred height (the actual space the letters take)
            float textHeight = OutputText.preferredHeight;
            // 3. Apply that height to the Scroll View's Content container
            ScrollContent.sizeDelta = new Vector2(ScrollContent.sizeDelta.x, textHeight);                

        }
    }
}


