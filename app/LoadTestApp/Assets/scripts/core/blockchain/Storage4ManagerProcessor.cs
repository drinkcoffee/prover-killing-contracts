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

        public const string CHECK_IN_CONTRACT = "0x7e70b51a3090753593aaafedf26536ed2cbc26e8";

        public Storage4ManagerProcessor() : base(CHECK_IN_CONTRACT) {
            var web3 = new Web3(RPC_URL);
            service = new Storage4ManagerService(web3, contractAddress);
        }


        // public async Task<bool> SubmitCheckIn(uint gameDay) {
        //     var func = new CheckInFunction() {
        //         GameDay = gameDay,
        //     };
        //     var (success, _) = await executeTransaction(func.GetCallData());
        //     return success;
        // }

    }
}
