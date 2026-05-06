// Copyright (c) Whatgame Studios 2024 - 2025
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;
using System;


namespace LoadTest {

    public class UnexpectedErrorScreen : MonoBehaviour {

        public void Start() {
            AuditLog.Log("Unexpected Error screen");
        }

        public void OnButtonClick(string buttonText) {
            SceneManager.LoadScene("LoginScene", LoadSceneMode.Single);
        }
    }
}