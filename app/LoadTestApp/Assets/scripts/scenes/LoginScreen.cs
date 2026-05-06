// Copyright (c) Whatgame Studios 2024 - 2025
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;
using System;
using System.Collections;
using System.Collections.Generic;
using Immutable.Passport;
using System.Threading.Tasks;

namespace LoadTest {

    public class LoginScreen : MonoBehaviour {

        public Button loginButton;

        private Coroutine loginCheckRoutine;
        private bool isRunning = false;


        public async Task Start() {
            AuditLog.Log("Login screen");
            PassportStore.SetLoggedIn(false);
            await PassportLogin.Init();
            startCoroutine();
        }

        public void OnDisable() {
            stopCoroutine();
        }


        public async void OnButtonClick(string buttonText) {
            if (buttonText == "Login") {
                PassportStore.SetChoseToNotLogin(false);

                //Debug.Log("LoginPKCE start");
// #if (UNITY_ANDROID && !UNITY_EDITOR_WIN) || (UNITY_IPHONE && !UNITY_EDITOR_WIN) || UNITY_STANDALONE_OSX
//                await Passport.Instance.LoginPKCE();
// #else
               await Passport.Instance.Login();
//#endif
//                Debug.Log("LoginPKCE done");
            }
            else {
                AuditLog.Log("Login Screen: Unknown button");
            }
        }

        private void startCoroutine() {
            if (!isRunning) {
                loginCheckRoutine = StartCoroutine(LoginCheckRoutine());
                isRunning = true;
            }
        }

        public void stopCoroutine() {
            if (isRunning && loginCheckRoutine != null) {
                StopCoroutine(loginCheckRoutine);
                isRunning = false;
            }
        }

        IEnumerator LoginCheckRoutine() {
            while (true) {
                CheckLogin();
                yield return new WaitForSeconds(1f);
            }
        }

        private async void CheckLogin() {
            bool loggedIn = await Passport.Instance.HasCredentialsSaved();
            AuditLog.Log("CheckLogin: Loggedin: " + loggedIn);
            if (loggedIn) {
                PassportStore.SetLoggedIn(true);
                PassportStore.SetLoggedInChecked();
                DeepLinkManager.Instance.LoginPath = DeepLinkManager.LOGIN_THREAD;
                SceneManager.LoadScene("LoadTestScene", LoadSceneMode.Single);
                stopCoroutine();
            }
        }
    }
}