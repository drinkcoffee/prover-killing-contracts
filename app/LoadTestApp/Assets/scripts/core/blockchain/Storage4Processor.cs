// Copyright (c) Whatgame Studios 2024 - 2026
using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
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

using LoadTest.Storage4;
using LoadTest.Storage4.ContractDefinition;

namespace LoadTest {

    public class Storage4Processor : ContractExecution {

        private Storage4Service service;

        public const string SEED_WORD_CONTRACT = "0xaf14a6EC2a10E7c193e3ef0762Ca320267A6571D";

        public Storage4Processor() : base(SEED_WORD_CONTRACT) {
            var web3 = new Web3(RPC_URL);
            service = new Storage4Service(web3, contractAddress);
        }

    //     public async Task<bool> AddSeedWords(List<string> words) {
    //         var func = new AddSeedWordsFunction() {
    //             Words = words,
    //         };
    //         var (success, _) = await executeTransaction(func.GetCallData());
    //         return success;
    //     }


    //    public async Task<uint> SeedWordCount() {
    //         BigInteger seedWordCountInt = await service.SeedWordCountQueryAsync();
    //         if (seedWordCountInt < 0 || seedWordCountInt > uint.MaxValue) {
    //             AuditLog.Log($"ERROR: SeedWordCountInt {seedWordCountInt} is outside uint range");
    //             // Use 7 to indicate an error.
    //             return 7;
    //         }
    //         else {
    //             return (uint) seedWordCountInt;
    //         }
    //     }

    //     public async Task<string> GetSeedWord(int gameDay) {
    //         return await service.GetSeedWordQueryAsync(new BigInteger(gameDay));
    //     }

    }
}
