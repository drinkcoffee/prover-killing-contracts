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
    public class WelcomeScreen : MonoBehaviour
    {
        public async Task Start()
        {
            AuditLog.Log("Welcome screen");

            try
            {
                await PassportLogin.Init();

                // If the player is already logged in, then skip the login screen
                if (await Passport.Instance.HasCredentialsSaved())
                {
                   // Try to log in using saved credentials
                   bool success = await Passport.Instance.Login(useCachedSession: true);
                   PassportStore.SetLoggedIn(success);
                   if (success)
                   {
                        PassportStore.SetLoggedInChecked();
                        DeepLinkManager.Instance.LoginPath = DeepLinkManager.WELCOME;
                        SceneManager.LoadScene("MenuScene", LoadSceneMode.Single);
                    }
                    else
                    {
                        if (PassportStore.ChoseToNotLogin())
                        {
                            DeepLinkManager.Instance.LoginPath = DeepLinkManager.LOGIN_SKIP;
                            SceneManager.LoadScene("LoadTestScene", LoadSceneMode.Single);
                        }
                        else
                        {
                            SceneManager.LoadScene("LoginScene", LoadSceneMode.Single);                        
                        }
                    }
                }
                else
                {
                    if (PassportStore.ChoseToNotLogin())
                    {
                        DeepLinkManager.Instance.LoginPath = DeepLinkManager.LOGIN_SKIP;
                        SceneManager.LoadScene("LoadTestScene", LoadSceneMode.Single);
                    }
                    else
                    {
                        PassportStore.SetLoggedIn(false);
                        SceneManager.LoadScene("LoginScene", LoadSceneMode.Single);
                    }
                }
            }
            catch (Exception ex)
            {
                AuditLog.Log($"ERROR during start-up: {ex.Message}\nStack: {ex.StackTrace}");
                SceneManager.LoadScene("UnexpectedErrorScene", LoadSceneMode.Single);
            }
        }
    }
}
