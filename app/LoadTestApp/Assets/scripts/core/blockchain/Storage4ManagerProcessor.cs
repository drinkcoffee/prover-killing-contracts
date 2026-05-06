// Copyright (c) Whatgame Studios 2024 - 2026
using UnityEngine;
using System;
using System.Collections;
using System.Numerics;
using System.Threading.Tasks;
using System.Text;

using Nethereum.Web3;
using Nethereum.Contracts;
using Nethereum.Web3.Accounts;
using Nethereum.Hex.HexTypes;
using Nethereum.ABI.Encoders;
using Nethereum.ABI;

using Immutable.Passport;
using Immutable.Passport.Model;

using LoadTest.Storage4Manager;
using LoadTest.Storage4Manager.ContractDefinition;

namespace LoadTest {

    public class Storage4ManagerProcessor : ContractExecution {

        private Storage4ManagerService service;

        public const string CONTRACT = "0x274a67578ffdbbca5c600a694fe59f57fb8a043a";

        public Storage4ManagerProcessor() : base(CONTRACT) {
            var web3 = new Web3(RPC_URL);
            service = new Storage4ManagerService(web3, contractAddress);
        }


        public async Task<bool> Deploy(uint numToDeploy) {
            var func = new DeployFunction() {
                Iteration = numToDeploy,
            };
            var (success, _) = await executeTransaction(func.GetCallData());
            return success;
        }

    }
}
